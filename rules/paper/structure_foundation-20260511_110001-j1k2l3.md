# Structure Foundation Rules

**LSH ID**: structure_foundation-20260511_110001-j1k2l3
**cat**: structure | **tags**: foundation | **level**: foundation | **version**: 1.0
**引用**: architecture_three_layer-20260511_130002-b7d2e1 | applications_lsh_rules-20260511_150002-m13n14o15 | paper_citation-20260511_232036-c1d2e3

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | 论文结构规范（Abstract, Introduction, Method...） | 第一节：论文结构规范 |
| **Rule 规则层** | 引用规范、图表规范、数学公式规范、页面格式规范 | 第二~五节 |
| **Execution 执行层** | 强制检查清单（验证-强制检查清单） | 第六节：强制检查清单 |

**验证即执行**：检查清单是 Execution 层的核心，它验证 Structure 和 Rule 是否被遵循。

---

## 一、论文结构规范

### 1.1 标准论文结构

```latex
\documentclass[conference]{IEEEtran}

\title{论文标题}
\author{
  \IEEEauthorblockN{作者姓名}
  \IEEEauthorblockA{机构\\ Email}
}

\begin{document}

\maketitle

\begin{abstract}
摘要内容（150-250词）
\end{abstract}

\section{Introduction}
介绍（ Motivation + Contribution）

\section{Background}
背景知识

\section{Method}
方法

\section{Experiments}
实验

\section{Related Work}
相关工作

\section{Conclusion}
结论

\bibliographystyle{IEEEtran}
\bibliography{references}

\end{document}
```

### 1.2 章节结构规范

| 章节 | 必须 | 说明 |
|------|------|------|
| Abstract | ✅ | 150-250 词 |
| Introduction | ✅ | Motivation + 贡献点 |
| Background | ⚠️ | 可合并到 Related Work |
| Method | ✅ | 核心方法 |
| Experiments | ✅ | 实验验证 |
| Related Work | ✅ | 相关工作对比 |
| Conclusion | ✅ | 总结 + 未来工作 |

---

## 二、引用规范

### 2.1 引用格式

```latex
% 单引用
LSH-SFA~\cite{lsh-sfa-2026}

% 多引用
Transformer~\cite{vaswani2017attention} 和 LSH-SFA~\cite{lsh-sfa-2026}

% 引用特定章节
见 Section~\ref{sec:method} 或 Paper~\ref{paper1} 第 2.1 节
```

### 2.2 引用检查

- [ ] 所有引用都有对应的 bibliography 条目
- [ ] 引用格式一致（IEEEtran 标准）
- [ ] 交叉引用使用 `\ref{}` 而非硬编码

---

## 三、图表规范

### 3.1 图表标签

```latex
% 标签命名：{类型}_{主题}
% 类型: fig, tab, eq, sec, lst
% 示例:
\label{fig:architecture}
\label{tab:performance}
\label{eq:diffusion}
\label{sec:background}
\label_lst:code-example}
```

### 3.2 图表引用

```latex
% 首次引用使用完整描述
如图~\ref{fig:architecture} 所示，LSH-SFA 由三层组成。

% 后续引用可简化
LSH-SFA 架构如图~\ref{fig:architecture} 所示。
```

### 3.3 图表制作要求

| 类型 | 要求 |
|------|------|
| 架构图 | 使用 TikZ，矢量格式 |
| 实验图 | 清晰标注，数据点可见 |
| 表格 | 三线表，表头加粗 |
| 代码 | 使用 lstlisting，高亮语法 |

---

## 四、数学公式规范

### 4.1 公式格式

```latex
% 行内公式
能量函数定义为 $E = \sum_i w_i x_i + b$。

% 独立公式
\begin{equation}
\label{eq:energy}
E = \sum_{i=1}^{n} w_i x_i + b
\end{equation}

% 多行公式
\begin{align}
\label{eq:gradient}
\frac{\partial L}{\partial w} &= \sum_{i=1}^{n} (y_i - \hat{y}_i) x_i \\
&= X^T (y - \hat{y})
\end{align}
\end{equation}
```

### 4.2 符号规范

```latex
% 向量使用粗体
$\mathbf{w}$ 或 $\boldsymbol{\theta}$

% 矩阵使用大写粗体
$\mathbf{X}$, $\mathbf{W}$

% 集合使用空心字母
$\mathbb{R}$, $\mathbb{N}$

% 建议在首次使用时定义
令 $\mathbf{w} \in \mathbb{R}^d$ 表示权重向量。
```

---

## 五、页面格式

### 5.1 页边距

```latex
\usepackage{geometry}
\geometry{margin=1in}
```

### 5.2 行距

```latex
% 双栏论文使用单倍行距
\selectfont
\linespread{1}

% 图表周围留有适当空白
\end{figure}
\vspace{1ex}
```

---

## 六、强制检查清单

- [ ] 论文结构完整（Abstract, Introduction, Method, Experiments, Related Work, Conclusion）
- [ ] 引用格式正确
- [ ] 图表标签命名规范
- [ ] 公式编号连续
- [ ] 符号首次使用时定义
- [ ] 页边距符合要求

---

## 七、验证规则 / Validation Rules

### 7.1 验证即执行

**核心原则**：论文中的实验验证是 Execution 层的实体化。实验结果必须可追溯、可复现。

### 7.2 LSH ID 统一格式

**唯一抽象源**：[lsh_format.md §2.2](../../lsh-protocol/docs/lsh_format.md#L56-L95)

**格式**：`{prefix}[_group...]-{timestamp}-{hash}`

| 组件 | 分隔符 | 说明 | 示例 |
|------|--------|------|------|
| prefix | - | 主类型，必须 | `device`, `theory`, `tnews` |
| group | `_` | 可选子类型，N个 | `classifier`, `gradient_paradigm` |
| timestamp | `-` | 创建时间 | `20260511` 或 `1778489606` |
| hash | - | 唯一指纹 | `a3f8c2`, `19970` |

**核心原则**：`-` 是唯一抽象，分隔语义部分与时间戳/哈希。Category (`cat`) 是属性，不是 ID 的一部分。

### 7.3 实验结果记录规范

论文中的实验结果必须包含：

```markdown
## 实验结果

| 实验配置 | LSH ID | 最佳指标 | Checkpoint |
|---------|--------|---------|------------|
| TNEWS 14类, 4层512d | tnews_classifier-1778489606-19970 | Acc=8.83% | tnews_classifier-1778489606-19970_best.mpk |
```

### 7.4 可追溯性验证

论文验证必须满足：

| 验证项 | 要求 |
|--------|------|
| **LSH ID 关联** | 每个实验结果关联唯一 LSH ID |
| **Checkpoint 路径** | 包含完整 checkpoint 路径 |
| **配置可复现** | 可从 LSH ID 复现训练配置 |
| **时间戳** | 时间戳确保唯一性 |

### 7.5 验证引用

论文验证规则遵循 `paper_validation-20260511_110003-p7q8r9`：

- 对比测试规则（Comparative Testing）
- 控制变量规则（Controlled Variables）
- 泛化测试规则（Generalization Testing）
- 可复现规则（Reproducibility）

---

## 八、共享资源引用

```latex
% 引用 LSH 共享符号
\input{../common/definitions/lsh-core.tex}

% 引用共享图表
\includegraphics[width=0.8\textwidth]{../common/figures/three-layer/lsh-three-layer.pdf}
```

---

*LSH ID: structure_foundation-20260511_110001-j1k2l3*
