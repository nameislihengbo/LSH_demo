"""
标准 Transformer 分类训练（字节级编码配置）

配置特点：
- 字节级编码：直接将文本编码为 UTF-8 字节序列
- 标准配置：dropout=0.0, lr=1e-3
- 对比基准：与 LSH-SFA 进行性能对比

对比测试：
- 本文件：字节级编码配置（标准配置）
- test_collapse_training.py：坍塌训练配置（dropout=0.1, label_smoothing=0.1, lr=5e-5）

运行方式:
    python test_transformer.py [ag_news|sst5]
"""

import os
os.environ["TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL"] = "1"

import time
import math
import sys
from dataclasses import dataclass

import torch
import torch.nn as nn
from torch.utils.data import Dataset, DataLoader
from torch.optim import Adam
from torch.optim.lr_scheduler import CosineAnnealingLR


@dataclass
class Config:
    vocab_size: int = 256
    d_model: int = 256
    n_layers: int = 4
    n_heads: int = 4
    d_ff: int = 1024
    max_seq_len: int = 256
    num_classes: int = 2
    dropout: float = 0.0
    batch_size: int = 32
    epochs: int = 100
    lr: float = 1e-3
    eval_interval: int = 5
    max_train_samples: int = 100000
    max_dev_samples: int = 10000


class Sst2Dataset(Dataset):
    def __init__(self, path: str, max_samples: int = 100000):
        self.samples = []
        self._load(path, max_samples)

    def _load(self, path: str, max_samples: int):
        with open(path, 'r', encoding='utf-8') as f:
            header = f.readline()
            for i, line in enumerate(f):
                if i >= max_samples:
                    break
                line = line.strip()
                if not line:
                    continue
                parts = line.split('\t')
                if len(parts) < 2:
                    continue
                text = parts[0]
                try:
                    label = int(parts[1])
                except ValueError:
                    continue
                self.samples.append((text, label))

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        return self.samples[idx]


class AGNewsDataset(Dataset):
    CLASS_NAMES = ["World", "Sports", "Business", "Sci/Tech"]

    def __init__(self, path: str, max_samples: int = 100000):
        self.samples = []
        self._load(path, max_samples)

    def _load(self, path: str, max_samples: int):
        with open(path, 'r', encoding='utf-8') as f:
            header = f.readline()
            for i, line in enumerate(f):
                if i >= max_samples:
                    break
                line = line.strip()
                if not line:
                    continue
                parts = line.split(',', 1)
                if len(parts) < 2:
                    continue
                try:
                    label = int(parts[0])
                    text = parts[1].strip('"')
                except (ValueError, IndexError):
                    continue
                self.samples.append((text, label))

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        return self.samples[idx]


class SST5Dataset(Dataset):
    CLASS_NAMES = ["very neg", "negative", "neutral", "positive", "very pos"]

    def __init__(self, path: str, max_samples: int = 100000):
        self.samples = []
        self._load(path, max_samples)

    def _load(self, path: str, max_samples: int):
        with open(path, 'r', encoding='utf-8') as f:
            header = f.readline()
            for i, line in enumerate(f):
                if i >= max_samples:
                    break
                line = line.strip()
                if not line:
                    continue
                parts = line.split('\t')
                if len(parts) < 2:
                    continue
                try:
                    text = parts[0]
                    label = int(parts[1])
                except (ValueError, IndexError):
                    continue
                self.samples.append((text, label))

    def __len__(self):
        return len(self.samples)

    def __getitem__(self, idx):
        return self.samples[idx]


def text_to_bytes(text: str, max_len: int) -> torch.Tensor:
    bytes_list = list(text.encode('utf-8'))[:max_len]
    padded = bytes_list + [0] * (max_len - len(bytes_list))
    return torch.tensor(padded, dtype=torch.long)


