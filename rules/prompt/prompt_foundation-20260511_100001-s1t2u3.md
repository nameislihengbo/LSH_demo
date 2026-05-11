# Prompt Foundation Rules

**LSH ID**: prompt_foundation-20260511_100001-s1t2u3
**cat**: prompt | **tags**: foundation | **level**: foundation | **version**: 1.0
**引用**: applications_lsh_rules-20260511_150002-m13n14o15

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | 提示词结构规范（角色定义、核心能力、输出格式） | 第一节：提示词结构规范 |
| **Rule 规则层** | 角色定义规范、输出格式规范、链式思考规范、输入处理规范 | 第二~五节 |
| **Execution 执行层** | 强制检查清单 | 第六节：强制检查清单 |

---

## 一、提示词结构规范

### 1.1 标准提示词结构

```markdown
# 角色定义
你是一个 [角色描述]，专注于 [专业领域]。

# 核心能力
- 能力1
- 能力2
- 能力3

# 输出格式
请按以下格式输出：
```
[输出格式定义]
```

# 约束条件
- 约束1
- 约束2

# 输入处理
当收到 [输入类型] 时，请：
1. 步骤1
2. 步骤2

# 示例
## 示例1
输入：[示例输入]
输出：[期望输出]
```

### 1.2 提示词组成

| 部分 | 必须 | 说明 |
|------|------|------|
| 角色定义 | ✅ | 明确 AI 身份 |
| 核心能力 | ✅ | 定义职责范围 |
| 输出格式 | ✅ | 结构化输出 |
| 约束条件 | ⚠️ | 可选 |
| 示例 | ⚠️ | few-shot 时必须 |

---

## 二、角色定义规范

### 2.1 角色描述模板

```markdown
# 角色定义
你是一个 [角色类型]，具备以下特点：
- [特点1]
- [特点2]
- [特点3]

# 专业领域
- 领域：[具体领域]
- 经验：[年限/程度]
- 风格：[回答风格]
```

### 2.2 角色类型示例

```markdown
# LSH 架构专家
你是一个 LSH-SFA 架构专家，专注于：
- 时空场注意力机制设计
- 波包表示优化
- 三层语义架构实现

# Python 开发助手
你是一个 Python 开发专家，擅长：
- Python 3.10+ 特性
- PySide6 GUI 开发
- FastAPI 后端架构

# 论文写作助手
你是一个学术论文写作专家，精通：
- LaTeX 排版
- 学术英语表达
- 图表规范
```

---

## 三、输出格式规范

### 3.1 结构化输出

```markdown
# 输出格式要求
请使用以下 JSON 格式输出：
```json
{
  "status": "success|error",
  "data": {
    "key1": "value1",
    "key2": "value2"
  },
  "message": "说明信息"
}
```

# 代码输出要求
请使用以下格式输出代码：
```python
# 语言标识
code here
```
```

### 3.2 格式验证

```markdown
# 输出验证
在输出前，请检查：
1. 是否符合指定格式？
2. 是否包含所有必需字段？
3. 数据类型是否正确？

# 错误处理
如果输入无效，请返回：
```json
{
  "status": "error",
  "message": "错误原因"
}
```
```

---

## 四、链式思考 (Chain of Thought)

### 4.1 思考链模板

```markdown
# 思考过程
当遇到复杂问题时，请按以下步骤思考：

1. **问题分析**
   - 输入是什么？
   - 需要输出什么？
   - 关键约束条件？

2. **方案设计**
   - 有哪些可能的方案？
   - 各方案的优缺点？
   - 推荐方案及理由？

3. **执行验证**
   - 方案是否可行？
   - 结果是否满足要求？
   - 有无遗漏边界情况？

4. **输出构建**
   - 按什么格式输出？
   - 如何验证正确性？
```

### 4.2 Few-shot 示例

```markdown
# Few-shot 示例

## 示例1：情感分析
输入：今天天气真好，阳光明媚。
输出：
```json
{
  "sentiment": "positive",
  "confidence": 0.95,
  "keywords": ["好", "阳光", "明媚"]
}
```

## 示例2：情感分析
输入：考试没考好，心情很低落。
输出：
```json
{
  "sentiment": "negative",
  "confidence": 0.92,
  "keywords": ["没考好", "低落"]
}
```

## 你的任务
输入：刚收到升职通知，非常开心！
输出：
```

---

## 五、输入处理规范

### 5.1 输入解析

```markdown
# 输入格式
用户将提供以下格式的输入：
- 纯文本
- JSON
- Markdown

# 解析规则
1. 如果是纯文本，直接处理
2. 如果是 JSON，提取 `query` 字段
3. 如果是 Markdown，提取代码块内容

# 错误处理
如果输入格式不正确，请返回：
```json
{
  "status": "error",
  "message": "输入格式错误，请提供 {expected_format}"
}
```
```

### 5.2 上下文管理

```markdown
# 上下文记忆
- 短期记忆：当前会话中的关键信息
- 长期记忆：[用户在 profile 中的偏好设置]

# 上下文更新
在每次交互后，请更新上下文：
```json
{
  "last_topic": "讨论主题",
  "pending_issues": ["未解决问题1", "未解决问题2"],
  "user_preferences": {"偏好": "设置"}
}
```
```

---

## 六、强制检查清单

- [ ] 角色定义清晰
- [ ] 核心能力明确
- [ ] 输出格式结构化
- [ ] 示例符合期望格式
- [ ] 错误处理完整
- [ ] 思考链逻辑清晰

---

## 七、提示词组合

### 7.1 多提示词组合

```python
# 组合多个基础提示词
project_rules = load_rules("project_foundation")
paper_rules = load_rules("paper_foundation")
prompt_rules = load_rules("prompt_foundation")

# 合并为系统提示词
system_prompt = f"""
{project_rules['content']}

{paper_rules['content']}

{prompt_rules['content']}
"""
```

---

*LSH ID: prompt_foundation-20260511_100001-s1t2u3*
