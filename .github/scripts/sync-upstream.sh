#!/bin/bash

set -e

echo "Starting upstream sync..."

# 配置git用户信息
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

# 添加上游仓库（如果不存在）
if ! git remote | grep -q upstream; then
    echo "Adding upstream remote..."
    git remote add upstream https://github.com/bytedance/deer-flow.git
fi

# 获取上游最新代码
echo "Fetching upstream changes..."
git fetch upstream

# 检查是否有上游更新
UPSTREAM_COMMIT=$(git rev-parse upstream/main)
CURRENT_COMMIT=$(git rev-parse HEAD)

if [ "$UPSTREAM_COMMIT" = "$CURRENT_COMMIT" ]; then
    echo "Already up to date with upstream. No changes to merge."
    exit 0
fi

echo "Upstream has new commits. Merging changes..."

# 合并上游代码
git merge --no-ff --no-commit upstream/main || {
    echo "Merge conflict detected. Attempting to resolve..."
    # 如果有冲突，尝试使用ours策略
    git merge --abort
    git merge -X ours --no-ff --no-commit upstream/main || {
        echo "Failed to merge with ours strategy. Exiting."
        exit 1
    }
}

# 提交合并
git commit -m "chore: sync upstream changes from bytedance/deer-flow

Automated sync from upstream repository:
- Upstream commit: $UPSTREAM_COMMIT
- Sync time: $(date -u +'%Y-%m-%d %H:%M:%S UTC')"

# 推送到origin
echo "Pushing changes to origin..."
git push origin main

echo "Upstream sync completed successfully!"