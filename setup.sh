#!/bin/bash
# Self Dev Facilitation セットアップスクリプト

set -e

TOOLS_DIR=".dev-tools"
REPO="idylle-cynique/self-dev-facilitation"

echo "==> Self Dev Facilitation をセットアップしています..."

# 1. tiged でファイルを取得
echo "  - ファイルを取得中..."
npx tiged "$REPO" "$TOOLS_DIR"

# 2. 必要なディレクトリを作成
mkdir -p .github

# 3. ファイルをコピー
echo "  - ファイルをコピー..."

# GitHub Issue Templates
if [ -d "$TOOLS_DIR/.github/ISSUE_TEMPLATE" ]; then
    # Remove existing ISSUE_TEMPLATE completely (symlink, file, or directory)
    # This ensures deleted/renamed templates are also removed from local
    if [ -e ".github/ISSUE_TEMPLATE" ] || [ -L ".github/ISSUE_TEMPLATE" ]; then
        rm -rf .github/ISSUE_TEMPLATE
    fi

    # Create fresh directory
    mkdir -p .github/ISSUE_TEMPLATE

    # Copy all template files
    cp -f "$TOOLS_DIR/.github/ISSUE_TEMPLATE/"*.md .github/ISSUE_TEMPLATE/ 2>/dev/null || true
    echo "    ✓ Issue templates copied"
else
    echo "    ⚠ Issue templates not found in $TOOLS_DIR"
fi

# GitHub Pull Request Template
if [ -f "$TOOLS_DIR/.github/PULL_REQUEST_TEMPLATE.md" ]; then
    # Remove existing PULL_REQUEST_TEMPLATE if it's a symlink or directory
    if [ -L ".github/PULL_REQUEST_TEMPLATE" ] || [ -d ".github/PULL_REQUEST_TEMPLATE" ]; then
        rm -rf .github/PULL_REQUEST_TEMPLATE
    fi

    cp -f "$TOOLS_DIR/.github/PULL_REQUEST_TEMPLATE.md" .github/PULL_REQUEST_TEMPLATE.md
    echo "    ✓ Pull request template copied"
else
    echo "    ⚠ Pull request template not found in $TOOLS_DIR"
fi

# Git hooks
if [ -f "$TOOLS_DIR/utils/git/install-hooks.sh" ]; then
    bash "$TOOLS_DIR/utils/git/install-hooks.sh"
fi

# 設定ファイル (.pylintrc)
if [ -f "$TOOLS_DIR/.pylintrc" ]; then
    # Remove if it's a symlink
    if [ -L ".pylintrc" ]; then
        rm -f .pylintrc
    fi

    cp -f "$TOOLS_DIR/.pylintrc" .pylintrc
    echo "    ✓ .pylintrc copied"
else
    echo "    ⚠ .pylintrc not found in $TOOLS_DIR"
fi

# 4. .gitignore に追加
echo "  - .gitignore を更新..."

# .gitignore が存在しない場合は作成
if [ ! -f .gitignore ]; then
    touch .gitignore
fi

# 除外対象のエントリ
ENTRIES=(
    ".dev-tools/"
    ".pylintrc"
    ".github/ISSUE_TEMPLATE/"
    ".github/PULL_REQUEST_TEMPLATE.md"
)

# コメント行を追加（まだなければ）
if ! grep -q "^# Self Dev Facilitation" .gitignore; then
    echo "" >> .gitignore
    echo "# Self Dev Facilitation" >> .gitignore
fi

# 各エントリを確認して追加
for entry in "${ENTRIES[@]}"; do
    if ! grep -qF "$entry" .gitignore; then
        echo "$entry" >> .gitignore
    fi
done

echo ""
echo "==> セットアップ完了"
echo ""
echo "次のステップ:"
echo "  - 更新: bash .dev-tools/update.sh を実行"
echo "  - または: npx tiged $REPO .dev-tools --force"
echo ""