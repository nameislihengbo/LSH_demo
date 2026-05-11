# LSH Rules System / LSH 规则系统

**版本**: v4.0
**日期**: 2026-05-11
**作者**: 李恒波
**定位**: 语义系统、超级规则增强、提示词增强
**参考**: SPEC.md (`lsh-protocol/docs/SPEC.md`) | LSH Format (DOI pending) | 1+N 可插拔后端模式

---

## 零、三层架构 - 分形结构 / Three-Layer Fractal Architecture

### 0.1 设计理念

LSH 规则系统是**三层架构的深度应用范例**。三层架构（Structure·Rule·Execution）在规则系统中以**分形结构**呈现：

```
┌─────────────────────────────────────────────────────────────────────┐
│                    分形结构：三层架构递归应用                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  三层架构普遍存在，层层递进，自相似：                                   │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Structure Layer (结构层) - What it IS                      │   │
│  │  定义规范、格式模板、数据结构                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Rule Layer (规则层) - What it MEANS                        │   │
│  │  语义约束、业务规则、关系定义                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Execution Layer (执行层) - How it is ENFORCED              │   │
│  │  验证机制、检查清单、强制执行                                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 0.2 分形结构验证

三层架构在 LSH 项目中的分形验证：

| 应用层 | Structure | Rule | Execution |
|--------|-----------|------|-----------|
| **论文 Paper** | 结构规范 | 引用/图表/公式规范 | 检查清单 |
| **项目 Project** | 目录结构 | 命名/导入/错误处理规范 | 检查清单 |
| **提示词 Prompt** | 模板结构 | 角色/输出格式规范 | 检查清单 |
| **代码 Code** | 类型定义 | FFI/SerDe 规则 | 内嵌测试 |
| **MVVM ViewModel** | QObject 继承 | Signal/Slot 规范 | EventBus 通信 |
| **LSH Format** | 元素结构 | 语义ID/属性定义 | 编解码验证 |

---

## 一、命名规范 / Naming Conventions

### 1.1 大小写规则：默认小写，兼容旧文件

**核心原则**：
- **新建文件名**：统一使用**小写**
- **旧文件兼容**：保留原有大小写，系统自动兼容

| 类别 | 规则 | 示例 |
|------|------|------|
| 新建目录 | 小写 | `structures`, `rules`, `executions` |
| 新建文件 | 小写 | `rules.md` (不是 `Rules.md`) |
| 旧文件 | 保留原名 | `LSH_demo/` (已存在，保持不变) |
| 路径匹配 | 大小写不敏感 | `LSH_demo` = `lsh_demo` = `LshDemo` |

### 1.2 标识符标准化算法

所有标识符在系统内统一标准化为**小写 + 下划线**格式：

```
Step 1: 转小写 (toLowerCase)
Step 2: 分隔符统一 (-, .) → 下划线 (_)
Step 3: 合并连续下划线
Step 4: 去除首尾下划线
```

| 输入 | 标准化结果 | 说明 |
|------|------------|------|
| `LSH_DEMO` | `lsh_demo` | SCREAMING_SNAKE → 小写 |
| `LSHDemo` | `lshdemo` | CamelCase (无分隔符) |
| `lsh-demo` | `lsh_demo` | kebab-case → 下划线 |
| `lsh..demo` | `lsh_demo` | 合并连续点号 |
| `_lsh_demo_` | `lsh_demo` | 去除首尾下划线 |

### 1.3 目录命名：3×3×3 架构

LSH 项目根目录采用 **3×3×3 = 27 位置**的分形结构：

```
{X}/{Y}/{Z}  where X,Y,Z ∈ {structures, rules, executions}
```

**27 个位置矩阵**：

| 坐标 | 位置路径 |
|------|----------|
| [0,0,0] | structures/structures/structures |
| [0,0,1] | structures/structures/rules |
| [0,0,2] | structures/structures/executions |
| [0,1,0] | structures/rules/structures |
| ... | ... |
| [2,2,2] | executions/executions/executions |

**检索特性**：
- 层级深度：3（只需搜索 3 次）
- 总位置数：27（3³）
- 任何文件最多 3 次遍历定位

---

## 二、规则系统架构 / Rules System Architecture

### 2.1 核心原则：规则即元素

**规则就是 Element**，直接复用 lsh-protocol 的 Element 模型，无需重复定义。

```
┌─────────────────────────────────────────────────────────────────────┐
│                    规则 = Element                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Element {                                                          │
│      id:   "code_rust-20260511_090002-e4f5g6"     ← LSH ID               │
│      name: "Rust 代码规范"                  ← 规则名称              │
│      category: "code"                      ← 规则类型              │
│      tags: ["rust", "foundation"]          ← 规则模块              │
│      properties: {                                                 │
│          level: "foundation"               ← 规则层级              │
│          version: "1.0"                    ← 版本号                │
│          references: [...]                 ← 引用列表              │
│      }                                                             │
│  }                                                                  │
│                                                                     │
│  LSH ID 格式: {prefix}[_group...]-{timestamp}-{hash}               │
│  示例: code_rust-20260511_090002-e4f5g6                            │
│       ├─prefix─┤├group├─────── ─────├─hash─┤                      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Element 属性映射**：

