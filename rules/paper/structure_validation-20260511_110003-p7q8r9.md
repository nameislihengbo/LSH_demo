# Structure Validation Rules

**LSH ID**: structure_validation-20260511_110003-p7q8r9
**cat**: structure | **tags**: validation | **level**: standard | **version**: 1.0
**引用**: structure_foundation-20260511_110001-j1k2l3 | lsh-protocol/docs/SPEC.md

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | 验证方法论定义、测试类型分类 | 第一节~二节 |
| **Rule 规则层** | 对比测试规则、控制变量规则、泛化测试规则、可复现规则 | 第三~六节 |
| **Execution 执行层** | 验证检查清单 | 第七节 |

---

## 一、验证方法论 / Validation Methodology

### 1.1 验证四原则

| 原则 | 英文 | 核心要求 |
|------|------|----------|
| **对比测试** | Comparative Testing | 必须与基线方法对比 |
| **控制变量** | Controlled Variables | 每次实验只改变一个变量 |
| **泛化测试** | Generalization Testing | 跨数据集/场景验证 |
| **可复现** | Reproducibility | 他人可复现实验结果 |

### 1.2 验证层级

```
┌─────────────────────────────────────────────────────────────────────┐
│                    验证四原则递进关系                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Level 1: 可复现 (Reproducibility)                                  │
│  └── 基础：他人能跑通你的实验                                        │
│       ↓                                                              │
│  Level 2: 控制变量 (Controlled Variables)                           │
│  └── 科学：排除干扰因素                                              │
│       ↓                                                              │
│  Level 3: 对比测试 (Comparative Testing)                            │
│  └── 公正：与基线公平对比                                            │
│       ↓                                                              │
│  Level 4: 泛化测试 (Generalization Testing)                         │
│  └── 可信：跨场景验证有效性                                          │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 二、测试类型分类 / Test Type Classification

### 2.1 按验证目标分类

| 测试类型 | 验证目标 | 示例 |
|----------|----------|------|
| **单元测试** | 单个函数/方法正确性 | `test_element_creation()` |
| **对比测试** | 方法 A vs 方法 B | LSH-SFA vs Transformer |
| **消融实验** | 各组件贡献度 | 去掉光锥注意力后效果 |
| **泛化测试** | 跨数据集/场景 | 在 NLP 任务上测试时空模型 |
| **可复现测试** | 独立复现结果 | 不同硬件/种子复现 |

### 2.2 按三层架构分类

| 层级 | 测试类型 | 说明 |
|------|----------|------|
| **Structure** | 结构一致性测试 | 数据格式、类型映射、序列化 |
| **Rule** | 规则合规性测试 | 约束条件、边界条件、异常处理 |
| **Execution** | 执行验证测试 | 性能基准、对比基线、泛化场景 |

---

## 三、对比测试规则 / Comparative Testing Rules

### 3.1 基线选择

| 规则 | 要求 | 说明 |
|------|------|------|
| 必须有基线 | 至少一个对比方法 | 不能只报告自身结果 |
| 基线公平性 | 相同条件对比 | 相同数据、相同硬件、相同评估指标 |
| 基线最新性 | 优先选择 SOTA | 避免与过时方法对比 |

### 3.2 对比测试模板

```latex
\begin{table}[h]
\centering
\caption{Comparative Results}
\label{tab:comparative}
\begin{tabular}{l|c|c|c}
\toprule
\textbf{Method} & \textbf{Precision} & \textbf{Recall} & \textbf{F1} \\
\midrule
Baseline 1 (Transformer) & 88.5 & 85.2 & 86.8 \\
Baseline 2 (Performer) & 89.1 & 86.7 & 87.9 \\
\midrule
\textbf{LSH-SFA (Ours)} & \textbf{92.3} & \textbf{89.7} & \textbf{91.0} \\
\bottomrule
\end{tabular}
\end{table}
```

### 3.3 对比测试检查

- [ ] 至少一个基线方法
- [ ] 基线方法为领域 SOTA
- [ ] 相同评估指标
- [ ] 相同数据集划分
- [ ] 统计显著性检验（p-value < 0.05）

---

## 四、控制变量规则 / Controlled Variables Rules

### 4.1 控制变量原则

| 原则 | 说明 | 示例 |
|------|------|------|
| **单一变量** | 每次实验只改变一个变量 | 只改变注意力机制，其他不变 |
| **明确声明** | 列出所有控制变量 | "模型维度=512, 层数=6, 学习率=1e-4" |
| **固定种子** | 使用固定随机种子 | `torch.manual_seed(42)` |
| **硬件一致** | 同一硬件运行所有实验 | 同一 GPU，相同 CUDA 版本 |

### 4.2 控制变量模板

```markdown
## 实验配置

