# LSH Paper Cross-Reference Index

**Version**: v7.0
**Date**: 2026-05-12
**Author**: Hengbo Li

---

## 1. Cross-Reference Overview

### 1.1 High-Frequency References

| Referenced Paper | Citations | Referenced By | Content |
|-----------------|-----------|---------------|---------|
| Paper 1 (LSH-SFA) | 7 | All Papers | Overall Architecture Foundation |
| Paper 2 (Three-Layer) | 3 | P3, P7, P10 | Element Model, Observer System |
| Paper 4 (Attention Comparison) | 1 | P7 | ELU+1 Optimality |
| Paper 3 (LSH Format) | 2 | P8, P9 | Format Design Referenced |
| Paper 9 (LSH Rules) | - | - | Self-verification system |

### 1.2 Reference Types

| Type | Description | Example |
|------|-------------|---------|
| **Foundation Reference** | Reference as overall framework | Paper 2 references Paper 1 |
| **Detail Reference** | Reference specific sections/innovations | Paper 4 references Paper 2's observer system |
| **Comparison Reference** | Compare different methods | Paper 4 compares Softmax vs LSH |
| **Extension Reference** | Extend based on existing work | Paper 6 extends Paper 1's causal mode |
| **Mutual Verification** | Architecture ↔ Engineering | Paper 3 ↔ Paper 8, Paper 9 ↔ rules/ |

**Note**: The rules/ directory is at `LSH_demo/rules/` (same level as `paper/`), reflecting that rules are a first-class citizen in the project architecture.

---

## 2. By Referenced Paper

### Paper 1: LSH-SFA Overall Architecture

**LSH ID**: `architecture_lsh_sfa-20260511_130001-a3f8c2`

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| Paper 2 | 2.3 | Wave packet (k, w, ω, θ) as three-layer foundation |
| Paper 3 | 1.2 | LSH Format based on Element model |
| Paper 4 | 3.1 | LSH field attention vs Softmax comparison |
| Paper 5 | 2.2 | Encoding comparison (byte-level vs LSH) |
| Paper 6 | 2.1 | Causal mode based on light-cone attention |
| Paper 7 | 2.2 | Transformer spacetime defects compared to LSH-SFA |
| Paper 8 | 2.1 | LSH-Burn implements spacetime field |

**Reference Format**:
```latex
% Reference Paper 1 in Paper 2
LSH-SFA~\cite{lsh-sfa} proposed wave packet representation...

% Or use cross-reference
See Paper 1~\ref{sec:wave-packet} for details.
```

---

### Paper 2: Three-Layer Semantic Architecture

**LSH ID**: `architecture_three_layer-20260511_130002-b7d2e1`

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| Paper 7 | 3.1 | Philosophical significance of three-layer |
| Paper 10 | 2.1 | Three-layer architecture as versioning foundation |

**Reference Format**:
```latex
% Reference observer system from Paper 2
Based on the three-layer semantic architecture's observer system~\cite{lsh-three-layer},
we propose CMD_PERCEIVE command...

% Reference in Paper 7
The three-layer architecture (Structure·Rule·Execution) embodies
"Structure·Rule·Execution" trinity~\cite[Section 2.2]{lsh-three-layer}.
```

---

### Paper 3: LSH Format

**LSH ID**: `architecture_lsh_format-20260511_130003-h9j8k7`

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| Paper 8 | - | Format design referenced in engineering |
| Paper 9 | - | LSH Rules adopts 1+N pattern |

**Mutual Verification**:

| Paper | Role | Content |
|-------|------|---------|
| Paper 3 | Architecture Design | LSH Format semantic ID + 96% token savings |
| Paper 8 | Engineering Validation | Rust/Burn 1+N pluggable backend + NF4 quantization |

**Reference Format**:
```latex
% Paper 3 references Paper 8
For engineering validation, see our companion paper on
Rust/Burn implementation~\cite{lsh-burn}.

% Paper 8 references Paper 3
The format design is described in our companion paper~\cite{lsh-format}.
```

---

### Paper 4: Attention Mechanism Comparison

**LSH ID**: `theory_attention_comparison-20260511_120002-d5f4g3`

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| Paper 7 | 4.3 | ELU+1 optimality analysis |

**Reference Format**:
```latex
% Reference in Paper 7
The systematic comparison of linear attention mechanisms~\cite{lsh-attention} shows
ELU+1 achieves the best balance between accuracy and efficiency...
```

---

### Paper 9: LSH Rules (Self-Verification)

**LSH ID**: `applications_lsh_rules-20260511_150002-m13n14o15`

