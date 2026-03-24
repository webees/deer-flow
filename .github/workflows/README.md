# DeerFlow GitHub Actions Workflows

本项目包含以下 GitHub Actions workflows：

## 1. package.yml - 源代码打包
**功能**：将 DeerFlow 源代码打包为 tar.gz 和 zip 格式

**触发条件**：
- 推送版本标签（v*）
- 手动触发（workflow_dispatch）

**输出**：
- `deer-flow-{版本}.tar.gz`
- `deer-flow-{版本}.zip`

**使用方法**：
```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0

# 或手动触发
# 在 GitHub Actions 页面点击 "Run workflow"
```

## 2. docker.yml - Docker 镜像构建
**功能**：构建并推送 Docker 镜像到 GitHub Container Registry

**触发条件**：
- 推送到 main 分支
- 推送版本标签（v*）
- 手动触发（workflow_dispatch）
- 每周一自动构建（UTC 4:00）

**输出**：
- `ghcr.io/{owner}/deer-flow-backend:latest`
- `ghcr.io/{owner}/deer-flow-backend:{tag}`
- `ghcr.io/{owner}/deer-flow-frontend:latest`
- `ghcr.io/{owner}/deer-flow-frontend:{tag}`

**镜像标签**：
- `latest` - 最新版本
- `{tag}` - Git 标签版本
- `{commit-sha}` - 提交哈希
- `{date}` - 构建日期（YYYYMMDD）

## 3. backend-unit-tests.yml - 后端单元测试
**功能**：运行后端单元测试

## 4. lint-check.yml - 代码检查
**功能**：运行代码格式检查和类型检查

## 快速开始

### 发布新版本
1. 创建版本标签：
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. GitHub Actions 会自动：
   - 运行测试和代码检查
   - 构建 Docker 镜像并推送到 GHCR
   - 打包源代码并创建 GitHub Release

### 手动打包
1. 访问 GitHub Actions 页面
2. 选择 "Package DeerFlow" workflow
3. 点击 "Run workflow"
4. 选择是否创建 GitHub Release

### 本地测试
```bash
# 模拟打包
tar czf deer-flow-test.tar.gz --exclude=.git --exclude=node_modules --exclude=__pycache__ --exclude=.next .

# 查看内容
tar -tzf deer-flow-test.tar.gz | head -20
```

## 配置说明

### 环境变量
- `GITHUB_TOKEN`：自动提供，用于 GitHub API 认证
- `REGISTRY`：Docker 镜像仓库（默认为 ghcr.io）

### 缓存优化
- Docker 构建使用 GitHub Actions 缓存
- 支持多架构构建（amd64, arm64）
- 增量构建加速

## 故障排除

### 常见问题
1. **Docker 构建失败**：检查 Dockerfile 语法和依赖
2. **打包文件过大**：检查排除规则是否完整
3. **认证失败**：确保 GitHub Token 有足够权限

### 日志查看
1. 在 GitHub Actions 页面查看 workflow 运行详情
2. 下载 artifacts 查看打包结果
3. 检查 Docker 镜像是否成功推送到 GHCR

## 扩展建议

如需添加更多打包格式或部署目标，可修改：
1. `package.yml` - 添加新的打包格式
2. `docker.yml` - 添加新的镜像标签或架构
3. 创建新的 workflow 文件处理特定需求