| Element 字段 | 规则含义 | 示例 |
|-------------|---------|------|
| `id` | LSH ID | `code_rust-20260511_090002-e4f5g6` |
| `name` | 规则名称 | `"Rust 代码规范"` |
| `category` | 规则类型 (prefix) | `"code"`, `"structure"`, `"prompt"` |
| `tags` | 规则模块 (group) | `["rust"]`, `["foundation"]` |
| `properties.level` | 规则层级 | `"foundation"`, `"standard"`, `"guide"` |
| `properties.version` | 版本号 | `"1.0"` |
| `properties.references` | 引用列表 | `["structure_foundation-20260511_110001-j1k2l3"]` |

**优势**：
- **零重复**：直接复用 Element 模型，无需重新定义 ID 格式、类型映射
- **可追溯**：规则存储在 lsh-protocol 的 World 中，支持查询、索引
- **可扩展**：通过 `properties` 添加任意属性，无需修改结构
- **一致性**：与 lsh-protocol 的 Element 完全一致

### 1.2 LSH ID 格式

遵循 lsh_format.md §2.2 唯一抽象：`{prefix}[_group...]-{timestamp}-{hash}`

| 组件 | 分隔符 | 说明 | 示例 |
|------|--------|------|------|
| prefix | `_` | category (1) | `code`, `structure`, `prompt` |
| group | `_` | tags (N) | `rust`, `foundation`, `validation` |
| timestamp | `-` | 创建时间 | `20260511_090002` |
| hash | `-` | 唯一标识 | `e4f5g6` |

**核心原则**：`-` 是唯一抽象，分隔语义部分与 timestamp/hash。

### 1.3 规则目录结构

```
rules/                                    # 规则系统根目录
├── rules.md                              # 总规则文件（本文件）
│
├── structure/                            # 结构层 (Structure)
│   ├── structure_foundation-20260511_110001-j1k2l3.md
│   ├── structure_latex_tikz-20260511_110002-x1y2z3.md
│   └── structure_validation-20260511_110003-p7q8r9.md
│
├── project/                              # 规则层 (Rule) - 项目规则
│   ├── project_foundation-20260511_080001-a1b2c3.md
│   └── project_standard-20260511_080002-d4e5f6.md
│
├── code/                                 # 规则层 (Rule) - 代码规则
│   ├── code_foundation-20260511_090001-b1c2d3.md
│   └── code_rust-20260511_090002-e4f5g6.md
│
├── prompt/                               # 规则层 (Rule) - 提示词规则
│   ├── prompt_foundation-20260511_100001-s1t2u3.md
│   └── prompt_engineering_chain-20260511_100002-y7z8a9.md
│
└── execution/                            # 执行层 (Execution)
    ├── execution_version_benchmark-20260511_170001-v1w2x3.md
    └── execution_lsh_benchmark-20260511_170002-w3x4y5.md
```

**三层架构映射**：

| 层级 | 目录 | 说明 |
|------|------|------|
| **Structure (结构层)** | `structure/` | 定义规范、格式模板、数据结构 |
| **Rule (规则层)** | `project/`, `code/`, `prompt/` | 语义约束、业务规则、关系定义 |
| **Execution (执行层)** | `execution/` | 验证机制、检查清单、强制执行 |

---

## 三、类型继承规则 / Type Inheritance Rules

### 3.1 继承来源：LSH 协议 SPEC.md

LSH 协议（`lsh-protocol/docs/SPEC.md`）定义了类型继承机制：

