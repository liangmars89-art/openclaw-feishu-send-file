#!/bin/bash
# 飞书文件发送工具 (纯 bash + curl 实现)

set -e

# ========== 配置 ==========
# 从环境变量或配置文件读取
APP_ID="${FEISHU_APP_ID}"
APP_SECRET="${FEISHU_APP_SECRET}"
RECEIVE_ID="${1:-ou_0765c32b5ec622535c5ccc284982cfe5}"
FILE_PATH="${2}"

# 从 OpenClaw 配置读取
if [ -z "$APP_ID" ] || [ -z "$APP_SECRET" ]; then
    echo "🔍 从 OpenClaw 配置读取飞书凭证..."
    CONFIG_FILE="/root/.openclaw/config.yml"
    if [ -f "$CONFIG_FILE" ]; then
        APP_ID=$(grep -A 5 "appId:" "$CONFIG_FILE" | grep "appId:" | head -1 | awk '{print $2}' | tr -d '"')
        APP_SECRET=$(grep -A 5 "appSecret:" "$CONFIG_FILE" | grep "appSecret:" | head -1 | awk '{print $2}' | tr -d '"')
    fi
fi

if [ -z "$APP_ID" ] || [ -z "$APP_SECRET" ] || [ -z "$FILE_PATH" ]; then
    echo "用法: $0 <接收者open_id> <文件路径>"
    echo "示例: $0 ou_xxx /path/to/file.pdf"
    echo ""
    echo "或设置环境变量:"
    echo "  export FEISHU_APP_ID=your_app_id"
    echo "  export FEISHU_APP_SECRET=your_app_secret"
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "❌ 文件不存在: $FILE_PATH"
    exit 1
fi

echo "📦 飞书文件发送工具"
echo "─────────────────────"
echo "文件: $(basename "$FILE_PATH")"
echo "接收者: $RECEIVE_ID"
echo ""

# Step 1: 获取 tenant_access_token
echo "🔑 获取访问令牌..."
TOKEN_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/auth/v3/tenant_access_token/internal" \
    -H "Content-Type: application/json" \
    -d "{\"app_id\":\"$APP_ID\",\"app_secret\":\"$APP_SECRET\"}")

TOKEN=$(echo "$TOKEN_RESPONSE" | grep -o '"tenant_access_token":"[^"]*' | cut -d'"' -f4)
CODE=$(echo "$TOKEN_RESPONSE" | grep -o '"code":[0-9]*' | cut -d':' -f2)

if [ "$CODE" != "0" ] || [ -z "$TOKEN" ]; then
    echo "❌ 获取 token 失败:"
    echo "$TOKEN_RESPONSE"
    exit 1
fi
echo "✅ Token 获取成功"

# Step 2: 上传文件
echo "📤 上传文件..."
UPLOAD_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/im/v1/files" \
    -H "Authorization: Bearer $TOKEN" \
    -F "file_type=stream" \
    -F "file_name=$(basename "$FILE_PATH")" \
    -F "file=@$FILE_PATH")

FILE_KEY=$(echo "$UPLOAD_RESPONSE" | grep -o '"file_key":"[^"]*' | cut -d'"' -f4)
UPLOAD_CODE=$(echo "$UPLOAD_RESPONSE" | grep -o '"code":[0-9]*' | cut -d':' -f2)

if [ "$UPLOAD_CODE" != "0" ] || [ -z "$FILE_KEY" ]; then
    echo "❌ 上传文件失败:"
    echo "$UPLOAD_RESPONSE"
    exit 1
fi
echo "✅ 文件上传成功: $FILE_KEY"

# Step 3: 发送文件消息
echo "💬 发送文件消息..."
SEND_RESPONSE=$(curl -s -X POST "https://open.feishu.cn/open-apis/im/v1/messages?receive_id_type=open_id" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"receive_id\":\"$RECEIVE_ID\",\"msg_type\":\"file\",\"content\":\"{\\\"file_key\\\":\\\"$FILE_KEY\\\"}\"}")

SEND_CODE=$(echo "$SEND_RESPONSE" | grep -o '"code":[0-9]*' | cut -d':' -f2)
MESSAGE_ID=$(echo "$SEND_RESPONSE" | grep -o '"message_id":"[^"]*' | cut -d'"' -f4)

if [ "$SEND_CODE" != "0" ]; then
    echo "❌ 发送消息失败:"
    echo "$SEND_RESPONSE"
    exit 1
fi

echo "✅ 文件发送成功!"
echo "   消息ID: $MESSAGE_ID"
