# Feishu Send File - 飞书文件直发工具

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![OpenClaw](https://img.shields.io/badge/OpenClaw-Skill-blue.svg)](https://openclaw.ai)
[![Feishu](https://img.shields.io/badge/Feishu-Integration-green.svg)](https://open.feishu.cn)

**绕过云盘限制,一键发送文件到飞书对话** 🚀

[English](./README.md) | 简体中文

</div>

---

## 🎯 核心功能

- ✅ **直接发送** - 绕过飞书云盘,直接通过 IM API 发送文件
- ✅ **零依赖** - 仅需系统自带的 `bash` 和 `curl`
- ✅ **全格式支持** - PDF、SVG、PNG、DOCX、XLSX... 任意格式(最大 20MB)
- ✅ **OpenClaw 原生** - 所有 agent 自动共享,开箱即用
- ✅ **自动化友好** - 一行命令完成上传+发送

## 📦 快速开始

### 安装

```bash
# 克隆或复制到 OpenClaw skills 目录
cp -r feishu-send-file /root/.openclaw/workspace/skills/
```

### 配置

在你的飞书应用配置中添加凭证:

```json
{
  "appId": "cli_xxxxxx",
  "appSecret": "xxxxxxxx"
}
```

### 使用

#### 方式 1: 在对话中直接请求

对任何 OpenClaw agent 说:

```
"帮我把这个 PDF 报告发送到我的飞书"
```

Agent 会自动识别并调用此技能。

#### 方式 2: 命令行直接调用

```bash
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_你的open_id \
  /path/to/your/file.pdf
```

## 🎬 演示

```bash
$ ./send-file-wrapper.sh ou_xxx report.pdf

📦 飞书文件发送工具
─────────────────────
文件: report.pdf
接收者: ou_xxx

🔑 获取访问令牌...
✅ Token 获取成功
📤 上传文件...
✅ 文件上传成功: file_v3_xxx
💬 发送文件消息...
✅ 文件发送成功!
   消息ID: om_xxx
```

## 🏗️ 工作原理

```mermaid
graph LR
    A[本地文件] -->|上传| B[飞书临时素材库]
    B -->|返回 file_key| C[发送 IM 消息]
    C -->|推送| D[飞书对话框]
```

1. **获取 Token** - 使用 App ID/Secret 获取访问令牌
2. **上传文件** - POST `/im/v1/files` 上传到临时素材库
3. **发送消息** - POST `/im/v1/messages` 发送文件消息

## 📖 使用场景

### 场景 1: 自动生成报告并发送

```bash
# 生成月度报告
python generate_monthly_report.py -o /tmp/report.pdf

# 自动发送到飞书
send-file-wrapper.sh ou_xxx /tmp/report.pdf
```

### 场景 2: CI/CD 集成

```yaml
# .github/workflows/build.yml
- name: Send build artifact to Feishu
  run: |
    /root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
      ${{ secrets.FEISHU_RECEIVER_ID }} \
      ./build/app.apk
```

### 场景 3: 数据分析自动化

```python
# data_analysis.py
import subprocess

# 生成图表
plt.savefig('/tmp/chart.png')

# 发送到飞书
subprocess.run([
    '/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh',
    'ou_xxx',
    '/tmp/chart.png'
])
```

## 🔧 高级配置

### 环境变量

```bash
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"
export FEISHU_DEFAULT_RECEIVER="ou_xxx"
```

### 批量发送(未来版本)

```bash
# TODO: 支持批量发送
send-file-wrapper.sh ou_xxx file1.pdf file2.png file3.docx
```

## 🤔 为什么需要这个工具?

**问题**: 飞书官方的 OpenClaw `feishu_drive` 工具**不支持上传文件**到云盘。

**解决**: 本工具绕过云盘,直接通过 IM API 发送文件到对话框。

**优势**:
- ⚡ 更快 - 无需经过云盘中转
- 🎯 更直接 - 文件立即出现在对话中
- 🔒 更安全 - 临时素材,自动过期

## 📊 支持的文件类型

| 类型 | 格式 | 最大大小 |
|------|------|----------|
| 文档 | PDF, DOCX, XLSX, PPTX | 20MB |
| 图片 | PNG, JPG, SVG, GIF | 20MB |
| 压缩包 | ZIP, RAR, 7Z | 20MB |
| 代码 | TXT, JSON, YAML, MD | 20MB |
| 其他 | 任意格式 | 20MB |

## 🛠️ 故障排查

### Token 获取失败

**原因**: App ID/Secret 错误或过期

**解决**:
```bash
# 检查配置
cat /root/.openclaw/openclaw.json.bak | grep -A 2 appId
```

### 上传失败

**原因**: 文件过大或格式不支持

**解决**:
```bash
# 检查文件大小
du -h /path/to/file

# 压缩大文件
zip file.zip large_file.pdf
```

### 权限错误

**原因**: 飞书应用缺少必要权限

**解决**: 在飞书开发者后台开启:
- `im:message` (发送消息)
- `im:message.file` (发送文件)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

### 开发计划

- [ ] 支持批量发送
- [ ] 添加进度条显示
- [ ] 自动压缩大文件
- [ ] 支持文件夹打包发送
- [ ] 添加发送历史记录

## 📄 许可证

[MIT License](./LICENSE)

## 🙏 致谢

- [OpenClaw](https://openclaw.ai) - 强大的 AI Agent 平台
- [飞书开放平台](https://open.feishu.cn) - 提供 API 支持
- 社区贡献者 - 感谢所有反馈和建议

## 📮 联系方式

- **作者**: 奔波霸 & Henry (OpenClaw Agent)
- **问题反馈**: [GitHub Issues](https://github.com/yourusername/openclaw-feishu-send-file/issues)
- **技术交流**: [OpenClaw Discord](https://discord.com/invite/clawd)

---

<div align="center">

**如果这个工具帮到了你,请给个 ⭐️!**

Made with ❤️ by OpenClaw Community

</div>
