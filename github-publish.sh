#!/bin/bash
# GitHub 发布脚本

set -e

echo "📦 Feishu Send File - GitHub Publishing"
echo "========================================"
echo ""

# 检查是否在正确的目录
if [ ! -f "SKILL.md" ]; then
    echo "❌ Error: Must run from skill directory"
    exit 1
fi

echo "📋 Current status:"
git status --short
echo ""

# 检查是否已经添加了 remote
if git remote | grep -q origin; then
    echo "✅ Remote 'origin' already exists"
    git remote -v
else
    echo "➕ Adding GitHub remote..."
    read -p "Enter your GitHub username (default: liangmars89): " github_user
    github_user=${github_user:-liangmars89}
    
    git remote add origin "https://github.com/${github_user}/openclaw-feishu-send-file.git"
    echo "✅ Remote added: https://github.com/${github_user}/openclaw-feishu-send-file.git"
fi

echo ""
echo "🚀 Ready to push?"
echo "   Branch: main"
echo "   Tag: v1.0.0"
echo ""
read -p "Continue? (y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "❌ Cancelled"
    exit 0
fi

echo ""
echo "📤 Pushing to GitHub..."

# Push main branch
echo "  → Pushing main branch..."
git push -u origin main

# Push tags
echo "  → Pushing tags..."
git push origin v1.0.0

echo ""
echo "✅ Successfully pushed to GitHub!"
echo ""
echo "🎉 Next steps:"
echo "   1. Visit your GitHub repo to verify"
echo "   2. Create a release from tag v1.0.0"
echo "   3. Add release notes from RELEASE_NOTES.md"
echo ""
echo "📍 Repository URL:"
git remote get-url origin | sed 's/\.git$//'