### 控制变量（固定）
| 变量 | 值 | 说明 |
|------|-----|------|
| 模型维度 | 512 | d_model |
| 层数 | 6 | num_layers |
| 学习率 | 1e-4 | AdamW |
| Batch Size | 32 | - |
| 训练轮数 | 100 | early stopping |
| 随机种子 | 42 | torch.manual_seed |
| GPU | RTX 4090 | CUDA 12.1 |

### 实验变量（变化）
| 实验 | 变量 | 值 |
|------|------|-----|
| Exp 1 | 注意力机制 | LSH-SFA |
| Exp 2 | 注意力机制 | Softmax |
| Exp 3 | 注意力机制 | Linear |
```

### 4.3 消融实验

```markdown
## 消融实验设计

| 实验 | 组件 | 移除的组件 | 效果 |
|------|------|-----------|------|
| Full Model | 全部 | - | F1=91.0 |
| - Light-cone | 去掉光锥注意力 | Light-cone | F1=87.3 (-3.7) |
| - PDE | 去掉 PDE 演化 | PDE | F1=88.1 (-2.9) |
| - Resonance | 去掉共振耦合 | Resonance | F1=89.5 (-1.5) |
```

### 4.4 控制变量检查

- [ ] 每次实验只改变一个变量
- [ ] 所有控制变量已明确声明
- [ ] 使用固定随机种子
- [ ] 硬件配置一致
- [ ] 消融实验覆盖所有核心组件

---

## 五、泛化测试规则 / Generalization Testing Rules

### 5.1 泛化维度

| 维度 | 说明 | 示例 |
|------|------|------|
| **跨数据集** | 不同数据集验证 | NLP → CV → 多模态 |
| **跨规模** | 不同规模验证 | 1K → 10K → 100K 样本 |
| **跨领域** | 不同领域验证 | 学术论文 → 工业应用 |
| **跨语言** | 不同语言验证 | Python → Rust → TypeScript |

### 5.2 泛化测试模板

```markdown
## 泛化测试

### 跨数据集
| 数据集 | 规模 | LSH-SFA | Baseline | 提升 |
|--------|------|---------|----------|------|
| Dataset A | 10K | 91.0 | 86.8 | +4.2 |
| Dataset B | 50K | 89.3 | 85.1 | +4.2 |
| Dataset C | 100K | 88.7 | 84.5 | +4.2 |