**Key Innovation**: Self-verifying - the rules directory is managed by LSH Rules itself

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| rules/ | - | Self-management via LSH Rules |
| PAPER_MAP.md | - | LSH ID naming convention |

**Self-Verification Loop**:

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LSH Rules Self-Verification                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   LSH Rules System (Paper 9)                                       │
│   ├── Defines rules for project, paper, prompt                     │
│   ├── Uses 1+N pattern (same as LSH Format)                       │
│   └── RulesLoader implemented in Python                             │
│                            │                                        │
│                            │ Manages                                 │
│                            ▼                                        │
│   rules/ directory                                                   │
│   ├── project/ → managed by project_foundation                     │
│   ├── paper/ → managed by paper_foundation                         │
│   └── prompt/ → managed by prompt_foundation                       │
│                                                                     │
│   ════════════════════════════════════════════════════════════════   │
│              Mutual Verification: Paper 9 ↔ rules/                 │
│   ════════════════════════════════════════════════════════════════   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Reference Format**:
```latex
% Reference LSH Rules
LSH Rules provides a self-verifying semantic system~\cite{lsh-rules}.

% In the rules system itself
# This file is managed by LSH Rules
LSH ID: project_foundation-20260511-a1b2c3
```

---

### Paper 10: LSH Version Control (Ternary Semantic Versioning)

**LSH ID**: `systems_version_control-20260511_140004-p4q5r6`

**Key Innovation**: Architecture-driven versioning where carry rules (base-3) are derived from the three-layer architecture

**Referenced By**:

| Referencer | Section | Content |
|------------|---------|---------|
| lsh-protocol | Cargo.toml | Version numbering follows ternary carry |
| rules/ | - | Rule versioning follows ternary pattern |

**References To**:

| Referenced Paper | Section | Content |
|-----------------|---------|---------|
| Paper 2 | 2.1 | Three-layer architecture as versioning foundation |

**Architecture-Driven Versioning**:

