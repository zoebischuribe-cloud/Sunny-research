#!/bin/bash
# Outpost 一键部署脚本
# 用法: ./deploy.sh [hexo|zola|all]
# 默认: all

set -e
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH

OUTPOST="/Users/lijiangbo/2_Areas/outpost"
HEXO="/Users/lijiangbo/.npm-global/bin/hexo"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

echo "🚀 [$TIMESTAMP] Outpost 部署开始"
echo "=================================="

deploy_hexo() {
  echo ""
  echo "📝 [1/4] Hexo 部署..."
  cd "$OUTPOST/hexo-blog"
  "$HEXO" clean >/dev/null 2>&1
  "$HEXO" generate 2>&1 | grep -E "(generated|error)" | tail -2
  cp -r public/* "$OUTPOST/hexo-blog/" 2>/dev/null || true
}

deploy_zola() {
  echo ""
  echo "📚 [2/4] Zola 部署..."
  cd "$OUTPOST/zola-kb"
  zola build 2>&1 | tail -2
}

git_push() {
  echo ""
  echo "🔄 [3/4] Git 提交推送..."
  cd "$OUTPOST"
  if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Daily deploy: $TIMESTAMP" 2>&1 | tail -1
    git push origin main 2>&1 | tail -1
  else
    echo "   无变更，跳过"
  fi
}

build_pages() {
  # GitHub Pages 部署（可选：把 hexo public/ 推送到 gh-pages 分支）
  echo ""
  echo "🌐 [4/4] GitHub Pages 部署（可选）..."
  cd "$OUTPOST/hexo-blog"
  if [ -f "_config.yml" ] && grep -q "deploy:" _config.yml; then
    "$HEXO" deploy 2>&1 | tail -2 || echo "   hexo deploy 未配置或失败，跳过"
  else
    echo "   hexo deploy 未配置（需要在 _config.yml 设置 repo），跳过"
  fi
}

case "${1:-all}" in
  hexo) deploy_hexo ;;
  zola) deploy_zola ;;
  all)  deploy_hexo; deploy_zola; git_push; build_pages ;;
  *)    echo "用法: $0 [hexo|zola|all]"; exit 1 ;;
esac

echo ""
echo "✅ 部署完成: $TIMESTAMP"
