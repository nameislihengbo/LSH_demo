# Zenodo 沙箱测试指南

**版本**: v1.0
**日期**: 2026-05-12

---

## 一、沙箱环境说明

### 1.1 Zenodo 沙箱 vs 生产环境

| 环境 | URL | 用途 | 数据持久性 |
|------|-----|------|-----------|
| **沙箱** | https://sandbox.zenodo.org | 测试发布流程 | 定期清理 |
| **生产** | https://zenodo.org | 正式发布 | 永久保存 |

### 1.2 沙箱特点

- ✅ 完全模拟生产环境 API
- ✅ 独立的 OAuth Token
- ✅ 测试数据不影响正式记录
- ⚠️ 数据可能被定期清理
- ⚠️ 生成的 DOI 不可用于正式引用

---

## 二、沙箱测试流程

### 2.1 准备工作

#### Step 1: 创建沙箱账户

1. 访问 https://sandbox.zenodo.org
2. 使用 GitHub 账户登录（或注册新账户）

#### Step 2: 获取沙箱 API Token

1. 登录沙箱后，访问 https://sandbox.zenodo.org/account/settings/applications/
2. 点击 **"New token"**
3. 填写信息：
   - Name: `LSH Release Test`
   - Scopes: 勾选 `deposit:actions`, `deposit:write`
4. 复制生成的 Token（只显示一次）

#### Step 3: 配置 GitHub Secrets

在 GitHub 仓库设置中添加：

```
Settings → Secrets and variables → Actions → New repository secret
```

| Secret Name | Value |
|-------------|-------|
| `ZENODO_SANDBOX_TOKEN` | 你的沙箱 API Token |

---

### 2.2 本地测试

#### 方式一：PowerShell 脚本

```powershell
# 设置环境变量
$env:ZENODO_SANDBOX_TOKEN = "your-sandbox-token"

# 安装依赖
pip install requests

# 准备 Paper 1 的元数据
python scripts/prepare_zenodo_release.py --paper 1 --sandbox

# 创建沙箱 deposition
python scripts/create_zenodo_deposition.py --sandbox --metadata .zenodo.json --paper-dir structures/paper/architecture/architecture_lsh_sfa-20260511_130001-a3f8c2
```

#### 方式二：手动 API 测试

```powershell
# 使用 curl 测试 API
$TOKEN = "your-sandbox-token"
$URL = "https://sandbox.zenodo.org/api/deposit/depositions"

# 创建空 deposition
curl -X POST "$URL?access_token=$TOKEN" -H "Content-Type: application/json" -d "{}"
```

---

### 2.3 GitHub Actions 测试

#### 触发方式一：手动触发

1. 访问 GitHub Actions 页面
2. 选择 **"Zenodo Sandbox Release Test"** 工作流
3. 点击 **"Run workflow"**
4. 输入参数：
   - Paper number: `1`
   - Version: `1.0`
5. 查看运行结果

#### 触发方式二：Tag 触发

```powershell
# 创建沙箱测试 tag
git tag v1.0-paper1-sandbox
git push origin v1.0-paper1-sandbox
```

---

## 三、测试检查清单

### 3.1 元数据验证

- [ ] `.zenodo.json` 格式正确
- [ ] `title` 包含 `[SANDBOX TEST]` 前缀
- [ ] `creators` 包含 ORCID
- [ ] `keywords` 数量合理（5-20个）
- [ ] `license` 设置为 `CC-BY-4.0`

### 3.2 文件上传验证

- [ ] `main.tex` 上传成功
- [ ] 文件大小合理（< 50MB）
- [ ] 文件名正确

### 3.3 API 响应验证

- [ ] HTTP 状态码 201（创建成功）
- [ ] 返回有效的 `deposition_id`
- [ ] 返回有效的 `doi`（沙箱 DOI 格式）

---

## 四、常见问题

### Q1: Token 无效

**错误**: `401 Unauthorized`

**解决**:
1. 确认使用的是沙箱 Token（不是生产 Token）
2. 确认 Token 权限包含 `deposit:actions` 和 `deposit:write`
3. 重新生成 Token

### Q2: Deposition 创建失败

**错误**: `400 Bad Request`

**解决**:
1. 检查 `.zenodo.json` 格式
2. 确认必填字段完整
3. 检查 JSON 编码（UTF-8）

### Q3: 文件上传失败

**错误**: `413 Payload Too Large`

**解决**:
1. 单文件限制 50GB
2. 检查文件路径是否正确

---

## 五、沙箱测试完成后

### 5.1 清理测试数据

沙箱数据会定期自动清理，无需手动删除。

### 5.2 准备正式发布

1. 移除 `[SANDBOX TEST]` 前缀
2. 使用生产环境 Token
3. 创建正式 tag（如 `v1.0-paper1`）

---

## 六、API 参考

### 6.1 沙箱 API 端点

| 操作 | 端点 | 方法 |
|------|------|------|
| 创建 Deposition | `/api/deposit/depositions` | POST |
| 上传文件 | `/api/deposit/depositions/{id}/files` | POST |
| 发布 | `/api/deposit/depositions/{id}/actions/publish` | POST |
| 获取详情 | `/api/deposit/depositions/{id}` | GET |

### 6.2 Python 示例

```python
import requests

ZENODO_SANDBOX_URL = "https://sandbox.zenodo.org"
TOKEN = "your-sandbox-token"

# 创建 deposition
response = requests.post(
    f"{ZENODO_SANDBOX_URL}/api/deposit/depositions",
    params={"access_token": TOKEN},
    headers={"Content-Type": "application/json"},
    json={"metadata": {"title": "Test Paper"}}
)

deposition = response.json()
print(f"Deposition ID: {deposition['id']}")
print(f"DOI: {deposition['doi']}")
```

---

## 七、自动化脚本

### 7.1 批量测试脚本

```powershell
# scripts/test-all-papers-sandbox.ps1
param([string]$Token)

$env:ZENODO_SANDBOX_TOKEN = $Token

for ($i = 1; $i -le 10; $i++) {
    Write-Host "Testing Paper $i..." -ForegroundColor Green
    
    python scripts/prepare_zenodo_release.py --paper $i --sandbox
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to prepare Paper $i" -ForegroundColor Red
        continue
    }
    
    Write-Host "Paper $i metadata prepared successfully" -ForegroundColor Green
}

Write-Host "`nAll papers tested!" -ForegroundColor Cyan
```

---

*文档版本: v1.0 | 更新日期: 2026-05-12*