```
┌─────────────────────────────────────────────────────────────────────┐
│           Ternary Versioning: Architecture-Driven Carry Rules        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   Three-Layer Architecture → Carry Base = 3                         │
│                                                                     │
│   Structure(0) → Rule(1) → Execution(2) → Carry                    │
│                                                                     │
│   Version: M.m.p                                                    │
│   ├── Patch: 0=Structure, 1=Rule, 2=Execution → carry to Minor     │
│   ├── Minor: 0=Structure, 1=Rule, 2=Execution → carry to Major     │
│   └── Major: 0=Structure, 1=Rule, 2=Execution → next paradigm      │
│                                                                     │
│   Fractal: Same 3-state pattern at every level                      │
│                                                                     │
│   0.0.0 → 0.0.1 → 0.0.2 → 0.1.0 → ... → 0.2.2 → 1.0.0           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Reference Format**:
```latex
% Reference LSH Version Control
LSH ternary versioning derives carry rules from the three-layer
architecture~\cite{lsh-version-control}, where each digit cycles
through Structure(0), Rule(1), Execution(2) before carrying.
```

---

## 3. By Topic Cross-Reference

### 3.1 Wave Packet Representation

**Related Papers**: Paper 1, Paper 2, Paper 6

| Paper | Content | Section |
|-------|---------|---------|
| Paper 1 | Wave packet definition (k, w, ω, θ) | 2.1 |
| Paper 2 | Wave packet as element attribute | 3.1 |
| Paper 6 | Wave packet decoder for generation | 3.1 |

**Reference Chain**: Paper 1 → Paper 2 → Paper 6

---

### 3.2 Light-Cone Attention

**Related Papers**: Paper 1, Paper 6

| Paper | Content | Section |
|-------|---------|---------|
| Paper 1 | Light-cone attention definition and O(n) complexity | 2.2 |
| Paper 6 | Causal mode inherits light-cone attention | 2.1 |

**Reference Chain**: Paper 1 → Paper 6

---

### 3.3 Three-Layer Architecture

**Related Papers**: Paper 1, Paper 2, Paper 7, Paper 10

| Paper | Content | Section |
|-------|---------|---------|
| Paper 1 | Three-layer overview | 2.5 |
| Paper 2 | Three-layer complete definition | 3.1-3.3 |
| Paper 7 | Three-layer philosophical reflection | 3.1 |
| Paper 10 | Three-layer as versioning foundation | 2.1 |

**Reference Chain**: Paper 1 → Paper 2 → Paper 7, Paper 10

---

### 3.4 1+N Pluggable Pattern

**Related Papers**: Paper 3, Paper 8, Paper 9, rules/

| Item | Content | Section |
|------|---------|---------|
| Paper 3 | LSH Format 1+N pattern definition | 2.2 |
| Paper 8 | Engineering validation of 1+N | - |
| Paper 9 | LSH Rules adopts 1+N for rules | - |
| rules/ | Self-managed using 1+N | - |

**Reference Chain**: Paper 3 → Paper 9 → rules/

---

### 3.5 Three-Layer Fractal Structure

The three-layer architecture (Structure·Rule·Execution) is **self-similar** across all rule files:

| Rule File | Structure | Rule | Execution |
|-----------|-----------|------|-----------|
| paper_foundation | 论文结构规范 | 引用/图表/公式规范 | 检查清单 |
| project_foundation | 目录结构规范 | 命名/导入/错误处理规范 | 检查清单 |
| prompt_foundation | 模板结构规范 | 角色/输出格式规范 | 检查清单 |
| project_standard | MVVM分层 | Signal/Slot/EventBus | 通信验证 |

**Fractal Self-Verification**: Each rule file ITSELF demonstrates the three-layer architecture it describes.

---

## 4. Reference Format Specification

### 4.1 LaTeX Cross-Reference Template

```latex
% Define cross-reference commands in preamble
\newcommand{\paperref}[2]{%
  \href{#1}{#2}%
}

% Foundation reference
LSH-SFA~\cite{lsh-sfa} proposed...

% Section reference
See Section~\ref{sec:wave-packet} or Paper~\ref{lsh-sfa} Section 2.1.

% Multi-paper joint reference
Based on Paper 1~\cite{lsh-sfa} and Paper 2~\cite{lsh-three-layer}...

% Using predefined commands (recommended)
\LSHRef{lsh-sfa}{sec:wave-packet}  % Reference wave packet section in Paper 1
\ThreeLayerRef{}                   % Reference three-layer in Paper 2
```

### 4.2 Markdown Cross-Reference Template

```markdown
# Link to other papers

[Paper 1: LSH-SFA](../architecture/architecture_lsh_sfa-20260511_130001-a3f8c2/main.tex)

# Link to specific sections

[Wave packet section](../architecture/architecture_lsh_sfa-20260511_130001-a3f8c2/main.tex#L100-L120)

# Reference chain example

This paper extends the wave packet representation from [Paper 1],
to the three-layer architecture in [Paper 2],
and applies it to autoregressive generation in [Paper 6].
```

---

## 5. Co-Citation Analysis

### 5.1 Multi-Paper Co-Citation Scenarios

| Scenario | Required Papers | Description |
|----------|-----------------|-------------|
| Complete three-layer intro | P1 + P2 | Overall + detailed |
| Complete execution layer | P1 + P2 | Architecture + three-layer |
| Autoregressive generation | P1 + P6 | Complete technical chain |
| Ethical reflection | P1 + P2 + P4 + P7 | Architecture + attention + foundational |
| LSH Rules system | P3 + P9 | Format + self-verification |

### 5.2 Independent Reading Guide

Papers that can be read independently:

| Paper | Feasibility | Reason |
|-------|-------------|--------|
| Paper 1 | ✅ Fully independent | Overall architecture, no prerequisites |
| Paper 4 | ✅ Fully independent | Attention mechanism comparison, independent study |
| Paper 5 | ✅ Fully independent | Encoding analysis, independent study |
| Paper 3 | ✅ Fully independent | Data format, architecture-agnostic |
| Paper 7 | ⚠️ Partially dependent | References P1, P2, P4, can skip |
| Paper 9 | ✅ Self-contained | Self-verification is the point |

---

## 6. Cross-Reference Checklist

Before submission, verify:

- [ ] Paper 2 references Paper 1 (three-layer based on wave packet)
- [ ] Paper 3 references Paper 1 (LSH Format based on architecture)
- [ ] Paper 4 references Paper 1 (attention comparison based on LSH-SFA)
- [ ] Paper 5 references Paper 1 (encoding comparison based on LSH)
- [ ] Paper 6 references Paper 1 (autoregressive based on LSH-SFA)
- [ ] Paper 7 references Paper 1, Paper 2, Paper 4 (philosophical reflection based on technology)
- [ ] Paper 8 references Paper 1, Paper 3 (LSH-Burn implements LSH Format)
- [ ] Paper 9 references Paper 3 (LSH Rules based on LSH Format 1+N)
- [ ] Paper 10 references Paper 2 (versioning based on three-layer architecture)

---

*Version: v7.0 | Date: 2026-05-12 | Change Log: Renumbered papers 1-10 (continuous), removed placeholder entries, updated all cross-references*
