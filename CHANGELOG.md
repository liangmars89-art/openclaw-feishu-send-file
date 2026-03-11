# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-11

### Added
- ✨ Initial release
- 📤 Direct file upload to Feishu IM via API
- 🔧 Automatic config loading from OpenClaw
- 📝 Complete documentation (EN + ZH)
- 🎯 OpenClaw skill structure with SKILL.md
- 🚀 Zero-dependency implementation (bash + curl)
- 🌐 Support for all file formats (max 20MB)
- 🔐 Secure token management
- 📦 Wrapper script for easy invocation
- 🎬 Demo script included

### Technical Details
- Uses Feishu Open API v3
- Implements 3-step flow: Token → Upload → Send
- Auto-reads credentials from `/root/.openclaw/openclaw.json.bak`
- Compatible with all OpenClaw agents

### Documentation
- English README
- Chinese README (简体中文)
- Detailed SKILL.md for OpenClaw integration
- MIT License
- Demo script for testing

## [Unreleased]

### Planned Features
- [ ] Batch file sending
- [ ] Progress bar for large files
- [ ] Auto-compress files over 20MB
- [ ] Send history tracking
- [ ] Folder packing and sending
- [ ] Retry mechanism on failure
- [ ] Configuration file support
- [ ] Multiple receiver support

---

## Version History

### Comparison
- [1.0.0] - 2026-03-11 - Initial release
