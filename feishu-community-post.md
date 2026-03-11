# 🚀 开源工具分享：飞书文件直发工具 - 绕过云盘限制,一键发送文件

## 📌 项目简介

大家好!我开发了一个开源工具,解决飞书自动化中的一个常见痛点:**如何通过 API 直接发送文件到飞书对话,而不经过云盘?**

很多开发者在使用飞书 Open API 时,都遇到过这个问题:
- ❌ 云盘 API 上传流程复杂
- ❌ 需要处理权限和分享逻辑
- ❌ 用户体验不够直接

**这个工具提供了更简单的方案:**
- ✅ 直接通过 IM API 发送文件到对话
- ✅ 零依赖,仅需 bash + curl
- ✅ 一行命令完成上传+发送

---

## 🎯 核心功能

```bash
# 一行命令发送文件
./send-file.sh <接收者open_id> /path/to/file.pdf

# 就这么简单!
```

**支持场景:**
- 📊 自动生成报告后发送给团队成员
- 🤖 CI/CD 流程中发送构建产物
- 📈 数据分析结果自动分享
- 🔔 定时任务发送日报/周报

---

## 💡 工作原理

```
本地文件 
  ↓ 
调用 /open-apis/im/v1/files 上传到临时素材库
  ↓
获取 file_key
  ↓
调用 /open-apis/im/v1/messages 发送文件消息
  ↓
文件出现在飞书对话中
```

**技术特点:**
- 使用飞书官方 Open API
- 文件保存在临时素材库(自动过期)
- 无需处理云盘权限
- 支持所有文件格式(最大 20MB)

---

## 🛠️ 快速开始

### 1. 下载工具

```bash
git clone https://github.com/liangmars89-art/openclaw-feishu-send-file.git
cd openclaw-feishu-send-file
```

### 2. 配置凭证

需要飞书企业自建应用的凭证:
- `app_id`
- `app_secret`

权限要求:
- `im:message` (发送消息)
- `im:message.file` (发送文件)

### 3. 使用

```bash
# 方式 1: 设置环境变量
export FEISHU_APP_ID="cli_xxx"
export FEISHU_APP_SECRET="xxx"

./send-file-wrapper.sh ou_接收者ID /path/to/file.pdf

# 方式 2: 直接在脚本中配置
# 修改 send-file.sh 中的 APP_ID 和 APP_SECRET
```

---

## 📖 使用示例

### 示例 1: Python 数据分析

```python
import matplotlib.pyplot as plt
import subprocess

# 生成图表
plt.plot([1, 2, 3], [4, 5, 6])
plt.savefig('/tmp/chart.png')

# 发送到飞书
subprocess.run([
    './send-file-wrapper.sh',
    'ou_xxx',  # 接收者 open_id
    '/tmp/chart.png'
])
```

### 示例 2: 定时任务

```bash
# crontab -e
0 9 * * * /scripts/generate_report.sh && \
          /path/to/send-file-wrapper.sh ou_xxx /tmp/daily_report.pdf
```

### 示例 3: GitHub Actions

```yaml
name: Build and Send
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Build
        run: npm run build
      
      - name: Send to Feishu
        env:
          FEISHU_APP_ID: ${{ secrets.FEISHU_APP_ID }}
          FEISHU_APP_SECRET: ${{ secrets.FEISHU_APP_SECRET }}
        run: |
          ./send-file-wrapper.sh ${{ secrets.RECEIVER_ID }} ./build/app.zip
```

---

## 🌟 项目特色

### 1. 零依赖
只需要系统自带的 `bash` 和 `curl`,无需安装 Node.js、Python 或其他运行时。

### 2. 开箱即用
复制脚本,配置凭证,立即可用。

### 3. 完整文档
- 中英双语 README
- 详细的使用示例
- 故障排查指南

### 4. MIT 开源
自由使用、修改和分发。

---

## 📊 支持的文件类型

| 类型 | 格式 | 最大大小 |
|------|------|----------|
| 文档 | PDF, DOCX, XLSX, PPTX | 20MB |
| 图片 | PNG, JPG, SVG, GIF | 20MB |
| 压缩包 | ZIP, RAR, 7Z | 20MB |
| 代码 | TXT, JSON, YAML, MD | 20MB |
| 其他 | 任意格式 | 20MB |

---

## 🔧 进阶用法

### 批量发送(脚本示例)

```bash
#!/bin/bash
# 批量发送文件

for file in /reports/*.pdf; do
    ./send-file-wrapper.sh ou_xxx "$file"
    sleep 1  # 避免频率限制
done
```

### 与其他工具集成

```bash
# 与企业微信集成
generate_report.py | tee report.txt
./send-file-wrapper.sh ou_xxx report.txt

# 与监控系统集成
if [ $ERROR_COUNT -gt 0 ]; then
    echo "发现 $ERROR_COUNT 个错误" > alert.txt
    ./send-file-wrapper.sh ou_xxx alert.txt
fi
```

---

## 🤔 常见问题

### Q: 和云盘 API 相比有什么优势?

**A:** 
- ⚡ 更快:无需经过云盘中转
- 🎯 更直接:文件立即出现在对话中
- 🔒 更简单:无需处理云盘权限和分享逻辑

### Q: 文件会保存多久?

**A:** 文件存储在飞书临时素材库,会自动过期(通常 7-30 天)。

### Q: 支持发送给群组吗?

**A:** 支持!使用群组的 `chat_id` 作为接收者 ID 即可。

### Q: 可以发送给自己吗?

**A:** 可以!使用你自己的 `open_id` 即可。

---

## 📦 项目资源

- **GitHub**: https://github.com/liangmars89-art/openclaw-feishu-send-file
- **文档**: 见仓库 README
- **License**: MIT

---

## 🤝 贡献与反馈

欢迎:
- 🐛 提交 Issue 报告问题
- 💡 分享你的使用场景
- 🔧 提交 PR 改进代码
- ⭐ 给项目点个 Star 支持一下!

---

## 🎉 结语

这个工具已经在我的生产环境中稳定运行,希望能帮到有类似需求的开发者!

如果你觉得有用,欢迎:
- ⭐ Star 项目
- 📢 分享给需要的同事
- 💬 留言讨论你的使用场景

**让飞书自动化更简单!** 🚀

---

*作者: liangmars89-art*  
*发布日期: 2026-03-11*  
*标签: #飞书开放平台 #自动化 #OpenAPI #开源工具*
