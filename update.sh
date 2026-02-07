#!/bin/bash
# Self Dev Facilitation 更新スクリプト

set -e

TOOLS_DIR=".dev-tools"
REPO="idylle-cynique/self-dev-facilitation"

echo "==> Self Dev Facilitation を更新しています..."

# tiged で強制上書き
npx tiged "$REPO" "$TOOLS_DIR" --force

# ファイルを更新
echo "  - テンプレートと設定ファイルを更新..."

# GitHub Issue Templates
if [ -d "$TOOLS_DIR/.github/ISSUE_TEMPLATE" ]; then
    # Remove existing ISSUE_TEMPLATE if it's a symlink or file (not directory)
    if [ -L ".github/ISSUE_TEMPLATE" ] || [ -f ".github/ISSUE_TEMPLATE" ]; then
        rm -f .github/ISSUE_TEMPLATE
    fi

    mkdir -p .github/ISSUE_TEMPLATE
    cp -f "$TOOLS_DIR/.github/ISSUE_TEMPLATE/"*.md .github/ISSUE_TEMPLATE/ 2>/dev/null || true
    echo "    ✓ Issue templates updated"
fi

# GitHub Pull Request Template
if [ -f "$TOOLS_DIR/.github/PULL_REQUEST_TEMPLATE.md" ]; then
    # Remove existing PULL_REQUEST_TEMPLATE if it's a symlink or directory
    if [ -L ".github/PULL_REQUEST_TEMPLATE" ] || [ -d ".github/PULL_REQUEST_TEMPLATE" ]; then
        rm -rf .github/PULL_REQUEST_TEMPLATE
    fi

    cp -f "$TOOLS_DIR/.github/PULL_REQUEST_TEMPLATE.md" .github/PULL_REQUEST_TEMPLATE.md
    echo "    ✓ Pull request template updated"
fi

# 設定ファイル (.pylintrc)
if [ -f "$TOOLS_DIR/.pylintrc" ]; then
    if [ -L ".pylintrc" ]; then
        rm -f .pylintrc
    fi
    cp -f "$TOOLS_DIR/.pylintrc" .pylintrc
    echo "    ✓ .pylintrc updated"
fi

# Git hooks を再インストール
if [ -f "$TOOLS_DIR/utils/git/install-hooks.sh" ]; then
    echo "  - Git hooks を更新..."
    bash "$TOOLS_DIR/utils/git/install-hooks.sh"
fi

echo "==> 更新完了"