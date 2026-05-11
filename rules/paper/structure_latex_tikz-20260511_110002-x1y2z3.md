# Structure LaTeX/TikZ 规范

**LSH ID**: structure_latex_tikz-20260511_110002-x1y2z3
**cat**: structure | **tags**: latex, tikz | **level**: guide | **version**: 1.0
**引用**: architecture_three_layer-20260511_130002-b7d2e1 | common/

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | LaTeX 模板规范、TikZ 绘图规范 | 第一节~第二节 |
| **Rule 规则层** | 表格规范、代码列表规范 | 第三节~第四节 |
| **Execution 执行层** | 图表检查清单、共享资源使用 | 第五~六节 |

---

## 一、LaTeX 模板规范

### 1.1 论文模板

```latex
\documentclass[conference]{IEEEtran}

% 必装宏包
\usepackage{tikz}
\usepackage{amsmath,amssymb,amsfonts}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{xcolor}
\usepackage{geometry}

% LSH 共享资源
\input{../common/definitions/lsh-core.tex}
\input{../common/definitions/math-notation.tex}

\geometry{margin=1in}

\begin{document}

\title{论文标题}
\author{
  \IEEEauthorblockN{李恒波}
  \IEEEauthorblockA{LSH Protocol\\
    1147502779@qq.com}
}

\maketitle

\begin{abstract}
...
\end{abstract}

\IEEEkeywords{关键词1, 关键词2, 关键词3}

\section{Introduction}
...

\bibliographystyle{IEEEtran}
\bibliography{../common/references}

\end{document}
```

---

## 二、TikZ 绘图规范

### 2.1 三层架构图模板

```latex
\usepackage{tikz}
\usetikzlibrary{
  shapes.geometric,
  arrows.meta,
  positioning,
  calc,
  fit,
  shadows.blur
}

% 样式定义
\tikzstyle{layer} = [
  draw,
  rectangle,
  rounded corners=3pt,
  minimum height=1.5cm,
  minimum width=3.5cm,
  fill=blue!10,
  font=\sffamily\small,
  blur shadow
]

\tikzstyle{element} = [
  draw,
  ellipse,
  minimum height=0.8cm,
  minimum width=2cm,
  fill=green!10,
  font=\sffamily\small
]

\tikzstyle{arrow} = [
  ->,
  >=Stealth,
  thick
]

\begin{tikzpicture}[
  node distance=1.5cm and 2cm,
  auto
]

% 结构层
\node[layer, fill=blue!20] (structure) {结构层\\Structure Layer};

% 规则层
\node[layer, fill=orange!20, below=of structure] (rule) {规则层\\Rule Layer};

% 执行层
\node[layer, fill=purple!20, below=of rule] (execution) {执行层\\Execution Layer};

% 元素节点
\node[element, right=of structure, fill=green!20] (device) {设备};
\node[element, right=of rule, fill=green!20] (observer) {观察者};
\node[element, right=of execution, fill=green!20] (action) {动作};

% 连接线
\draw[arrow] (structure) -- (rule);
\draw[arrow] (rule) -- (execution);
\draw[arrow] (device) -- (structure);
\draw[arrow] (observer) -- (rule);
\draw[arrow] (action) -- (execution);

% 标签
\node[above, font=\footnotesize] at (structure.north) {本体};
\node[above, font=\footnotesize] at (rule.north) {关系};
\node[above, font=\footnotesize] at (execution.north) {变化};

\end{tikzpicture}
```

### 2.2 波包表示图模板

```latex
\begin{tikzpicture}[
  wave/.style={
    draw,
    sinusoidal={amplitude=0.5cm, wavelength=1cm},
    fill=blue!10
  }
]

% 坐标系
\draw[->] (-0.5, 0) -- (5, 0) node[right] {$x$};
\draw[->] (0, -1.5) -- (0, 1.5) node[above] {$y$};

% 波包
\draw[domain=0:4, smooth, thick, blue]
  plot (\x, {exp(-(\x-2)^2) * cos(10*\x)});

% 标注
\node at (2, 0.8) {$\psi(x, t)$};
\node at (3.5, -0.8) {$|\psi|^2$};

% 包络线
\draw[domain=0:4, dashed, red]
  plot (\x, {exp(-(\x-2)^2)});
\draw[domain=0:4, dashed, red]
  plot (\x, {-exp(-(\x-2)^2)});

\end{tikzpicture}
```

### 2.3 注意力机制图模板

```latex
\begin{tikzpicture}[
  node distance=1.2cm,
  attention/.style={
    draw,
    rectangle,
    minimum height=0.8cm,
    minimum width=1.5cm,
    fill=blue!10
  },
  weight/.style={
    draw,
    circle,
    minimum size=0.5cm,
    fill=red!10
  }
]

% Query, Key, Value
\node[attention, fill=blue!20] (Q) {$Q$};
\node[attention, right=of Q, fill=green!20] (K) {$K$};
\node[attention, right=of K, fill=purple!20] (V) {$V$};

% 注意力权重
\node[weight, below=of Q] (w1) {$w_1$};
\node[weight, below=of K] (w2) {$w_2$};
\node[weight, below=of V] (w3) {$w_3$};

% 连线
\draw[->] (Q) -- (w1);
\draw[->] (K) -- (w2);
\draw[->] (V) -- (w3);
\draw[->] (w1) -- ++(0, -0.5) -| (w2);
\draw[->] (w2) -- ++(0, -0.5) -| (w3);

% 输出
\node[attention, right=of V, fill=orange!20] (O) {$O$}
  edge[<-] (w3);

\end{tikzpicture}
```

