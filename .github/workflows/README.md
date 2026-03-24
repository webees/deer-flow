# DeerFlow GitHub Actions Workflows

本项目包含以下 GitHub Actions workflows：

## 1. package.yml - 统一打包 workflow
**功能**：统一处理 DeerFlow 的源代码打包和 Docker 镜像构建

**触发条件**：
- 推送到 main 分支
- 推送版本标签（v*）
- 手动触发（workflow_dispatch）

**手动触发选项**：
- `package_type`: 打包类型（all/source/docker）
- `create_release`: 是否创建 GitHub Release

**输出**：
1. **源代码包**：
   - `deer-flow-{版本}.tar.gz`
   - `deer-flow-{版本}.zip`

2. **Docker 镜像**：
   - `ghcr.io/{owner}/deer-flow-backend:latest`
   - `ghcr.io/{owner}/deer-flow-backend:{版本}`
   - `ghcr.io/{owner}/deer-flow-frontend:latest`
   - `ghcr.io/{owner}/deer-flow-frontend:{版本}`

**版本生成规则**：
- 标签版本：`v1.0.0` → `deer-flow-v1.0.0.tar.gz`
- 日期版本：`deer-flow-20250324-abc123.tar.gz`（无标签时）

## 2. backend-unit-tests.yml - 后端单元测试
**功能**：运行后端单元测试

## 3. lint-check.yml - 代码检查
**功能**：运行代码格式检查和类型检查

## 快速开始

### 发布新版本（全自动）
```bash
# 1. 创建版本标签
git tag v1.0.0
git push origin v1.0.0

# 2. GitHub Actions 会自动：
#    - 打包源代码（tar.gz/zip）
#    - 构建 Docker 镜像（多架构）
#    - 推送到 GitHub Container Registry
#    - 创建 GitHub Release（可选）
```

### 手动打包（灵活控制）
1. 访问 GitHub Actions 页面
2. 选择 "Package DeerFlow" workflow
3. 点击 "Run workflow"
4. 选择打包类型：
   - `all`: 源代码 + Docker 镜像
   - `source`: 仅源代码
   - `docker`: 仅 Docker 镜像
5. 选择是否创建 GitHub Release

### 本地测试
```bash
# 模拟源代码打包
tar czf deer-flow-test.tar.gz \
  --exclude=.git \
  --exclude=.github \
  --exclude=node_modules \
  --exclude=__pycache__ \
  --exclude=.next \
  --exclude=.deer-flow \
  .

# 查看打包内容
tar -tzf deer-flow-test.tar.gz | head -20
```

## 配置说明

### 环境变量
- `GITHUB_TOKEN`: 自动提供，用于 GitHub API 和容器注册表认证
- `REGISTRY`: Docker 镜像仓库（默认为 ghcr.io）
- `IMAGE_NAME_BACKEND`: 后端镜像名称（默认为 deer-flow-backend）
- `IMAGE_NAME_FRONTEND`: 前端镜像名称（默认为 deer-flow-frontend）

### 技术特性
- **多架构支持**: `linux/amd64`, `linux/arm64`
- **智能排除**: 自动排除开发环境和缓存文件
- **版本管理**: 支持标签版本和日期版本
- **灵活触发**: 支持自动触发和手动控制

## 故障排除

### 常见问题
1. **Docker 构建失败**
   - 检查 Dockerfile 语法
   - 确认依赖项完整
   - 查看构建日志中的具体错误

2. **打包文件过大**
   - 检查排除规则是否生效
   - 确认没有包含不必要的文件
   - 使用 `tar -tzf` 查看包内容

3. **认证失败**
   - 确保 GitHub Token 有 `packages:write` 权限
   - 检查网络连接
   - 验证容器注册表地址

### 日志查看
1. 在 GitHub Actions 页面查看 workflow 运行详情
2. 下载 artifacts 查看打包结果
3. 在 GitHub Container Registry 查看推送的镜像

## 扩展建议

如需扩展功能，可修改 `package.yml`：
1. 添加新的打包格式（如 `.deb`, `.rpm`）
2. 支持更多 Docker 镜像标签策略
3. 添加部署到其他容器注册表
4. 集成测试和验证步骤