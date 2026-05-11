# Zenodo 发布指南

**版本**: v1.0
**日期**: 2026-05-12
**作者**: 李恒波

---

## 一、发布策略

### 1.1 多论文独立发布模式

LSH Protocol 采用 **单仓库多 Release** 模式，每篇论文独立发布到 Zenodo 获取独立 DOI：

```
GitHub: lsh-workspace/LSH_demo
├── v1.0-paper1  →  LSH-SFA Architecture (DOI: 10.5281/zenodo.xxxxx1)
├── v2.0-paper2  →  Three-Layer Architecture (DOI: 10.5281/zenodo.xxxxx2)
├── v3.0-paper3  →  LSH Format (DOI: 10.5281/zenodo.xxxxx3)
├── v4.0-paper4  →  Attention Comparison (DOI: 10.5281/zenodo.xxxxx4)
├── v5.0-paper5  →  Encoding & Gradient (DOI: 10.5281/zenodo.xxxxx5)
├── v6.0-paper6  →  Autoregressive Generation (DOI: 10.5281/zenodo.xxxxx6)
├── v7.0-paper7  →  Spacetime Cognition Deficit (DOI: 10.5281/zenodo.xxxxx7)
├── v8.0-paper8  →  LSH-Burn Implementation (DOI: 10.5281/zenodo.xxxxx8)
├── v9.0-paper9  →  LSH Rules (DOI: 10.5281/zenodo.xxxxx9)
└── v10.0-paper10 → Ternary Versioning (DOI: 10.5281/zenodo.xxxxx10)
```

### 1.2 Zenodo 配置文件位置

| 文件 | 位置 | 用途 |
|------|------|------|
| `.zenodo.json` | 仓库根目录 | Zenodo 读取的配置文件 |
| `*/.zenodo.json` | 各论文目录 | 论文元数据备份 |

**重要**: 发布时需要将目标论文的 `.zenodo.json` 内容复制到根目录。

---

## 二、发布流程

### 2.1 准备工作

1. **启用 Zenodo - GitHub 集成**
   - 访问 https://zenodo.org/account/settings/github/
   - 授权 `lsh-workspace` 仓库

2. **确认论文文件完整**
   - `main.tex` - 论文主体
   - `.zenodo.json` - 元数据配置

### 2.2 单篇论文发布步骤

以 **Paper 1: LSH-SFA** 为例：

```powershell
# Step 1: 切换到 main 分支
git checkout main
git pull origin main

# Step 2: 复制论文元数据到根目录
Copy-Item structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2/.zenodo.json .zenodo.json

# Step 3: 提交更改
git add .zenodo.json
git commit -m "chore: prepare release v1.0-paper1 LSH-SFA"

# Step 4: 创建 tag
git tag v1.0-paper1

# Step 5: 推送 tag
git push origin v1.0-paper1

# Step 6: 在 GitHub 创建 Release
# 访问 https://github.com/hengbo-li/lsh-workspace/releases/new
# 选择 tag: v1.0-paper1
# 填写 Release 标题和说明
```

### 2.3 GitHub Release 模板

**标题**:
```
Paper 1: LSH-SFA - Spacetime Field Attention v1.0
```

**说明**:
```markdown
## LSH-SFA: Spacetime Field Attention with Wave Packets, Light-Cone Causality, and PDE-Driven Evolution

### 核心贡献
- 波包表示 (k, w, ω, θ) 替代 QKV
- 光锥注意力实现 O(n) 复杂度
- PDE 驱动的场演化（扩散/对流）
- 共振耦合机制

### 实验结果
- AG News: 91.80% 准确率（参数减少 14%）
- WikiText-2: PPL 654 vs Transformer 1069（提升 39%）

### 文件
- `structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2/main.tex`

### 引用
```bibtex
@article{li2026lsh-sfa,
  author = {Li, Hengbo},
  title = {LSH-SFA: Spacetime Field Attention with Wave Packets, Light-Cone Causality, and PDE-Driven Evolution},
  journal = {LSH Protocol Preprint},
  year = {2026},
  doi = {10.5281/zenodo.xxxxx}
}
```
```

---

## 三、发布清单

### 3.1 按发布顺序

