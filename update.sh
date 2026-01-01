#!/bin/bash
# Self Dev Facilitation 更新スクリプト (degit版)

set -e

TOOLS_DIR=".dev-tools"
REPO="idylle-cynique/self-dev-facilitation"

echo "🔄 Self Dev Facilitation を更新しています..."

# degit で強制上書き
npx degit "$REPO" "$TOOLS_DIR" --force

# Git hooks を再インストール
if [ -f "$TOOLS_DIR/utils/git/install-hooks.sh" ]; then
    echo "🔧 Git hooks を更新..."
    bash "$TOOLS_DIR/utils/git/install-hooks.sh"
fi

echo "✅ 更新完了！"