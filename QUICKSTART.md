# 🚀 Quick Start Guide

## 5-Minute Setup

### Step 1: Get the Skill

```bash
# Option A: Install from ClawHub (recommended)
clawhub install feishu-send-file

# Option B: Clone from GitHub
git clone https://github.com/liangmars89-art/openclaw-feishu-direct-file.git \
  /root/.openclaw/workspace/skills/feishu-send-file
```

### Step 2: Configure Credentials

Your Feishu app credentials should already be in OpenClaw config.
If not, add them to `/root/.openclaw/openclaw.json.bak`:

```json
{
  "appId": "cli_xxxxxx",
  "appSecret": "xxxxxxxx"
}
```

### Step 3: Test It!

```bash
# Create a test file
echo "Hello Feishu!" > /tmp/test.txt

# Send it
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  YOUR_OPEN_ID \
  /tmp/test.txt
```

### Step 4: Use in Conversations

Just tell any OpenClaw agent:

```
"Send this PDF to my Feishu"
"发送这个文件到我的飞书"
```

Done! 🎉

---

## Common Use Cases

### Generate and Send Report

```bash
# Generate report
python my_report_generator.py -o report.pdf

# Send to Feishu
send-file-wrapper.sh ou_xxx report.pdf
```

### CI/CD Integration

```yaml
# .github/workflows/deploy.yml
- name: Build
  run: npm run build

- name: Send to Feishu
  run: |
    /path/to/send-file-wrapper.sh \
      ${{ secrets.FEISHU_RECEIVER_ID }} \
      ./dist/app.zip
```

### Scheduled Tasks

```bash
# crontab -e
0 9 * * * /scripts/generate_daily_report.sh && \
          send-file-wrapper.sh ou_xxx /tmp/daily_report.pdf
```

---

## Troubleshooting

### "Token获取失败"

Check your credentials:
```bash
cat /root/.openclaw/openclaw.json.bak | grep -A 2 appId
```

### "文件上传失败"

Check file size (max 20MB):
```bash
du -h /path/to/file
```

### "Permission denied"

Make scripts executable:
```bash
chmod +x /root/.openclaw/workspace/skills/feishu-send-file/*.sh
```

---

## Need Help?

- 📖 [Full Documentation](./README.md)
- 💬 [OpenClaw Discord](https://discord.com/invite/clawd)
- 🐛 [Report Issue](https://github.com/liangmars89-art/openclaw-feishu-direct-file/issues)

---

**That's it! Start automating your file sharing now!** 🚀
