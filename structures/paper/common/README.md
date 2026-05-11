# LSH 论文共享内容 / LSH Paper Common Content

**版本**: v5.0
**日期**: 2026-05-11
**作者**: 李恒波

---

## 一、目录结构

```
common/
├── README.md              # 本文件
├── figures/               # 共享图表
│   ├── architecture/      # 架构图
│   ├── three-layer/       # 三层架构图
│   ├── spacetime/         # 时空场图
│   └── gradient/          # 梯度图
├── definitions/           # 共享定义
│   ├── lsh-core.tex       # LSH 核心术语
│   ├── math-notation.tex  # 数学符号定义
│   └── physics-terms.tex  # 物理术语定义
└── templates/             # 共享模板
    ├── paper-template.tex # 论文模板
    ├── lstlisting.sty     # 代码 Listings 样式
    └── lsh-notation.sty   # LSH 符号宏包
```

---

## 二、共享内容说明

### 2.1 figures/ (共享图表)

以下图表在多篇论文中引用，建议统一管理：

| 图表 | 文件 | 被引用论文 |
|------|------|------------|
| LSH 三层架构图 | `figures/three-layer/lsh-three-layer.pdf` | P1, P2, P4, P10 |
| 波包表示图 | `figures/architecture/wave-packet.pdf` | P1, P2, P8 |
| 光锥注意力图 | `figures/spacetime/light-cone.pdf` | P1, P3, P8 |
| PDE 演化图 | `figures/spacetime/pde-evolution.pdf` | P3, P7, P8 |
| V2 梯度架构图 | `figures/gradient/v2-gradient.pdf` | P7, P10 |

**使用方式**:
```latex
% 在论文中引用共享图表
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{../common/figures/three-layer/lsh-three-layer.pdf}
  \caption{LSH 三层语义架构}
  \label{fig:three-layer}
\end{figure}
```

---

### 2.2 definitions/ (共享定义)

以下定义在多篇论文中使用，建议统一管理：

| 定义文件 | 内容 | 被引用论文 |
|----------|------|------------|
| `lsh-core.tex` | LSH 核心术语定义 | 所有论文 |
| `math-notation.tex` | 数学符号定义 | P1, P3, P5, P7 |
| `physics-terms.tex` | 物理术语定义 | P1, P3, P7, P10 |

**使用方式**:
```latex
% 在论文导言区引入共享定义
\input{../common/definitions/lsh-core.tex}
\input{../common/definitions/math-notation.tex}
```

**lsh-core.tex 示例内容**:
```latex
% LSH 核心术语定义
\def\LSH{LSH (Li Shi Hang)}
\def\LSHSFA{LSH-SFA (Spacetime Field Attention)}
\def\WavePacket{波包表示 (Wave Packet Representation)}
\def\ThreeLayer{三层语义架构 (Three-Layer Architecture)}
```

**math-notation.tex 示例内容**:
```latex
% 数学符号定义
\def\kvec{\mathbf{k}}           % 波矢
\def\wvec{\mathbf{w}}           % 权重
\def\omega{\boldsymbol{\omega}} % 角频率
\def\theta{\boldsymbol{\theta}} % 相位
\def\Laplacian{\nabla^2}        % 拉普拉斯算子
```

---

### 2.3 templates/ (共享模板)

| 文件 | 用途 |
|------|------|
| `paper-template.tex` | 论文 LaTeX 模板 |
| `lsh-notation.sty` | LSH 符号宏包 |
| `lstlisting.sty` | 代码片段样式（如已安装可省略） |

---

## 三、共享内容管理规则

### 3.1 图表更新规则

| 情况 | 处理方式 |
|------|----------|
| 仅影响单篇论文 | 复制图表到论文目录，不修改共享版本 |
| 影响多篇论文 | 修改共享版本，所有引用方同步更新 |
| 大幅修改 | 创建新版本 (e.g., `lsh-three-layer-v2.pdf`)，旧版本保留 |

### 3.2 定义更新规则

| 情况 | 处理方式 |
|------|----------|
| 新增术语 | 在 definitions/ 中添加，版本号 +1 |
| 修改现有定义 | 评估影响范围，必要时创建新文件 |
| 删除术语 | 保留原文件，标注 "已废弃 vX.X" |

### 3.3 提交前检查

- [ ] 确认共享图表路径正确
- [ ] 确认 LaTeX 能找到共享定义文件
- [ ] 确认图表清晰度满足出版要求
- [ ] 确认交叉引用索引已更新

---

## 四、贡献指南

欢迎为共享内容库贡献内容：

1. **图表贡献**：请确保图表清晰、标注完整
2. **定义贡献**：请附上术语的来源论文
3. **模板贡献**：请确保向后兼容

---

*文档版本: v5.0 | 更新日期: 2026-05-11*
