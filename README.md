# Feishu Send File - Direct File Transfer for Feishu

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Skill-blue.svg)](https://openclaw.ai)
[![Feishu](https://img.shields.io/badge/Feishu-Integration-green.svg)](https://open.feishu.cn)

**Bypass cloud drive limitations, send files to Feishu conversations instantly** 🚀

English | [简体中文](./README.zh-CN.md)

</div>

---

## 🎯 Key Features

- ✅ **Direct Send** - Bypass Feishu Drive, send files via IM API directly
- ✅ **Zero Dependencies** - Only requires system `bash` and `curl`
- ✅ **All Formats** - PDF, SVG, PNG, DOCX, XLSX... any format (max 20MB)
- ✅ **OpenClaw Native** - Automatically shared across all agents
- ✅ **Automation Friendly** - One command to upload + send

## 📦 Quick Start

### Installation

```bash
# Clone or copy to OpenClaw skills directory
cp -r feishu-direct-file /root/.openclaw/workspace/skills/
```

### Configuration

Add credentials to your Feishu app config:

```json
{
  "appId": "cli_xxxxxx",
  "appSecret": "xxxxxxxx"
}
```

### Usage

#### Method 1: Request in Conversation

Tell any OpenClaw agent:

```
"Send this PDF report to my Feishu"
```

The agent will automatically recognize and invoke this skill.

#### Method 2: Command Line

```bash
/root/.openclaw/workspace/skills/feishu-direct-file/send-file-wrapper.sh \
  ou_your_open_id \
  /path/to/your/file.pdf
```

## 🎬 Demo

```bash
$ ./send-file-wrapper.sh ou_xxx report.pdf

📦 Feishu File Sender
─────────────────────
File: report.pdf
Receiver: ou_xxx

🔑 Getting access token...
✅ Token obtained
📤 Uploading file...
✅ File uploaded: file_v3_xxx
💬 Sending message...
✅ File sent successfully!
   Message ID: om_xxx
```

## 🏗️ How It Works

```mermaid
graph LR
    A[Local File] -->|Upload| B[Feishu Temp Storage]
    B -->|Return file_key| C[Send IM Message]
    C -->|Push| D[Feishu Chat]
```

1. **Get Token** - Obtain access token using App ID/Secret
2. **Upload File** - POST `/im/v1/files` to temp storage
3. **Send Message** - POST `/im/v1/messages` with file key

## 📖 Use Cases

### Case 1: Auto-generate and Send Reports

```bash
# Generate monthly report
python generate_monthly_report.py -o /tmp/report.pdf

# Auto-send to Feishu
send-file-wrapper.sh ou_xxx /tmp/report.pdf
```

### Case 2: CI/CD Integration

```yaml
# .github/workflows/build.yml
- name: Send build artifact to Feishu
  run: |
    /root/.openclaw/workspace/skills/feishu-direct-file/send-file-wrapper.sh \
      ${{ secrets.FEISHU_RECEIVER_ID }} \
      ./build/app.apk
```

### Case 3: Data Analysis Automation

```python
# data_analysis.py
import subprocess

# Generate chart
plt.savefig('/tmp/chart.png')

# Send to Feishu
subprocess.run([
    '/root/.openclaw/workspace/skills/feishu-direct-file/send-file-wrapper.sh',
    'ou_xxx',
    '/tmp/chart.png'
])
```

## 🔧 Advanced Configuration

### Environment Variables

```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
export FEISHU_DEFAULT_RECEIVER="ou_xxx"
```

### Batch Send (Future Version)

```bash
# TODO: Support batch sending
send-file-wrapper.sh ou_xxx file1.pdf file2.png file3.docx
```

## 🤔 Why This Tool?

**Problem**: OpenClaw's official `feishu_drive` tool **doesn't support uploading** files to Drive.

**Solution**: This tool bypasses Drive and sends files directly via IM API.

**Advantages**:
- ⚡ Faster - No Drive intermediary
- 🎯 More Direct - Files appear in chat immediately
- 🔒 More Secure - Temp storage, auto-expires

## 📊 Supported File Types

| Type | Formats | Max Size |
|------|---------|----------|
| Documents | PDF, DOCX, XLSX, PPTX | 20MB |
| Images | PNG, JPG, SVG, GIF | 20MB |
| Archives | ZIP, RAR, 7Z | 20MB |
| Code | TXT, JSON, YAML, MD | 20MB |
| Others | Any format | 20MB |

## 🛠️ Troubleshooting

### Token Retrieval Failed

**Cause**: Incorrect or expired App ID/Secret

**Solution**:
```bash
# Check configuration
cat /root/.openclaw/openclaw.json.bak | grep -A 2 appId
```

### Upload Failed

**Cause**: File too large or unsupported format

**Solution**:
```bash
# Check file size
du -h /path/to/file

# Compress large files
zip file.zip large_file.pdf
```

### Permission Error

**Cause**: Feishu app missing required permissions

**Solution**: Enable in Feishu Developer Console:
- `im:message` (Send messages)
- `im:message.file` (Send files)

## 🤝 Contributing

Issues and Pull Requests are welcome!

### Roadmap

- [ ] Batch sending support
- [ ] Progress bar display
- [ ] Auto-compress large files
- [ ] Folder packing and sending
- [ ] Send history tracking

## 📄 License

[MIT License](./LICENSE)

## 🙏 Acknowledgments

- [OpenClaw](https://openclaw.ai) - Powerful AI Agent platform
- [Feishu Open Platform](https://open.feishu.cn) - API support
- Community contributors - Thanks for all feedback and suggestions

## 📮 Contact

- **Author**: 奔波霸 & Henry (OpenClaw Agent)
- **Issues**: [GitHub Issues](https://github.com/yourusername/openclaw-feishu-direct-file/issues)
- **Community**: [OpenClaw Discord](https://discord.com/invite/clawd)

---

<div align="center">

**If this tool helped you, please give it a ⭐️!**

Made with ❤️ by OpenClaw Community

</div>
