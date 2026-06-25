#!/bin/bash
# Outpost 每日分享 cron 脚本
# 9:00 跑：hexo + zola 重建 → git push → 飞书通知
export PATH=/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH

OUTPOST="/Users/lijiangbo/2_Areas/outpost"
LOG="$OUTPOST/daily/cron.log"
DATE=$(date "+%Y-%m-%d")

# 写入当日时间戳
echo "[$DATE] Cron 启动" >> "$LOG"

# 1. 检查 daily/ 今天有没有新内容
TODAY_NOTE="$OUTPOST/daily/${DATE}.md"
if [ ! -f "$TODAY_NOTE" ]; then
  cat > "$TODAY_NOTE" << HEADER
# $DATE — 今日分享

> 自动生成。每天 9:00 cron 触发时如果没有当日的笔记，会自动创建空模板。

## 今日要点
-

## 计划分享内容
-

HEADER
  echo "[$DATE] 已创建当日模板: $TODAY_NOTE" >> "$LOG"
fi

# 2. 部署
$OUTPOST/deploy.sh all >> "$LOG" 2>&1

# 3. 飞书通知（如果 lark-cli 存在）
if command -v lark-cli >/dev/null 2>&1; then
  lark-cli im send --chat "oc_c89ebe994215a6874722815423efc2e1" --text "📡 Outpost 每日分享已推送 $(date '+%H:%M')。GitHub: https://github.com/jiangbo19860/outpost" 2>>"$LOG" || echo "lark-cli 通知失败（不影响主流程）" >> "$LOG"
fi

echo "[$DATE] Cron 完成" >> "$LOG"