| SPEC.md 概念 | 规则系统对应 | 说明 |
|-------------|-------------|------|
| `category` | 规则类型 | `project`, `code`, `prompt`, `structure`, `execution` |
| `tags` | 规则模块 | `mvvm`, `latex`, `validation`, `rust`, `benchmark` |
| `CATEGORY_DEFAULTS` | 规则层级默认值 | Foundation 层定义默认属性 |
| 类型推断 | 规则自动分类 | 根据文件路径推断适用规则 |
| 标签自动继承 | 规则继承 | 子规则继承父规则的约束 |

### 2.2 规则类型继承树（三层架构）

```
LSH Rules (根)
│
├── Structure (结构层) - What it IS
│   └── structure/
│       ├── structure:foundation      → 论文结构规范
│       ├── structure:validation      → 论文验证规范
│       └── structure:latex_tikz      → LaTeX/TikZ 规范
│
├── Rule (规则层) - What it MEANS
│   ├── project/
│   │   ├── project:foundation       → 目录结构、命名规范、导入顺序
│   │   └── project:standard         → MVVM 架构、模块划分
│   │
│   ├── code/
│   │   ├── code:foundation          → 跨语言结构、FFI一致性、类型映射
│   │   └── code:rust                → Cargo.toml、错误处理、内嵌测试
│   │
│   └── prompt/
│       ├── prompt:foundation         → 角色定义、输出格式
│       └── prompt:engineering_chain → 超级提示词、思维链
│
└── Execution (执行层) - How it is ENFORCED
    └── execution/
        ├── execution:version_benchmark   → 版本控制基准验证
        └── execution:lsh_benchmark       → LSH 协议基准验证
```

### 2.3 三层架构映射

```
┌─────────────────────────────────────────────────────────────────────┐
│                    LSH Rules 三层架构                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Structure (结构层) - What it IS                           │   │
│  │  定义规范、格式模板、数据结构                                  │   │
│  │  目录: structure/                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Rule (规则层) - What it MEANS                             │   │
│  │  语义约束、业务规则、关系定义                                  │   │
│  │  目录: project/, code/, prompt/                             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              ↓                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  Execution (执行层) - How it is ENFORCED                   │   │
│  │  验证机制、检查清单、强制执行                                  │   │
│  │  目录: execution/                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.4 继承规则

**核心区别**：规则间是**父子关系**（继承细化），不是包含关系；同时也是**可插拔替换关系**。

| 规则 | 说明 | 示例 |
|------|------|------|
| **父子关系** | 子规则继承并细化父规则，不是包含 | `structure:validation` 继承 `structure:foundation` 的引用规范并细化 |
| **可插拔替换** | 同级规则可互相替换，不改变父规则 | `structure:validation` ↔ `structure:latex_tikz`，均继承自 `structure:foundation` |
| **类型继承** | 子规则继承父类型的约束 | `structure:validation` 继承 `structure:foundation` 的引用规范 |
| **层级继承** | Standard 继承 Foundation | `project:standard` 继承 `project:foundation` 的命名规范 |
| **模块继承** | 模块规则继承类型基础 | `code:rust` 继承 `code:foundation` 的 FFI 规则 |
| **标签继承** | 规则自动包含父类型标签 | `structure:validation` 自动包含 `structure` 标签 |

```
┌─────────────────────────────────────────────────────────────────────┐
│           父子关系 vs 可插拔替换关系                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  structure (1)                                                          │
│  └── structure_foundation (N: 继承细化)                                  │
│      ├── structure_validation (N: 可插拔替换)                            │
│      └── structure_latex_tikz  (N: 可插拔替换)                          │
│                                                                     │
│  structure_foundation 是 structure 的细化（父子）                       │
│  structure_validation 与 structure_latex_tikz 互为可替换（同级）        │
│  替换 structure_validation → structure_latex_tikz 不影响 structure_foundation     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.4 继承实现（参照 SPEC.md Section 4.2）

```python
RULE_CATEGORY_DEFAULTS = {
    "project": {
        "default_tags": ["project", "structure"],
        "inherit_properties": {
            "naming_convention": "snake_case",
            "import_order": "stdlib→third_party→local",
        }
    },
    "structure": {
        "default_tags": ["structure", "academic"],
        "inherit_properties": {
            "citation_style": "IEEEtran",
            "figure_format": "vector",
        }
    },
    "code": {
        "default_tags": ["code", "cross-language"],
        "inherit_properties": {
            "ffi_consistency": True,
            "embedded_tests": True,
        }
    },
}

def get_rule_defaults(rule_type: str) -> dict:
    defaults = RULE_CATEGORY_DEFAULTS.get(rule_type, {})
    return defaults.get("inherit_properties", {})
```