| 顺序 | 论文 | Tag | 状态 |
|------|------|-----|------|
| 1 | Paper 1: LSH-SFA | `v1.0-paper1` | ⬜ 待发布 |
| 2 | Paper 2: Three-Layer | `v2.0-paper2` | ⬜ 待发布 |
| 3 | Paper 3: LSH Format | `v3.0-paper3` | ⬜ 待发布 |
| 4 | Paper 4: Attention Comparison | `v4.0-paper4` | ⬜ 待发布 |
| 5 | Paper 5: Encoding & Gradient | `v5.0-paper5` | ⬜ 待发布 |
| 6 | Paper 6: Autoregressive | `v6.0-paper6` | ⬜ 待发布 |
| 7 | Paper 7: Spacetime Cognition | `v7.0-paper7` | ⬜ 待发布 |
| 8 | Paper 8: LSH-Burn | `v8.0-paper8` | ⬜ 待发布 |
| 9 | Paper 9: LSH Rules | `v9.0-paper9` | ⬜ 待发布 |
| 10 | Paper 10: Version Control | `v10.0-paper10` | ⬜ 待发布 |

### 3.2 发布前检查清单

- [ ] 论文 `main.tex` 已完成
- [ ] 论文目录下 `.zenodo.json` 配置正确
- [ ] 根目录 `.zenodo.json` 已更新为目标论文内容
- [ ] Git 工作区干净
- [ ] Tag 已创建
- [ ] GitHub Release 已创建

---

## 四、Zenodo 元数据规范

### 4.1 必填字段

| 字段 | 说明 | 示例 |
|------|------|------|
| `title` | 论文标题 | LSH-SFA: Spacetime Field Attention... |
| `creators` | 作者信息 | [{"name": "Li, Hengbo", "orcid": "..."}] |
| `description` | 摘要 | We present LSH-SFA... |
| `access_right` | 访问权限 | `open` |
| `license` | 许可证 | `CC-BY-4.0` |
| `upload_type` | 上传类型 | `publication` |
| `publication_type` | 出版类型 | `preprint` |

### 4.2 可选字段

| 字段 | 说明 |
|------|------|
| `keywords` | 关键词数组 |
| `subjects` | 主题分类 |
| `related_identifiers` | 相关链接 |
| `communities` | Zenodo 社区 |
| `version` | 版本号 |

---

## 五、常见问题

### Q1: 如何更新已发布的论文？

1. 修改论文内容
2. 更新 `.zenodo.json` 中的 `version` 字段
3. 创建新 tag（如 `v1.1-paper1`）
4. 发布新 Release

### Q2: 如何查看 Zenodo DOI？

发布成功后，访问 https://zenodo.org/records 查看已上传的记录。

### Q3: 论文文件太大怎么办？

Zenodo 单文件限制 50GB，整个记录限制 100GB。LaTeX 文件通常很小，无需担心。

---

## 六、自动化脚本（可选）

创建 `scripts/release-paper.ps1`：

```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$PaperNumber,
    
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$paperDirs = @{
    "1" = "structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2"
    "2" = "structures/paper/architecture/architecture_three_layer-20260511_130002-b7d2e1"
    "3" = "structures/paper/architecture/architecture_lsh_format-20260511_130003-h9j8k7"
    "4" = "structures/paper/theory/theory_attention_comparison-20260511_120002-d5f4g3"
    "5" = "structures/paper/theory/theory_tokenizer_free-20260511_120003-e6g5h4"
    "6" = "structures/paper/applications/applications_autoregressive-20260511_150001-i10k9l8"
    "7" = "structures/paper/foundational/foundational_spacetime_cognition-20260511_160001-j11k10m9"
    "8" = "structures/paper/systems/systems_lsh_burn-20260511_140003-l13m14n15"
    "9" = "structures/paper/applications/applications_lsh_rules-20260511_150002-m13n14o15"
    "10" = "structures/paper/systems/systems_version_control-20260511_140004-p4q5r6"
}

$paperDir = $paperDirs[$PaperNumber]
$tag = "v${Version}-paper${PaperNumber}"

Write-Host "准备发布 Paper $PaperNumber..."
Write-Host "目录: $paperDir"
Write-Host "Tag: $tag"

# 复制 zenodo.json
Copy-Item "$paperDir/.zenodo.json" ".zenodo.json"
Write-Host "已复制 .zenodo.json 到根目录"

# 提示下一步
Write-Host ""
Write-Host "下一步操作:"
Write-Host "  git add .zenodo.json"
Write-Host "  git commit -m 'chore: prepare release $tag'"
Write-Host "  git tag $tag"
Write-Host "  git push origin $tag"
```

---

*文档版本: v1.0 | 更新日期: 2026-05-12*