---

## 三、表格规范

### 3.1 三线表模板

```latex
\begin{table}[htbp]
\centering
\caption{实验结果对比}
\label{tab:results}
\begin{tabular}{lccc}
\toprule
\textbf{方法} & \textbf{Precision} & \textbf{Recall} & \textbf{F1} \\
\midrule
LSH-SFA & 92.3\% & 89.7\% & 91.0\% \\
Transformer & 88.5\% & 85.2\% & 86.8\% \\
\midrule
\textbf{提升} & \textbf{+3.8\%} & \textbf{+4.5\%} & \textbf{+4.2\%} \\
\bottomrule
\end{tabular}
\end{table}
```

### 3.2 复杂表格

```latex
\begin{table}[htbp]
\centering
\caption{多行多列表格}
\label{tab:complex}
\begin{tabular}{l|c|c|c}
\toprule
 & \textbf{LSH-SFA} & \textbf{基线1} & \textbf{基线2} \\
\midrule
\multirow{2}{*}{任务A}
 & 95.2\% & 90.1\% & 88.5\% \\
 & (std=0.3) & (std=0.5) & (std=0.4) \\
\midrule
multirow{2}{*}{任务B}
 & 91.8\% & 87.3\% & 85.6\% \\
 & (std=0.4) & (std=0.6) & (std=0.5) \\
\bottomrule
\end{tabular}
\end{table}
```

---

## 四、代码列表

### 4.1 代码高亮模板

```latex
\usepackage{listings}

\lstdefinestyle{python}{
  language=Python,
  basicstyle=\ttfamily\small,
  keywordstyle=\color{blue},
  stringstyle=\color{red},
  commentstyle=\color{green},
  numbers=left,
  numberstyle=\tiny\color{gray},
  stepnumber=1,
  showstringspaces=false
}

\lstdefinestyle{rust}{
  language=Rust,
  basicstyle=\ttfamily\small,
  keywordstyle=\color{blue}\bfseries,
  stringstyle=\color{orange},
  commentstyle=\color{green}\itshape,
  numbers=left,
  numberstyle=\tiny\color{gray}
}

\begin{lstlisting}[style=python, label={lst:example}, caption={Python 示例}]
def hello_world():
    print("Hello, LSH!")
\end{lstlisting}
```

---

## 五、图表检查清单

- [ ] 使用 TikZ 矢量图（非位图）
- [ ] 字体大小合适（8-10pt）
- [ ] 颜色对比度足够
- [ ] 标签清晰可见
- [ ] 图例完整
- [ ] 引用编号正确

---

## 六、共享资源使用

```latex
% 在论文中引用共享图表
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]
    {../common/figures/three-layer/lsh-three-layer.pdf}
  \caption{LSH 三层语义架构}
  \label{fig:three-layer}
\end{figure}

% 使用共享符号
波包表示为 $(\mathbf{k}, \mathbf{w}, \boldsymbol{\omega}, \boldsymbol{\theta})$。
```

---

## 七、验证规则 / Validation Rules

### 7.1 LSH ID 统一格式

**唯一抽象源**：[lsh_format.md §2.2](../../lsh-protocol/docs/lsh_format.md#L56-L95)

**格式**：`{prefix}[_group...]-{timestamp}-{hash}`

**核心原则**：`-` 是唯一抽象，分隔语义部分与时间戳/哈希。

### 7.2 图表验证关联

实验图表必须关联 LSH ID：

```latex
% 图表必须包含 LSH ID 标注
\caption{TNEWS 十四分类实验结果 (LSH ID: tnews\_classifier-1778489606-19970)}
\label{fig:tnews-results}
```

### 7.3 表格验证记录

```latex
\begin{table}[htbp]
\centering
\caption{十四分类实验结果}
\label{tab:tnews-classification}
\begin{tabular}{l|c|c}
\toprule
\textbf{配置} & \textbf{LSH ID} & \textbf{Acc} \\
\midrule
4层 512d, Attention Pooling & tnews\_classifier-1778489606-19970 & 8.83\% \\
\midrule
Checkpoint: \texttt{tnews\_classifier-1778489606-19970\_best.mpk} \\
\bottomrule
\end{tabular}
\end{table}
```

### 7.4 验证检查清单

- [ ] LSH ID 格式遵循 lsh_format.md §2.2 唯一抽象
- [ ] 实验图表包含 LSH ID 标注
- [ ] 表格包含 Checkpoint 路径
- [ ] 引用 paper_foundation 验证规则
- [ ] 可追溯性满足 paper_validation 规范

---

*LSH ID: structure_latex_tikz-20260511_110002-x1y2z3*
