# 🛰️ Sunny-research — Sunny's Daily Knowledge Broadcast

> 每日沉淀 + 多领域分享。Hexo 对外博文 + Zola 个人知识库 + 每日 9:00 cron 自动部署。

## 📂 目录结构

```
Sunny-research/
├── hexo-blog/          # 对外博文（Fluid 主题，中文友好）
│   ├── source/_posts/  # Markdown 文章
│   ├── public/         # 生成的静态文件
│   └── _config.yml
├── zola-kb/            # 个人知识库（轻量 0.22 主题）
│   ├── content/        # 笔记
│   ├── templates/      # Tera 模板
│   └── public/         # 生成的静态文件
├── daily/              # 每日分享草稿区
│   ├── YYYY-MM-DD.md   # 每日自动创建
│   └── cron.log        # 部署日志
├── deploy.sh           # 一键部署脚本
└── README.md
```

## 🛠️ 常用命令

```bash
# 一键全量部署（hexo + zola + git push + 飞书通知）
./deploy.sh all

# 仅重建 hexo
./deploy.sh hexo

# 本地预览
hexo-blog/.npm-global/bin/hexo server --port 4000
zola-kb/zola serve --port 1111

# 手动跑每日 cron（不等 9:00）
daily/cron-daily.sh
```

## ⏰ 自动化

- **每日 9:00**：`daily/cron-daily.sh` 自动运行
  1. 创建当日空模板 `daily/{YYYY-MM-DD}.md`
  2. 重建 hexo + zola
  3. `git commit && git push`
  4. 飞书通知已部署

## 🔗 SunnyWiki 软链接

```bash
~/Library/CloudStorage/.../SunnyWiki/Sunny-research → /Users/lijiangbo/2_Areas/Sunny-research
```

在 Obsidian 里直接访问 Sunny-research 全部内容（不修改原文件）。

## 📡 GitHub

仓库：https://github.com/jiangbo19860/Sunny-research
