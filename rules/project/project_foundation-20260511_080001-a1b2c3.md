# Project Foundation Rules

**LSH ID**: project_foundation-20260511_080001-a1b2c3
**cat**: project | **tags**: foundation | **level**: foundation | **version**: 1.0
**引用**: architecture_three_layer-20260511_130002-b7d2e1 | systems_execution_layer-20260511_140001-g8i7j6

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | 目录结构规范、模块命名规范 | 第一节：目录结构规范 |
| **Rule 规则层** | 导入规范、命名规范、错误处理规范、日志规范 | 第二~五节 |
| **Execution 执行层** | 强制检查清单 | 第六节：强制检查清单 |

**三层架构是分形结构**：在项目规则层面，Structure = 目录/模块，Rule = 命名/导入/错误处理，Execution = 检查清单。

---

## 一、目录结构规范

### 1.1 标准目录结构

```
project/
├── src/                          # 源代码
│   ├── __init__.py
│   ├── main.py                   # 入口文件
│   ├── config/                   # 配置
│   │   ├── __init__.py
│   │   └── settings.py
│   ├── models/                   # 数据模型
│   │   ├── __init__.py
│   │   └── *.py
│   ├── views/                    # 视图 (Qt)
│   │   ├── __init__.py
│   │   └── *.py
│   ├── viewmodels/               # 视图模型
│   │   ├── __init__.py
│   │   └── *.py
│   ├── services/                 # 服务层
│   │   ├── __init__.py
│   │   └── *.py
│   └── utils/                    # 工具
│       ├── __init__.py
│       └── *.py
├── tests/                        # 测试
│   ├── modules/
│   │   ├── model/
│   │   ├── api/
│   │   ├── viewmodel/
│   │   └── view/
│   └── integration/
├── docs/                         # 文档
├── venv/                         # 虚拟环境
├── pyproject.toml                # 项目配置
└── README.md                     # 项目说明
```

### 1.2 模块命名规范

| 模块 | 命名规则 | 示例 |
|------|----------|------|
| Python 包 | 小写+下划线 | `viewmodels`, `api_services` |
| 类 | 大驼峰 | `UserManager`, `Home3DView` |
| 函数/变量 | 小写+下划线 | `fetch_user`, `user_list` |
| 常量 | 全大写+下划线 | `MAX_RETRY`, `API_TIMEOUT` |
| 私有属性 | 单下划线前缀 | `_private_attr` |

---

## 二、导入规范

### 2.1 导入顺序

```python
# 1. 标准库
import os
import sys
from pathlib import Path
from typing import Optional

# 2. 第三方库
import PySide6
from PySide6.QtWidgets import QApplication

# 3. 本地模块（相对导入）
from .config import settings
from ..models import User

# 禁止使用
# import *  # 禁止
# from .config import *  # 禁止
```

### 2.2 模块导入规则

```python
# ✅ 推荐：显式导入
from src.utils.event_bus import EventBus

# ✅ 推荐：类型注解导入
from typing import List, Dict, Optional

# ❌ 禁止：循环导入
# module_a.py 导入 module_b
# module_b.py 导入 module_a
```

---

## 三、命名规范

### 3.1 元素类型命名

**核心原则**：分类列表统一使用 `_list` 后缀

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 分类列表节点 | 单数 + `_list` | `device_list`, `furniture_list` |
| 具体元素节点 | 单数形式 | `device`, `furniture` |
| 容器节点 | 单数形式 | `home`, `floor`, `room` |

### 3.2 命名检查清单

- [ ] 变量/函数使用小写+下划线
- [ ] 类使用大驼峰
- [ ] 常量使用全大写+下划线
- [ ] 分类列表使用 `_list` 后缀
- [ ] 私有属性使用 `_` 前缀

---

## 四、错误处理规范

### 4.1 错误码定义

```python
# errors.py
class ErrorCode:
    SUCCESS = 200
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    NOT_FOUND = 404
    INTERNAL_ERROR = 500
    SERVICE_UNAVAILABLE = 503
    TIMEOUT = 504
```

### 4.2 异常处理

```python
# ✅ 推荐：明确异常类型
try:
    result = fetch_data()
except ValueError as e:
    logger.error(f"数据格式错误: {e}")
    raise

# ✅ 推荐：资源清理
try:
    with open("data.json", "r") as f:
        return json.load(f)
finally:
    pass  # with 自动处理

# ❌ 禁止：裸露 except
try:
    risky_operation()
except:  # 捕获所有异常，包括 KeyboardInterrupt
    pass
```

---

## 五、日志规范

### 5.1 日志级别

| 级别 | 使用场景 |
|------|----------|
| DEBUG | 开发调试信息 |
| INFO | 正常流程信息 |
| WARNING | 警告但可继续 |
| ERROR | 错误需要处理 |
| CRITICAL | 严重错误程序终止 |

### 5.2 日志格式

```python
import logging

logging.basicConfig(
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    level=logging.INFO
)

logger = logging.getLogger(__name__)

# ✅ 推荐：带上下文的日志
logger.info(f"用户登录: user_id={user_id}, ip={ip}")

# ❌ 禁止：日志中包含敏感信息
logger.info(f"密码修改: user_id={user_id}, password={password}")
```

---

## 六、强制检查清单

- [ ] 目录结构符合标准
- [ ] 导入顺序正确（标准库 → 第三方 → 本地）
- [ ] 命名符合规范（类/函数/常量）
- [ ] 分类列表使用 `_list` 后缀
- [ ] 错误码定义完整
- [ ] 日志级别使用正确

---

*LSH ID: project_foundation-20260511_080001-a1b2c3*