---

## 四、规则层级说明

### 4.1 Foundation (基础层)

**定位**: 必须遵守的最低要求，不可违反

| 规则类型 | 文件 | 核心内容 |
|----------|------|----------|
| project_foundation | 项目基础 | 目录结构、命名规范、导入顺序 |
| structure_foundation | 结构基础 | 论文格式要求、引用规范 |
| prompt_foundation | 提示词基础 | 角色定义、输出格式 |
| code_foundation | 代码基础 | 跨语言结构、FFI一致性、类型映射 |

### 4.2 Standard (标准层)

**定位**: 推荐遵循的最佳实践，继承 Foundation

| 规则类型 | 文件 | 核心内容 | 继承自 |
|----------|------|----------|--------|
| project_standard | 项目标准 | MVVM 架构、模块划分 | project_foundation |
| structure_validation | 结构验证 | 对比测试、控制变量、泛化、可复现 | structure_foundation |
| code_rust | Rust 标准 | Cargo.toml、错误处理、内嵌测试 | code_foundation |

### 4.3 Guide (指南层)

**定位**: 特定场景的指导建议，继承 Standard

| 规则类型 | 文件 | 核心内容 | 继承自 |
|----------|------|----------|--------|
| structure_latex_tikz | LaTeX 指南 | TikZ 绘图、表格规范 | structure_validation |
| prompt_engineering | 提示词工程 | 超级提示词、思维链 | prompt_foundation |

---

## 五、由浅入深的学习路径

### 路线 A：开发者路径（项目 + 代码）

```
Step 1: project_foundation
   ↓ 理解项目结构和命名规范
Step 2: code_foundation
   ↓ 掌握跨语言结构定义、FFI一致性、类型映射
Step 3: code_rust
   ↓ 深入 Rust 特定规范（Cargo.toml、内嵌测试）
Step 4: project_standard
   ↓ 理解 MVVM 架构
```

### 路线 B：研究者路径（结构 + 验证）

```
Step 1: structure_foundation
   ↓ 掌握论文基本格式
Step 2: structure_validation
   ↓ 掌握对比测试、控制变量、泛化测试、可复现
Step 3: structure_latex_tikz
   ↓ 学习 LaTeX 和 TikZ
Step 4: prompt_engineering
   ↓ 超级提示词工程
```

---

## 六、规则加载机制

### 6.1 LSH 规则加载器

```python
class RulesLoader:
    """LSH 规则加载器 - 支持 1+N 可插拔模式 + 类型继承"""

    def __init__(self, rules_dir: str = "rules/"):
        self.rules_dir = Path(rules_dir)
        self._cache: dict[str, dict] = {}

    def load_rule(self, lsh_id: str) -> dict:
        parsed = self._parse_lsh_id(lsh_id)
        rule_path = self.rules_dir / parsed['type'] / f"{lsh_id}.md"
        with open(rule_path, 'r', encoding='utf-8') as f:
            content = f.read()
        rule = {'lsh_id': lsh_id, 'content': content, **parsed}
        self._cache[lsh_id] = rule
        return rule

    def load_with_inheritance(self, lsh_id: str) -> dict:
        """加载规则并合并继承的父规则"""
        parsed = self._parse_lsh_id(lsh_id)
        rule_type = parsed['type']
        rule_level = parsed['level']

        inherited = {}
        if rule_level in ('standard', 'guide'):
            foundation = self._find_rule(rule_type, 'foundation')
            if foundation:
                inherited = {'foundation': foundation}

        rule = self.load_rule(lsh_id)
        rule['inherited'] = inherited
        return rule

    def load_all(self, rule_type: str) -> list[dict]:
        type_dir = self.rules_dir / rule_type
        rules = []
        for path in type_dir.glob("*.md"):
            rules.append(self.load_rule(path.stem))
        return sorted(rules, key=lambda r: r['level'])

    def _parse_lsh_id(self, lsh_id: str) -> dict:
        import re
        pattern = r'^([a-z]+)_([a-z]+)(_[a-z_]+)?-(\d{8}_\d{6})-([a-z0-9]+)$'
        match = re.match(pattern, lsh_id)
        if not match:
            raise ValueError(f"Invalid LSH ID: {lsh_id}")
        return {
            'type': match.group(1),
            'level': match.group(2),
            'module': match.group(3) or '',
            'date': match.group(4),
            'hash': match.group(5)
        }

    def _find_rule(self, rule_type: str, level: str) -> dict | None:
        type_dir = self.rules_dir / rule_type
        for path in type_dir.glob(f"{rule_type}_{level}-*.md"):
            return self.load_rule(path.stem)
        return None
```