### 跨规模
| 规模 | LSH-SFA | Baseline | 加速比 |
|------|---------|----------|--------|
| 1K elements | 10ms | 50ms | 5x |
| 10K elements | 45ms | 500ms | 11x |
| 100K elements | 200ms | 3700ms | 18.5x |
```

### 5.3 LSH 协议泛化验证

参照 LSH 协议 SPEC.md 的三层架构，泛化测试应覆盖：

| 层级 | 泛化维度 | 验证方式 |
|------|----------|----------|
| **Structure** | 跨 category 泛化 | device/room/field/wave 均可表示为 Element |
| **Rule** | 跨 observer 泛化 | 不同 observer 对同一世界有不同感知 |
| **Execution** | 跨引擎泛化 | VTK/Godot/Three.js 均可渲染 |

### 5.4 泛化测试检查

- [ ] 至少 2 个不同数据集
- [ ] 至少 2 个不同规模
- [ ] 跨领域验证（如适用）
- [ ] 跨语言验证（如适用）
- [ ] 结果趋势一致（非偶然）

---

## 六、可复现规则 / Reproducibility Rules

### 6.1 可复现三要素

| 要素 | 要求 | 说明 |
|------|------|------|
| **代码开源** | 公开完整代码 | GitHub 仓库，含 README |
| **数据可获取** | 公开数据集或提供获取方式 | 下载链接或生成脚本 |
| **配置完整** | 公开所有超参数 | 配置文件或命令行参数 |

### 6.2 可复现配置模板

```markdown
## 复现指南

### 环境配置
\begin{verbatim}
# Python 环境
Python 3.10
PyTorch 2.1.0
CUDA 12.1

# 安装依赖
pip install -r requirements.txt

# Rust 环境 (如适用)
Rust 1.75.0
maturin 1.4.0
\end{verbatim}

### 运行命令
\begin{verbatim}
# 训练
python train.py --config configs/lsh_sfa.yaml --seed 42

# 评估
python evaluate.py --checkpoint checkpoints/best.pt --seed 42

# Rust 基准测试 (如适用)
cargo bench --features python-binding
\end{verbatim}

### 随机种子
| 组件 | 种子 |
|------|------|
| Python random | 42 |
| NumPy random | 42 |
| PyTorch manual_seed | 42 |
| CUDA deterministic | True |
```

### 6.3 LSH 协议可复现验证

参照 LSH 协议 SPEC.md 的元素结构，可复现性要求：

| 验证项 | SPEC.md 对应 | 要求 |
|--------|-------------|------|
| 元素结构一致 | Section 6: 数据结构 | Rust ↔ Python 输出一致 |
| 编解码一致 | Section 10: 世界存储 | LSH 编码 ↔ JSON 解码一致 |
| 事件一致 | Section 7: 事件系统 | 相同输入产生相同事件序列 |
| 坐标一致 | Section 9: 坐标系统 | LSH ↔ VTK ↔ Godot 坐标转换一致 |

### 6.4 可复现检查

- [ ] 代码已开源（GitHub 仓库）
- [ ] 数据集可获取
- [ ] 所有超参数已公开
- [ ] 随机种子已固定
- [ ] 硬件环境已说明
- [ ] 依赖版本已锁定（requirements.txt / Cargo.lock）
- [ ] 独立第三方可复现

---

## 七、验证检查清单 / Validation Checklist

### 7.1 LSH ID 可追溯性

- [ ] 实验结果关联 LSH ID（格式遵循 lsh_format.md §2.2 唯一抽象）
- [ ] LSH ID 格式：`{prefix}[_group...]-{timestamp}-{hash}`
- [ ] `-` 是唯一抽象，分隔语义部分与时间戳/哈希
- [ ] Checkpoint 路径包含 LSH ID

### 7.2 对比测试

- [ ] 至少一个基线方法
- [ ] 基线为领域 SOTA
- [ ] 相同评估指标
- [ ] 统计显著性检验

### 7.2 控制变量

- [ ] 每次实验只改变一个变量
- [ ] 控制变量已明确声明
- [ ] 固定随机种子
- [ ] 消融实验覆盖核心组件

### 7.3 泛化测试

- [ ] 至少 2 个不同数据集
- [ ] 至少 2 个不同规模
- [ ] 结果趋势一致

### 7.4 可复现

- [ ] 代码开源
- [ ] 数据可获取
- [ ] 超参数公开
- [ ] 种子固定
- [ ] 依赖锁定
- [ ] 独立可复现

---

*LSH ID: structure_validation-20260511_110003-p7q8r9*
