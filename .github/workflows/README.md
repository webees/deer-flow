# DeerFlow GitHub Actions Workflows

本项目包含以下 GitHub Actions workflows：

## 1. package.yml - Docker 镜像构建
**功能**：构建并推送 DeerFlow 的 Docker 镜像到 GitHub Container Registry

**触发条件**：
- 推送到 main 分支
- 推送版本标签（v*）
- 手动触发（workflow_dispatch）

**输出镜像**：
- `ghcr.io/{owner}/deer-flow-backend:latest`
- `ghcr.io/{owner}/deer-flow-backend:{版本}`
- `ghcr.io/{owner}/deer-flow-frontend:latest`
- `ghcr.io/{owner}/deer-flow-frontend:{版本}`

**版本生成规则**：
- 标签版本：`v1.0.0` → 镜像标签 `v1.0.0`
- 日期版本：`20250324-abc123`（无标签时，日期+提交哈希）

## 2. backend-unit-tests.yml - 后端单元测试
**功能**：运行后端单元测试

## 3. lint-check.yml - 代码检查
**功能**：运行代码格式检查和类型检查

## 4. sync-upstream.yml - 上游代码同步
**功能**：每小时自动同步上游 bytedance/deer-flow 仓库的代码到当前仓库

**触发条件**：
- 每小时自动运行（cron: '0 * * * *'）
- 手动触发（workflow_dispatch）

**同步策略**：
1. 检查上游仓库是否有新提交
2. 如果有新提交，自动合并到当前仓库
3. 如果出现合并冲突，使用 ours 策略解决
4. 创建包含上游提交信息的合并提交
5. 自动推送到当前仓库的 main 分支

**注意事项**：
- 需要仓库有 `contents: write` 权限
- 使用 GitHub Actions bot 身份进行提交
- 每小时最多同步一次，避免频繁请求

## 快速开始

### 自动构建 Docker 镜像
```bash
# 1. 创建版本标签（推荐）
git tag v1.0.0
git push origin v1.0.0

# 或直接推送到 main 分支
git push origin main

# 2. GitHub Actions 会自动：
#    - 构建多架构 Docker 镜像（amd64, arm64）
#    - 推送到 GitHub Container Registry
```

### 手动触发构建
1. 访问 GitHub Actions 页面
2. 选择 "Build DeerFlow Docker Images" workflow
3. 点击 "Run workflow"

### 使用构建的镜像
```bash
# 拉取最新镜像
docker pull ghcr.io/{owner}/deer-flow-backend:latest
docker pull ghcr.io/{owner}/deer-flow-frontend:latest

# 或使用特定版本
docker pull ghcr.io/{owner}/deer-flow-backend:v1.0.0
```

## 配置说明

### 环境变量
- `GITHUB_TOKEN`: 自动提供，用于容器注册表认证
- `REGISTRY`: Docker 镜像仓库（默认为 ghcr.io）
- `IMAGE_NAME_BACKEND`: 后端镜像名称（默认为 deer-flow-backend）
- `IMAGE_NAME_FRONTEND`: 前端镜像名称（默认为 deer-flow-frontend）

### 技术特性
- **多架构支持**: `linux/amd64`, `linux/arm64`
- **版本管理**: 自动生成镜像标签
- **高效构建**: 使用 Docker Buildx 进行并行构建
- **简单可靠**: 专注于 Docker 镜像构建，无额外复杂逻辑

## 故障排除

### 常见问题
1. **Docker 构建失败**
   - 检查 Dockerfile 语法
   - 确认依赖项完整
   - 查看构建日志中的具体错误

2. **认证失败**
   - 确保 GitHub Token 有 `packages:write` 权限
   - 检查网络连接
   - 验证容器注册表地址

### 日志查看
1. 在 GitHub Actions 页面查看 workflow 运行详情
2. 在 GitHub Container Registry 查看推送的镜像
3. 检查构建步骤的输出日志

## 扩展建议

如需扩展功能，可修改 `package.yml`：
1. 添加更多架构支持
2. 添加镜像扫描或安全检查
3. 添加部署到其他容器注册表
4. 添加构建缓存优化