---

## 七、与 LSH 协议的对应关系 / LSH Protocol Mapping

### 7.1 SPEC.md 概念映射

| SPEC.md 概念 | LSH Rules 对应 | SPEC.md 章节 |
|-------------|----------------|-------------|
| Element 结构 | 规则文件结构 | Section 6 |
| category | 规则类型 | Section 4.1 |
| tags | 规则模块标签 | Section 4.4 |
| CATEGORY_DEFAULTS | 规则层级默认值 | Section 4.2 |
| 类型推断 | 规则自动分类 | Section 4.3 |
| 三层架构 | Structure·Rule·Execution | Section 3 |
| 事件系统 | 规则触发机制 | Section 7 |
| 世界存储 | 规则持久化 | Section 10 |

### 7.2 三层架构映射（SPEC.md Section 3）

| SPEC.md 三层 | LSH Rules 三层 | 说明 |
|-------------|----------------|------|
| Structure (device, room, field, wave) | Structure (目录结构, 类型定义) | 结构定义 |
| Rule (observer, perception_rule) | Rule (命名规范, FFI规则, 验证规则) | 语义约束 |
| Execution (CMD_PERCEIVE, CMD_EXECUTE) | Execution (检查清单, 内嵌测试) | 执行验证 |

### 7.3 元素结构一致性（SPEC.md Section 6）

规则文件遵循 LSH 元素结构：

```markdown
# 规则文件 = Element 结构映射

**LSH ID**: {lsh_id}                    ← Element.id
**类型**: {rule_type}                    ← Element.category
**层级**: Foundation/Standard/Guide      ← Element.tags
**引用**: {DOI或LSH_ID}                  ← Element.properties

## 零、三层架构                          ← Element 结构层
## 一~五、规则内容                        ← Element 规则层
## 六、检查清单                          ← Element 执行层
```

---

## 八、规则编写规范 / Rule Writing Specification

### 8.1 文件命名

```
{规则类型}_{规则层级}[_模块]-{timestamp}-{hash}.md
```

### 8.2 文件结构

```markdown
# {规则标题}

**版本**: v1.0
**日期**: 2026-05-11
**层级**: Foundation/Standard/Guide
**类型**: {规则类型}
**LSH ID**: {lsh_id}
**引用**: {DOI或LSH_ID引用}

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure** | ... | ... |
| **Rule** | ... | ... |
| **Execution** | ... | ... |

---

## 一~N. 规则内容

## N+1. 检查清单 / Checklist

- [ ] 检查项
```

### 8.3 引用规范

| 优先级 | 类型 | 说明 |
|--------|------|------|
| P0 | DOI | 正式发表后使用 DOI 引用 |
| P1 | LSH ID | 未发表/内部引用使用 LSH ID |
| P2 | URL | 代码实现使用 GitHub URL |

**禁止**：避免在正文中引用文字描述作为依据。

---

## 九、引用说明 / Citation Reference

### 9.1 参考文献表

