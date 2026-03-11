# Feishu Send File Skill

> **Skill Metadata**
> - Name: `feishu-send-file`
> - Version: `1.0.0`
> - Author: Henry
> - Tags: feishu, file-transfer, messaging

直接发送本地文件到飞书对话的自定义工具。

## 🎯 激活条件

当遇到以下情况时自动激活此技能:
- 用户要求发送文件到飞书
- 需要分享文件给飞书联系人
- 生成报告/图表后需要发送到飞书

## ⚙️ 工作原理

绕过云盘,使用飞书 IM API 直接发送文件:

1. **上传文件** → 飞书临时素材库 (`/im/v1/files`)
2. **发送消息** → 把 `file_key` 发送给用户

## 使用方法

### 方式 1: 快速使用(推荐)

```bash
# 发送文件给奔波霸(默认)
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_0765c32b5ec622535c5ccc284982cfe5 \
  /path/to/file.pdf
```

### 方式 2: 发送给其他人

```bash
# 第一个参数是接收者的 open_id
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_xxxxxx \
  /path/to/file.svg
```

### 方式 3: 在任何 agent 中调用

所有 OpenClaw agent 都可以执行这个脚本:

```bash
exec /root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_0765c32b5ec622535c5ccc284982cfe5 \
  /path/to/generated/report.pdf
```

## Agent 集成示例

在你的 agent 代码中:

```markdown
当用户要求发送文件到飞书时:

1. 生成/准备好文件
2. 调用:
   exec /root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
     ou_0765c32b5ec622535c5ccc284982cfe5 \
     <文件路径>
3. 告知用户文件已发送
```

## 配置

自动从 `/root/.openclaw/openclaw.json.bak` 读取:
- `appId`
- `appSecret`

目标用户的 `open_id`:
- 奔波霸: `ou_0765c32b5ec622535c5ccc284982cfe5`

## 限制

- 文件大小限制: 最大 20MB
- 支持的文件类型: 所有常见格式(PDF, SVG, PNG, DOCX, XLSX, etc.)
- 文件会在飞书临时素材库保存一段时间后自动清理

## 示例

```bash
# 发送研究路线图
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_0765c32b5ec622535c5ccc284982cfe5 \
  /root/.openclaw/agents/wife/workspace/Research_Roadmap_V2.svg

# 发送 PDF 报告
/root/.openclaw/workspace/skills/feishu-send-file/send-file-wrapper.sh \
  ou_0765c32b5ec622535c5ccc284982cfe5 \
  /tmp/monthly_report.pdf
```
