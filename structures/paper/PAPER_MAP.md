# LSH Paper Map

**Version**: v9.0
**Date**: 2026-05-12
**Author**: Hengbo Li
**Organization**: From shallow to deep, layer by layer, clear hierarchy, reasonable architecture

---

## 1. Paper Directory Structure

### 1.1 Directory Overview

```
paper/
├── architecture/                          # Architecture (3 papers)
│   ├── architecture_lsh_sfa-20260511_130001-a3f8c2/              # Paper 1
│   ├── architecture_three_layer-20260511_130002-b7d2e1/          # Paper 2
│   └── architecture_lsh_format-20260511_130003-h9j8k7/           # Paper 3
├── theory/                                # Theory (2 papers)
│   ├── theory_attention_comparison-20260511_120002-d5f4g3/        # Paper 4
│   └── theory_tokenizer_free-20260511_120003-e6g5h4/              # Paper 5
├── systems/                               # Systems (2 papers)
│   ├── systems_lsh_burn-20260511_140003-l13m14n15/                # Paper 8
│   └── systems_version_control-20260511_140004-p4q5r6/            # Paper 10
├── applications/                          # Applications (2 papers)
│   ├── applications_autoregressive-20260511_150001-i10k9l8/       # Paper 6
│   └── applications_lsh_rules-20260511_150002-m13n14o15/          # Paper 9 ★
├── foundational/                          # Foundational (1 paper)
│   └── foundational_spacetime_cognition-20260511_160001-j11k10m9/ # Paper 7
├── common/                                # Shared content
│   ├── figures/                         #   Shared figures (TikZ)
│   ├── definitions/                     #   Shared definitions
│   └── templates/                       #   Shared templates
├── PAPER_MAP.md                         # 📖 This file
└── CROSS_REFERENCE.md                   # 🔗 Cross-reference index
```

**Note**: The rules/ directory is at the same level as paper/, reflecting that rules are a first-class citizen:

```
LSH_demo/
├── paper/                               # Papers (Paper 1-10)
└── rules/                               # ★ Rules System (same level as paper/)
    ├── rules.md                         # LSH Rules System (总规则)
    ├── project/                         # Project rules
    ├── paper/                           # Paper rules
    ├── prompt/                          # Prompt rules
    └── code/                            # Code rules (Rust+Python FFI)
```

### 1.2 LSH ID Naming (1+N Pluggable Backend Pattern)

LSH ID Format: `{prefix}[_group...]-{timestamp}-{hash}`

| Component | Delimiter | Description | Example |
|-----------|-----------|-------------|---------|
| prefix | `-` | Main type (required) | `theory`, `architecture` |
| group | `_` | Optional sub-type (N) | `gradient_paradigm`, `lsh_sfa` |
| timestamp | `-` | Creation time | `20260511` |
| hash | `-` | Unique identifier | `f7h6i5` |

### 1.3 Quick Start Guide