| ID | 类型 | 标识符 | 说明 |
|----|------|--------|------|
| `lsh-format-doi` | DOI | `10.xxxxx/zenodo.xxxxxx` | LSH Format（待分配） |
| `lsh-rules-doi` | DOI | `10.xxxxx/zenodo.xxxxxx` | LSH Rules（待分配） |
| `architecture_lsh_sfa-20260511_130001-a3f8c2` | LSH ID | - | Paper 1: LSH-SFA |
| `architecture_three_layer-20260511_130002-b7d2e1` | LSH ID | - | Paper 2: 三层架构 |
| `architecture_lsh_format-20260511_130003-h9j8k7` | LSH ID | - | Paper 3: LSH 格式 |
| `theory_attention_comparison-20260511_120002-d5f4g3` | LSH ID | - | Paper 4: 注意力对比 |
| `theory_tokenizer_free-20260511_120003-e6g5h4` | LSH ID | - | Paper 5: 编码与梯度 |
| `applications_autoregressive-20260511_150001-i10k9l8` | LSH ID | - | Paper 6: 自回归生成 |
| `foundational_spacetime_cognition-20260511_160001-j11k10m9` | LSH ID | - | Paper 7: 时空认知缺失 |
| `systems_lsh_burn-20260511_140003-l13m14n15` | LSH ID | - | Paper 8: LSH-Burn |
| `applications_lsh_rules-20260511_150002-m13n14o15` | LSH ID | - | Paper 9: LSH 规则 |
| `systems_version_control-20260511_140004-p4q5r6` | LSH ID | - | Paper 10: 版本控制 |
| `lsh-protocol-github` | URL | `https://github.com/hengbo-li/lsh-protocol` | LSH Protocol 仓库 |
| `lsh-protocol-spec` | SPEC.md | `lsh-protocol/docs/SPEC.md` | LSH 协议规范 |

**已合并的论文（不再独立存在）**：

| 旧 LSH ID | 合并到 | 说明 |
|-----------|--------|------|
| `theory_spacetime_engine-20260511_120001-c4e3f2` | `architecture_lsh_sfa-20260511_130001-a3f8c2` | 时空引擎 → LSH-SFA |
| `systems_execution_layer-20260511_140001-g8i7j6` | `architecture_three_layer-20260511_130002-b7d2e1` | 执行层 → 三层架构 |
| `theory_gradient_paradigm-20260511_120004-f7h6i5` | `theory_tokenizer_free-20260511_120003-e6g5h4` | 梯度范式 → 编码与梯度 |
| `systems_rust_optimization-20260511_140002-k12l13m14` | `architecture_lsh_format-20260511_130003-h9j8k7` | Rust 优化 → LSH 格式 |

### 9.2 LaTeX 参考文献条目

```bibtex
@misc{lsh-sfa-2026,
  author       = {Li, Hengbo},
  title        = {LSH-SFA: Spacetime Field Attention with Wave Packets, Light-Cone Causality, and PDE-Driven Evolution},
  year         = {2026},
  note         = {LSH ID: architecture_lsh_sfa-20260511_130001-a3f8c2},
  howpublished = {\url{https://github.com/hengbo-li/lsh-protocol}}
}

@misc{lsh-three-layer-2026,
  author       = {Li, Hengbo},
  title        = {LSH: Element-Observers Semantic Architecture with Emergent Execution},
  year         = {2026},
  note         = {LSH ID: architecture_three_layer-20260511_130002-b7d2e1},
  howpublished = {\url{https://github.com/hengbo-li/lsh-protocol}}
}

@misc{lsh-format-2026,
  author       = {Li, Hengbo},
  title        = {LSH Format: AI-Native Data Format with Rust/Burn Engineering Validation},
  year         = {2026},
  note         = {LSH ID: architecture_lsh_format-20260511_130003-h9j8k7},
  howpublished = {\url{https://github.com/hengbo-li/lsh-protocol}}
}

@misc{lsh-rules-2026,
  author       = {Li, Hengbo},
  title        = {LSH Rules: Self-Verifying Semantic System},
  year         = {2026},
  note         = {LSH ID: applications_lsh_rules-20260511_150002-m13n14o15},
  howpublished = {\url{https://github.com/hengbo-li/lsh-protocol}}
}

@misc{lsh-version-control-2026,
  author       = {Li, Hengbo},
  title        = {LSH Version Control: Ternary Semantic Versioning Based on Three-Layer Architecture},
  year         = {2026},
  note         = {LSH ID: systems_version_control-20260511_140004-p4q5r6},
  howpublished = {\url{https://github.com/hengbo-li/lsh-protocol}}
}
```

---

## 十、执行层基准测试 / Execution Layer Benchmarks

### 10.1 版本控制基准测试

| 测试项 | 吞吐量 | 状态 |
|--------|--------|------|
| Base-3 增量 | 267M ops/sec | ✅ |
| SemVer 增量 | 295M ops/sec | ✅ |
| 版本比较 | 313M ops/sec | ✅ |

详见：`execution/execution_version_benchmark-20260511_170001-v1w2x3.md`

---

*文档版本: v4.0 | 更新日期: 2026-05-11 | 定位: 语义系统、超级规则增强、提示词增强*
