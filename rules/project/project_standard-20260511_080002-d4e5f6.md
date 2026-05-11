# Project Standard Rules

**LSH ID**: project_standard-20260511_080002-d4e5f6
**cat**: project | **tags**: standard | **level**: standard | **version**: 1.0
**引用**: architecture_three_layer-20260511_130002-b7d2e1 | systems_execution_layer-20260511_140001-g8i7j6

---

## 零、本规则的三层架构 / Three-Layer Structure of This Rule

本规则本身是三层架构的体现：

| 层级 | 内容 | 对应章节 |
|------|------|----------|
| **Structure 结构层** | MVVM 分层定义 | 第一节：MVVM 架构规范 |
| **Rule 规则层** | MVVM 规则、模块通信规范、配置管理规范 | 第二~四节 |
| **Execution 执行层** | 标准检查清单 | 第五节：标准检查清单 |

**MVVM 是三层架构的实现**：View=展示层、ViewModel=逻辑层、Model=数据层，与 Structure·Rule·Execution 相互映射。

---

## 一、MVVM 架构规范

### 1.1 MVVM 分层

```
┌─────────────────────────────────────────────────────────────┐
│                         View (视图层)                        │
│  - PySide6 组件                                            │
│  - 不感知 Model                                            │
│  - 只操作 ViewModel 暴露的接口                             │
└─────────────────────────────────────────────────────────────┘
                            ↕ 双向绑定
┌─────────────────────────────────────────────────────────────┐
│                     ViewModel (视图模型层)                   │
│  - 继承 QObject                                            │
│  - 使用 Qt Signal/Slot                                     │
│  - 不持有 View 引用                                         │
│  - 通过 EventBus 通信                                       │
└─────────────────────────────────────────────────────────────┘
                            ↕
┌─────────────────────────────────────────────────────────────┐
│                       Model (数据模型层)                     │
│  - 纯 Python 数据类                                        │
│  - 不导入渲染库 (vtk, godot, three.js)                     │
│  - 使用 EventBus 发布事件                                   │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 MVVM 规则

| 规则 | 说明 | 违反后果 |
|------|------|----------|
| View 不感知 Model | View 只调用 ViewModel | 耦合混乱 |
| ViewModel 不持有 View | 通过 Signal 通信 | 循环引用 |
| Model 不导入渲染库 | 保持纯净 | 架构污染 |
| 单向数据流 | Model → ViewModel → View | 数据不一致 |

---

## 二、模块通信规范

### 2.1 EventBus 通信

```python
# event_bus.py
from typing import Callable, Dict, List
from dataclasses import dataclass
from enum import Enum

class EventType(Enum):
    DEVICE_ADDED = "device_added"
    DEVICE_REMOVED = "device_removed"
    FLOOR_CHANGED = "floor_changed"

@dataclass
class Event:
    type: EventType
    data: dict
    source: str

class EventBus:
    _instance = None

    def __init__(self):
        self._subscribers: Dict[EventType, List[Callable]] = {}

    @classmethod
    def get_instance(cls) -> "EventBus":
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def subscribe(self, event_type: EventType, callback: Callable) -> None:
        if event_type not in self._subscribers:
            self._subscribers[event_type] = []
        self._subscribers[event_type].append(callback)

    def publish(self, event: Event) -> None:
        for callback in self._subscribers.get(event.type, []):
            callback(event)
```

### 2.2 RESTful API 格式

```python
# 响应格式
{
    "code": 200,           # 状态码
    "data": Any,           # 数据
    "msg": "success"       # 消息
}

# 错误响应
{
    "code": 400,
    "data": None,
    "msg": "参数错误:缺少必需字段 name"
}
```

---

## 三、配置管理规范

### 3.1 配置文件

| 配置文件 | 用途 |
|----------|------|
| `paths.json` | 路径配置 |
| `api_keys.json` | API 密钥 |
| `state.json` | 应用状态 |
| `theme.json5` | 主题配置 |
| `extensions.json` | 扩展配置 |

### 3.2 配置读取

```python
# config_loader.py
import json
from pathlib import Path
from typing import Any

class ConfigLoader:
    def __init__(self, config_dir: Path):
        self.config_dir = config_dir

    def load(self, name: str) -> dict[str, Any]:
        path = self.config_dir / f"{name}.json"
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)

    def save(self, name: str, data: dict) -> None:
        path = self.config_dir / f"{name}.json"
        with open(path, "w", encoding="utf-8") as f:
            json.dump(data, f, indent=2, ensure_ascii=False)
```

---

## 四、日志追踪规范

### 4.1 Trace ID 格式

```
{业务标识}_{时间戳}_{随机串}
示例: device_20260511_143052_a3f8c2
```

### 4.2 Trace ID 使用

```python
import uuid
from datetime import datetime

def generate_trace_id(business: str) -> str:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    random_str = uuid.uuid4().hex[:6]
    return f"{business}_{timestamp}_{random_str}"

# 使用示例
trace_id = generate_trace_id("device")
logger.info(f"[{trace_id}] 设备查询开始", extra={"trace_id": trace_id})
```

---

## 五、交互反馈规范

### 5.1 反馈方式

| 场景 | 反馈方式 | 说明 |
|------|----------|------|
| 操作成功 | Toast (0.5s 自动关闭) | 不打断用户 |
| 操作失败 | 错误对话框 | 显示真实错误 |
| 进行中 | 进度条/加载动画 | 耗时操作必须 |

### 5.2 实现示例

```python
# 成功提示
def show_success(message: str):
    toast = Toast(message, duration=500)
    toast.show()

# 错误提示
def show_error(message: str, details: str = None):
    dialog = ErrorDialog(message, details)
    dialog.exec()
```

---

## 六、标准检查清单

- [ ] MVVM 分层正确
- [ ] 模块间使用 EventBus
- [ ] API 响应格式统一
- [ ] 配置文件集中管理
- [ ] 日志包含 Trace ID
- [ ] 用户反馈及时

---

*LSH ID: project_standard-20260511_080002-d4e5f6*