| Question | Solution |
|----------|----------|
| Where to start? | See [Section 2: Systematic Learning Path](#2-recommended-reading-order-progressive) |
| How to cross-reference? | See [CROSS_REFERENCE.md](./CROSS_REFERENCE.md) |
| Where are shared figures? | See [common/](./common/) directory |
| Which papers cover a topic? | See [Section 4: Three-Layer Architecture Mapping](#4-three-layer-architecture-mapping) |

---

## 1.4 Three-Layer Fractal Consistency / 三层架构分形一致性

The three-layer architecture (Structure·Rule·Execution) is a **fractal structure** that applies recursively at all levels:

| Application Layer | Structure | Rule | Execution |
|-------------------|-----------|------|-----------|
| **LSH Papers** | Three-layer semantic (Paper 2) | Observer system, PDE rules | CMD_PERCEIVE, emergent scheduling |
| **Project Rules** | Directory structure规范 | Naming, import, error handling | Checklist (检查清单) |
| **Paper Rules** | Paper structure (Abstract~Conclusion) | Citation, figure, formula rules | Verification checklist |
| **Prompt Rules** | Template structure (Role~Output) | Role definition, output format | CoT validation |
| **LSH Format** | Element structure (id, category, tags...) | Semantic ID, property definitions | Codec verification |
| **MVVM Architecture** | View~ViewModel~Model layers | Signal/Slot, EventBus | Communication verification |

**Fractal Verification Loop**:

```
┌─────────────────────────────────────────────────────────────────────┐
│                  Three-Layer Fractal Self-Similarity                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   rules/paper/paper_foundation.md                                  │
│   ├── Structure: 论文结构规范 → Abstract, Introduction, Method...    │
│   ├── Rule: 引用规范、图表规范、数学公式规范                         │
│   └── Execution: 强制检查清单                                       │
│                                                                     │
│   rules/project/project_foundation.md                              │
│   ├── Structure: 目录结构规范 → src/, tests/, docs/                │
│   ├── Rule: 命名规范、导入规范、错误处理规范                         │
│   └── Execution: 强制检查清单                                       │
│                                                                     │
│   ════════════════════════════════════════════════════════════════  │
│         Each rule file ITSELF demonstrates the three-layer          │
│         architecture (fractal self-similarity)                      │
│   ════════════════════════════════════════════════════════════════  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Recommended Reading Order (Progressive)

### Route A: Systematic Learning Path (From Shallow to Deep)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Systematic Learning Path (From Shallow to Deep)           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Step 1: Getting Started - Paper 1 (Architecture)                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  architecture_lsh_sfa-20260511_130001-a3f8c2/                      │   │
│  │  LSH-SFA: Spacetime Field Attention Based on Physical Priors         │   │
│  │  → Wave packet + Light-cone attention + PDE evolution + Resonance   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 2: Deepening - Paper 2 (Architecture)                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  architecture_three_layer-20260511_130002-b7d2e1/                  │   │
│  │  Three-Layer Semantic Architecture: Unified World Model             │   │
│  │  → Structure layer + Rule layer + Execution layer                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 3: Data Format - Paper 3 (Architecture)                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  architecture_lsh_format-20260511_130003-h9j8k7/                   │   │
│  │  LSH Format: AI-Native Data Format Architecture                     │   │
│  │  → Semantic ID + 96% Token Savings + Incremental Update Protocol     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 4-5: Topic Research (Theory)                                       │
│  ┌───────────────┐ ┌───────────────┐                                     │
│  │ Paper 4       │ │ Paper 5       │                                     │
│  │ Attention     │ │ Encoding &    │                                     │
│  │ Comparison    │ │ Gradient      │                                     │
│  └───────────────┘ └───────────────┘                                     │
│                                     ↓                                       │
│  Step 6: Application - Paper 6 (Applications)                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  applications_autoregressive-20260511_150001-i10k9l8/               │   │
│  │  Autoregressive Language Modeling and Generation                      │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 7: Reflection - Paper 7 (Foundational)                              │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  foundational_spacetime_cognition-20260511_160001-j11k10m9/         │   │
│  │  The Spacetime Cognition Deficit: General Embodied Intelligence     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 8: Architecture Validation - Paper 8 (Systems)                      │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  systems_lsh_burn-20260511_140003-l13m14n15/                        │   │
│  │  LSH-Burn: Rust Spacetime Field Architecture Implementation         │   │
│  │  → 1+N Pluggable backend + NF4 quantization + Wave packet decoder   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 9: Self-Verification - Paper 9 (Applications)                      │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  applications_lsh_rules-20260511_150002-m13n14o15/                  │   │
│  │  LSH Rules: Self-Verifying Semantic System ★                         │   │
│  │  → Rules manage themselves (mutual verification)                     │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                     ↓                                       │
│  Step 10: Versioning - Paper 10 (Systems)                                 │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  systems_version_control-20260511_140004-p4q5r6/                    │   │
│  │  LSH Version Control: Ternary Semantic Versioning                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Route B: Quick Navigation (By Need)

| Need | Recommended Paper | Path |
|------|-------------------|------|
| Quick overview of LSH | **Paper 1** | `architecture/` |
| Three-layer architecture design | **Paper 2** | `architecture/` |
| Data format optimization | **Paper 3** | `architecture/` |
| Attention mechanism comparison | **Paper 4** | `theory/` |
| Encoding & gradient analysis | **Paper 5** | `theory/` |
| Dialogue generation | **Paper 6** | `applications/` |
| Spacetime cognition deficit hypothesis | **Paper 7** | `foundational/` |
| Rust implementation of LSH-SFA | **Paper 8** | `systems/` |
| Self-verifying rules system | **Paper 9** | `applications/` |
| Ternary semantic versioning | **Paper 10** | `systems/` |

---

## 3. Publication Strategy

### 3.1 Zenodo Multi-Paper Mode

Each paper has an independent Release, continuously iterating in the same GitHub repository:

```
GitHub: lsh-workspace/lsh-protocol
├── v1.0  →  LSH-SFA Architecture (doi:10.5281/zenodo.20129047)
├── v2.0  →  Three-Layer Architecture (doi:10.5281/zenodo.20129051)
├── v3.0  →  LSH Format (doi:10.5281/zenodo.20129053)
├── v4.0  →  Attention Comparison (doi:10.5281/zenodo.20129055)
├── v5.0  →  Encoding & Gradient (doi:10.5281/zenodo.20129061)
├── v6.0  →  Autoregressive Generation (doi:10.5281/zenodo.20129063)
├── v7.0  →  Spacetime Cognition Deficit (doi:10.5281/zenodo.20129066)
├── v8.0  →  LSH-Burn Implementation (doi:10.5281/zenodo.20129068)
├── v9.0  →  LSH Rules Self-Verification (doi:10.5281/zenodo.20129070)
└── v10.0 →  Ternary Semantic Versioning (doi:10.5281/zenodo.20129074)
```

### 3.2 Publication Checklist

| # | Title | Direction | Version | Core Contribution | Status |
|---|-------|-----------|---------|-------------------|--------|
| 1 | **LSH-SFA: Spacetime Field Attention with Wave Packets, Light-Cone Causality, and PDE-Driven Evolution** | Architecture | v1.0 | Overall architecture + Wave packet + Light-cone attention | Draft |
| 2 | **LSH: Element-Observers Semantic Architecture with Emergent Execution** | Architecture | v2.0 | Structure layer + Observer system + Decay recording | ✅ Theory |
| 3 | **LSH Format: AI-Native Data Format with Rust/Burn Engineering Validation** | Architecture | v9.0 | 96% Token savings + Incremental update protocol | ✅ Validation |
| 4 | **Beyond Softmax: A Systematic Comparison of Eight Linear Attention Mechanisms** | Theory | v5.0 | Attention ablation + ELU+1 optimal + GQA analysis | ✅ Theory |
| 5 | **Encoding and Gradient in Physics-Informed Networks: Tokenizer-Free Models and Controllable Explosion Optimization** | Theory | v6.0 | Unicode BMP + Collapse phenomenon + Capacity boundary | ✅ Theory |
| 6 | **LSH-SFA for Autoregressive Generation: Causal Mode and Conversation Ability** | Applications | v8.0 | Autoregressive closed-loop + Causal mode + Dialogue | In Progress |
| 7 | **The Spacetime Cognition Deficit: Why Architecture Matters for General Embodied Intelligence** | Foundational | v10.1 | Spacetime cognition deficit + General embodied intelligence foundation + Physical simulation validation path | Draft |
| 8 | **LSH-Burn: Rust-based Spacetime Field Architecture Implementation** | Systems | v6.0 | 1+N Pluggable backend + NF4 + Wave decoder | ✅ Implementation |
| 9 | **LSH Rules: Self-Verifying Semantic System for Super Rule Enhancement and Prompt Engineering** | Applications | v13.0 | Self-verification + 1+N pattern + Rules engine ★ | ✅ Deep Application |
| 10 | **LSH Version Control: Ternary Semantic Versioning Based on Three-Layer Architecture** | Systems | v14.0 | Base-3 carry + Three-layer mapping + Fractal versioning | ✅ Validation |

### 3.3 Conference Submission Mapping

| Direction | Suitable Conferences/Journals | Recommended Papers |
|-----------|-------------------------------|-------------------|
| Architecture | ICLR / NeurIPS / TOSEM | Paper 1, Paper 2, Paper 3 |
| Theory | ICML / NeurIPS / JMLR | Paper 4, Paper 5 |
| Systems | ICSE / ASE / VLDB | Paper 8, Paper 10 |
| Applications | ACL / EMNLP / ICLR | Paper 6, Paper 9 |
| Foundational | Science Robotics / IEEE T-RO / Connection Science | Paper 7 |

---

## 4. Three-Layer Architecture Mapping

The three-layer architecture (Structure → Rule → Execution) in each paper:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Three-Layer Architecture Paper Mapping                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  Structure Layer - What data is                                            │
│  ─────────────────────────────────────────────────────────────────────     │
│  Paper 2: Three-layer - Everything is element                              │
│  Paper 5: Encoding & Gradient - Encoding scheme analysis                    │
│                                                                             │
│  Rule Layer - What data means                                             │
│  ─────────────────────────────────────────────────────────────────────     │
│  Paper 2: Three-layer - Observer system                                     │
│  Paper 4: Attention comparison - 8 attention rules                        │
│                                                                             │
│  Execution Layer - How data changes                                        │
│  ─────────────────────────────────────────────────────────────────────     │
│  Paper 2: Three-layer - CMD_PERCEIVE                                      │
│  Paper 6: Autoregressive generation - Causal decoding                      │
│                                                                             │
│  Cross-Layer Papers                                                       │
│  ─────────────────────────────────────────────────────────────────────     │
│  Paper 1: LSH-SFA - Overall (covers all three layers)                    │
│  Paper 3: LSH Format - Data format (cross-layer unified)                 │
│  Paper 8: LSH-Burn - Rust spacetime implementation                       │
│  Paper 9: LSH Rules - Self-verifying semantic system ★                   │
│  Paper 7: Foundational - Spacetime cognition deficit hypothesis           │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 5. Paper Dependencies

### 5.1 Dependency Graph

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         Paper Dependency Graph                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │                    Paper 1: LSH-SFA                               │     │
│    │                    (Core reference, cited by all)                   │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│           │                    │                    │                      │
│           │ Direct ref         │ Direct ref         │ Direct ref           │
│           ↓                    ↓                    ↓                      │
│    ┌─────────────┐      ┌─────────────┐      ┌─────────────┐            │
│    │ Paper 2     │      │ Paper 4     │      │ Paper 5     │            │
│    │ Three-layer │      │ Attention   │      │ Encoding &  │            │
│    │             │      │ Comparison  │      │ Gradient    │            │
│    └─────────────┘      └─────────────┘      └─────────────┘            │
│           │                                                              │
│           ↓                                                              │
│    ┌─────────────┐                                                      │
│    │ Paper 6     │                                                      │
│    │ Autoregr.   │                                                      │
│    └─────────────┘                                                      │
│                                                                           │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │     Paper 3: LSH Format (Architecture) ←─────→ Paper 8        │     │
│    │     Format architecture design        mutual    Rust validation  │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                                                           │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │     Paper 9: LSH Rules ★ (Self-Verification)                    │     │
│    │     ←─── manages ───→ rules/ directory                         │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                                                           │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │                    Paper 7: Foundational (Independent)            │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                                                           │
│    ┌─────────────────────────────────────────────────────────────────┐     │
│    │                    Paper 10: Version Control (Systems)            │     │
│    └─────────────────────────────────────────────────────────────────┘     │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 5.2 Dependency Matrix

| Referencer → | P1 | P2 | P3 | P4 | P5 | P6 | P7 | P8 | P9 | P10 |
|----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:---:|
| **Paper 1** | - | | | | | | | | | |
| **Paper 2** | ✅ | - | | | | | | | | |
| **Paper 3** | ✅ | | - | | | | | | | |
| **Paper 4** | ✅ | | | - | | | | | | |
| **Paper 5** | ✅ | | | | - | | | | | |
| **Paper 6** | ✅ | | | | | - | | | | |
| **Paper 7** | ✅ | ✅ | | ✅ | | ✅ | - | | | |
| **Paper 8** | ✅ | | | | | | | - | | |
| **Paper 9** | | | | | | | | | - | |
| **Paper 10** | | ✅ | | | | | | | | - |

**Mutual Verification**:
- Paper 3 ↔ Paper 8 (LSH Format ↔ LSH-Burn)
- Paper 9 ↔ rules/ (LSH Rules ↔ Rules Directory)

---

## 6. Paper to Code Repository Mapping

| Paper | Code Directory | Main Modules |
|-------|---------------|-------------|
| Paper 1 | `lsh-protocol/rust/src/intelligence/lsh_burn/` | `wave_packet.rs`, `spacetime_layer.rs` |
| Paper 2 | `lsh-protocol/rust/src/element/` | `element.rs`, `observer.rs` |
| Paper 3 | `lsh-protocol/rust/src/storage/` | `codec.rs`, `lsh_format.md` |
| Paper 4 | `lsh-protocol/docs/report/` | `注意力机制研究报告.md` |
| Paper 5 | `LSH_demo/` | `字节级编码研究报告.md` |
| Paper 6 | `lsh-protocol/rust/src/intelligence/lsh_burn/` | `decoder.rs`, `wave_packet_decoder.rs` |
| Paper 7 | `lsh-protocol/docs/` | `SPEC.md`, `architecture.md` |
| Paper 8 | `lsh-protocol/rust/src/intelligence/lsh_burn/` | `mod.rs` |
| Paper 9 | `paper/rules/` | `README.md`, rules files |
| Paper 10 | `lsh-protocol/rust/src/versioning/` | `ternary_version.rs` |

---

## 7. LaTeX/TikZ Specifications

### 7.1 Paper Template Structure

```latex
\documentclass[conference]{IEEEtran}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{amsmath,amssymb,amsfonts}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{xcolor}
\usepackage{tikz}

% LSH Shared symbols
\input{../common/definitions/lsh-core.tex}
\input{../common/definitions/math-notation.tex}

\begin{document}

\title{Paper Title}
\author{
  \IEEEauthorblockN{Hengbo Li}
  \IEEEauthorblockA{LSH Protocol\\1147502779@qq.com}
}

\maketitle

\begin{abstract}
...
\end{abstract}

\begin{IEEEkeywords}
keyword1, keyword2, keyword3
\end{IEEEkeywords}

\section{Introduction}
...

% Required validation sections (per structure_validation rules)
\section{Ablation Study}
...
\section{Experimental Configuration}
\subsection{Controlled Variables}
...
\section{Reproducibility}
...

\bibliographystyle{IEEEtran}

\begin{thebibliography}{10}
...
\end{thebibliography}

\end{document}
```

### 7.2 TikZ Drawing Specifications

```latex
% Three-layer architecture template
\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows, positioning, calc}

\tikzstyle{layer} = [
  draw,
  rectangle,
  rounded corners,
  minimum height=1.5cm,
  minimum width=3cm,
  fill=blue!10,
  font=\sffamily
]

\tikzstyle{element} = [
  draw,
  ellipse,
  minimum height=1cm,
  minimum width=2cm,
  fill=green!10,
  font=\sffamily\small
]

\begin{tikzpicture}[node distance=1.5cm, auto]
  % Structure layer
  \node[layer, fill=blue!20] (structure) {Structure Layer};

  % Rule layer
  \node[layer, fill=orange!20, below=of structure] (rule) {Rule Layer};

  % Execution layer
  \node[layer, fill=purple!20, below=of rule] (execution) {Execution Layer};

  % Connections
  \draw[->] (structure) -- (rule);
  \draw[->] (rule) -- (execution);
\end{tikzpicture}
```

### 7.3 Shared Figure Reference

```latex
% Reference shared three-layer figure
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{../common/figures/three-layer/lsh-three-layer.pdf}
  \caption{LSH Three-Layer Semantic Architecture}
  \label{fig:three-layer}
\end{figure}
```

---

## 8. Core Innovation Quick Reference

### Paper 1: LSH-SFA

| Innovation | Content |
|------------|---------|
| Wave packet | Token → (k, w, ω, θ) |
| Light-cone attention | O(n) complexity, high-freq local, low-freq global |
| PDE evolution | Diffusion (classification) / Convection (generation) |
| Resonance coupling | omega gating controls inter-layer transfer |

### Paper 2: Three-Layer

| Innovation | Content |
|------------|---------|
| Everything is element | Unified format, no special cases |
| Three semantic layers | Structure → Rule → Execution |
| Decay self-recording | History as compressed traces of current state |
| Observer system | Same world + different observers = different perceptions |

### Paper 3 ↔ Paper 8: LSH Format (Mutual Verification)

| Paper | Innovation |
|-------|------------|
| Paper 3 (Architecture) | Semantic ID + 96% token savings |
| Paper 8 (Engineering) | Rust/Burn implementation + 1+N pluggable backend |

### Paper 9: LSH Rules (Self-Verification)

| Innovation | Content |
|------------|---------|
| Self-application | rules/ is managed by LSH Rules itself |
| 1+N pattern | Rules use same naming as LSH Format |
| Mutual verification | Paper 9 describes rules, rules validate Paper 9 |

---

*Version: v9.0 | Date: 2026-05-12 | Change Log: Renumbered papers 1-10 (continuous), removed placeholder entries, updated directory structure*