class PositionalEncoding(nn.Module):
    def __init__(self, d_model: int, max_len: int = 5000):
        super().__init__()
        pe = torch.zeros(max_len, d_model)
        position = torch.arange(0, max_len, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(torch.arange(0, d_model, 2).float() * (-math.log(10000.0) / d_model))
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        self.register_buffer('pe', pe.unsqueeze(0))

    def forward(self, x):
        return x + self.pe[:, :x.size(1), :]


class TransformerClassifier(nn.Module):
    def __init__(self, config: Config):
        super().__init__()
        self.config = config
        self.embedding = nn.Embedding(config.vocab_size, config.d_model)
        self.pos_encoding = PositionalEncoding(config.d_model, config.max_seq_len)
        encoder_layer = nn.TransformerEncoderLayer(
            d_model=config.d_model,
            nhead=config.n_heads,
            dim_feedforward=config.d_ff,
            dropout=config.dropout,
            batch_first=True,
            norm_first=True
        )
        self.transformer = nn.TransformerEncoder(encoder_layer, num_layers=config.n_layers)
        self.layer_norm = nn.LayerNorm(config.d_model)
        self.dropout = nn.Dropout(config.dropout)
        self.fc = nn.Linear(config.d_model, config.num_classes)

    def forward(self, x):
        x = self.embedding(x)
        x = self.pos_encoding(x)
        x = self.dropout(x)
        x = self.transformer(x)
        x = self.layer_norm(x)
        x = x.mean(dim=1)
        return self.fc(x)

    def count_parameters(self):
        return sum(p.numel() for p in self.parameters() if p.requires_grad)


def compute_accuracy(model, dataloader, device, num_classes):
    model.eval()
    correct = 0
    total = 0
    class_correct = [0] * num_classes
    class_total = [0] * num_classes

    with torch.no_grad():
        for texts, labels in dataloader:
            texts, labels = texts.to(device), labels.to(device)
            logits = model(texts)
            preds = logits.argmax(dim=1)

            for pred, label in zip(preds, labels):
                label = label.item()
                class_total[label] += 1
                if pred.item() == label:
                    correct += 1
                    class_correct[label] += 1
                total += 1

    accuracy = correct / total if total > 0 else 0
    per_class = [class_correct[i] / class_total[i] if class_total[i] > 0 else 0 for i in range(num_classes)]
    return accuracy, per_class


def train_epoch(model, dataloader, optimizer, scheduler, criterion, device, epoch=0):
    model.train()
    total_loss = 0
    num_batches = 0

    for batch_idx, (texts, labels) in enumerate(dataloader):
        texts, labels = texts.to(device), labels.to(device)
        optimizer.zero_grad()
        logits = model(texts)
        loss = criterion(logits, labels)
        loss.backward()

        grad_norms = {}
        total_norm = 0.0
        for name, param in model.named_parameters():
            if param.grad is not None:
                param_norm = param.grad.data.norm(2).item()
                total_norm += param_norm ** 2
                grad_norms[name] = param_norm
        total_norm = total_norm ** 0.5

        if num_batches == 0 or (num_batches + 1) % 50 == 0:
            print(f"  [Epoch {epoch+1} Batch {num_batches+1}] Grad Norm: {total_norm:.6f}")
            top_grads = sorted(grad_norms.items(), key=lambda x: x[1], reverse=True)[:5]
            for name, norm in top_grads:
                short_name = name.split('.')[-2] + '.' + name.split('.')[-1] if '.' in name else name
                print(f"    {short_name}: {norm:.6f}")

        torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
        optimizer.step()
        scheduler.step()

        total_loss += loss.item()
        num_batches += 1

    return total_loss / num_batches, total_norm


def main():
    data_dir = "e:/Github/lsh-workspace/lsh-protocol/rust/data"
    dataset_name_arg = sys.argv[1] if len(sys.argv) > 1 else "sst2"

    if dataset_name_arg == "ag_news":
        train_path = f"{data_dir}/ag_news/train_full.csv"
        dev_path = f"{data_dir}/ag_news/test_full.csv"
        config = Config()
        config.num_classes = 4
        class_names = AGNewsDataset.CLASS_NAMES
        dataset_name = "AG News (四分类)"
    elif dataset_name_arg == "sst5":
        train_path = f"{data_dir}/sst5/train.tsv"
        dev_path = f"{data_dir}/sst5/validation.tsv"
        config = Config()
        config.num_classes = 5
        class_names = SST5Dataset.CLASS_NAMES
        dataset_name = "SST-5 (五分类)"
    else:
        train_path = f"{data_dir}/sst2/SST-2/train.tsv"
        dev_path = f"{data_dir}/sst2/SST-2/dev.tsv"
        config = Config()
        class_names = ["Neg", "Pos"]
        dataset_name = "SST-2 (二分类)"

    device = "cuda" if torch.cuda.is_available() else "cpu"
    print(f"使用设备: {device}")

    print("\n" + "="*60)
    print("  标准 Transformer 分类训练 (对比基准)")
    print("="*60)
    print(f"\n数据集: {dataset_name}")
    print(f"配置:")
    print(f"  - d_model: {config.d_model}")
    print(f"  - n_layers: {config.n_layers}")
    print(f"  - n_heads: {config.n_heads}")
    print(f"  - d_ff: {config.d_ff}")
    print(f"  - dropout: {config.dropout}")
    print(f"  - max_seq_len: {config.max_seq_len}")

    print("\n加载数据集...")
    if dataset_name_arg == "ag_news":
        train_dataset = AGNewsDataset(train_path, config.max_train_samples)
        dev_dataset = AGNewsDataset(dev_path, config.max_dev_samples)
    elif dataset_name_arg == "sst5":
        train_dataset = SST5Dataset(train_path, config.max_train_samples)
        dev_dataset = SST5Dataset(dev_path, config.max_dev_samples)
    else:
        train_dataset = Sst2Dataset(train_path, config.max_train_samples)
        dev_dataset = Sst2Dataset(dev_path, config.max_dev_samples)

    def collate_fn(batch):
        texts, labels = zip(*batch)
        texts = [text_to_bytes(t, config.max_seq_len) for t in texts]
        texts = torch.stack(texts)
        labels = torch.tensor(labels, dtype=torch.long)
        return texts, labels

    train_loader = DataLoader(train_dataset, batch_size=config.batch_size, shuffle=True, collate_fn=collate_fn)
    dev_loader = DataLoader(dev_dataset, batch_size=config.batch_size, shuffle=False, collate_fn=collate_fn)

    print(f"训练集: {len(train_dataset)}, 开发集: {len(dev_dataset)}")

    model = TransformerClassifier(config).to(device)
    num_params = model.count_parameters()
    print(f"\n模型参数量: {num_params:,} ({num_params/1e6:.2f}M)")

    criterion = nn.CrossEntropyLoss()
    optimizer = Adam(model.parameters(), lr=config.lr)
    total_steps = len(train_loader) * config.epochs
    scheduler = CosineAnnealingLR(optimizer, T_max=total_steps, eta_min=1e-6)

    best_acc = 0
    best_epoch = 0

    print(f"\n开始训练...")

    print("\n【Epoch 0 初始预测】")
    model.eval()
    with torch.no_grad():
        all_preds = []
        all_labels = []
        for i, (texts, labels) in enumerate(dev_loader):
            if i >= 1:
                break
            texts, labels = texts.to(device), labels.to(device)
            logits = model(texts)
            preds = logits.argmax(dim=1)
            all_preds.extend(preds.cpu().tolist())
            all_labels.extend(labels.cpu().tolist())

        init_correct = sum(1 for p, l in zip(all_preds, all_labels) if p == l)
        init_acc = init_correct / len(all_preds) * 100
        pred_counts = [all_preds.count(i) for i in range(config.num_classes)]
        label_counts = [all_labels.count(i) for i in range(config.num_classes)]
        print(f"初始: {pred_counts} vs 真实 {label_counts}, Acc={init_acc:.1f}%")

    model.train()

    header = f"{'Epoch':>5} | {'Loss':>8} | {'Grad':>8} | {'Dev Acc':>8} |"
    for name in class_names:
        header += f" {name[:6]:>6} |"
    header += f" {'Time':>6}"
    print(header)
    print("-" * len(header))

    for epoch in range(config.epochs):
        start = time.time()
        avg_loss, grad_norm = train_epoch(model, train_loader, optimizer, scheduler, criterion, device, epoch=epoch)
        elapsed = time.time() - start

        if (epoch + 1) % config.eval_interval == 0 or epoch == config.epochs - 1:
            dev_acc, per_class = compute_accuracy(model, dev_loader, device, config.num_classes)

            marker = "*" if dev_acc > best_acc else ""
            grad_str = f"{grad_norm:8.4f}" if epoch == 0 or (epoch + 1) % 5 == 0 else "       -"
            row = f"{epoch+1:>5} | {avg_loss:>8.4f} | {grad_str} | {dev_acc*100:>7.1f}% |"
            for acc in per_class:
                row += f" {acc*100:>5.1f}% |"
            row += f" {elapsed:>5.1f}s  {marker}"
            print(row)

            if dev_acc > best_acc:
                best_acc = dev_acc
                best_epoch = epoch + 1
        else:
            row = f"{epoch+1:>5} | {avg_loss:>8.4f} | {'       -'} | {'-':>8} |"
            for _ in class_names:
                row += f" {'-':>6} |"
            row += f" {elapsed:>5.1f}s"
            print(row)

    print("\n" + "="*60)
    print("  训练完成")
    print("="*60)
    print(f"最佳开发集准确率: {best_acc*100:.2f}% (Epoch {best_epoch})")
    print(f"标准 Transformer (字节级编码): {best_acc*100:.2f}%")
    print(f"\n对比 LSH-SFA (1层, Rust):")
    print(f"  - LSH-SFA 准确率: ~59.3%")
    print(f"  - LSH-SFA 每步耗时: ~110s (字节结构编码)")
    print(f"  - Transformer 每步耗时: ~13s")
    print(f"  - 速度差异: LSH-SFA 慢 8.5x")
    print(f"\n配置对比:")
    print(f"  - 本文件：字节级编码配置 (dropout=0.0, lr=1e-3)")
    print(f"  - test_collapse_training.py：坍塌训练配置 (dropout=0.1, label_smoothing=0.1, lr=5e-5)")
    print("="*60)


if __name__ == "__main__":
    main()
