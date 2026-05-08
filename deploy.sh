#!/bin/bash

# 使用方式: ./deploy.sh 新檔案路徑
# 例如: ./deploy.sh ~/Downloads/learning_dashboard_v8.html

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
HISTORY_DIR="$REPO_DIR/history"
NEW_FILE="$1"

# 確認有傳入新檔案
if [ -z "$NEW_FILE" ]; then
  echo "❌ 請指定新的 HTML 檔案路徑"
  echo "用法: ./deploy.sh ~/Downloads/learning_dashboard_v8.html"
  exit 1
fi

if [ ! -f "$NEW_FILE" ]; then
  echo "❌ 找不到檔案: $NEW_FILE"
  exit 1
fi

# 建立 history 資料夾
mkdir -p "$HISTORY_DIR"

# 備份現有 index.html（如果存在）
if [ -f "$REPO_DIR/index.html" ]; then
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  BACKUP_NAME="index_$TIMESTAMP.html"
  cp "$REPO_DIR/index.html" "$HISTORY_DIR/$BACKUP_NAME"
  echo "✅ 已備份舊版本到 history/$BACKUP_NAME"
fi

# 複製新檔案為 index.html
cp "$NEW_FILE" "$REPO_DIR/index.html"
echo "✅ 已更新 index.html"

# Git push
cd "$REPO_DIR"
git add .
git commit -m "update $(date +"%Y-%m-%d %H:%M")"
git push

echo "🚀 部署完成！"
