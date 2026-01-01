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

# 3. シンボリックリンクを作成
echo "  - シンボリックリンクを作成..."

# GitHub templates
ln -sf ../$TOOLS_DIR/.github/ISSUE_TEMPLATE .github/ISSUE_TEMPLATE 2>/dev/null || true
ln -sf ../$TOOLS_DIR/.github/PULL_REQUEST_TEMPLATE .github/PULL_REQUEST_TEMPLATE 2>/dev/null || true

# Git hooks
if [ -f "$TOOLS_DIR/utils/git/install-hooks.sh" ]; then
    bash "$TOOLS_DIR/utils/git/install-hooks.sh"
fi

# 設定ファイル
ln -sf $TOOLS_DIR/.pylintrc .pylintrc 2>/dev/null || true

# 4. .gitignore に追加
echo "  - .gitignore を更新..."
if [ -f .gitignore ]; then
    grep -q "^# Self Dev Facilitation" .gitignore || cat >> .gitignore << 'EOF'

# Self Dev Facilitation
.dev-tools/
.pylintrc
.github/ISSUE_TEMPLATE
.github/PULL_REQUEST_TEMPLATE
EOF
else
    cat > .gitignore << 'EOF'
# Self Dev Facilitation
.dev-tools/
.pylintrc
.github/ISSUE_TEMPLATE
.github/PULL_REQUEST_TEMPLATE
EOF
fi

echo ""
echo "==> セットアップ完了"
echo ""
echo "次のステップ:"
echo "  - 更新: bash .dev-tools/update.sh を実行"
echo "  - または: npx tiged $REPO .dev-tools --force"
echo ""