#!/bin/bash
# 飞书文件发送包装脚本 - 自动读取配置

# 从 OpenClaw 配置自动获取凭证
OPENCLAW_CONFIG="/root/.openclaw/openclaw.json.bak"
if [ -f "$OPENCLAW_CONFIG" ]; then
    export FEISHU_APP_ID=$(grep -o '"appId": *"[^"]*"' "$OPENCLAW_CONFIG" | head -1 | cut -d'"' -f4)
    export FEISHU_APP_SECRET=$(grep -o '"appSecret": *"[^"]*"' "$OPENCLAW_CONFIG" | head -1 | cut -d'"' -f4)
fi

# 调用主脚本
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/send-file.sh" "$@"
