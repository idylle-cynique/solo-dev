#!/bin/bash
# Self Dev Facilitation 更新スクリプト

set -e

TOOLS_DIR=".dev-tools"
REPO="idylle-cynique/self-dev-facilitation"

# Migration function - run once to transition old naming to new naming
migrate_templates_to_solodev_prefix() {
    local migrated=false

    # Migrate issue templates
    if [ -f ".github/ISSUE_TEMPLATE/bug-fix.md" ] && [ ! -f ".github/ISSUE_TEMPLATE/SOLODEV_bug-fix.md" ]; then
        mv .github/ISSUE_TEMPLATE/bug-fix.md .github/ISSUE_TEMPLATE/SOLODEV_bug-fix.md
        echo "    Migrated: bug-fix.md → SOLODEV_bug-fix.md"
        migrated=true
    fi

    if [ -f ".github/ISSUE_TEMPLATE/new-feature.md" ] && [ ! -f ".github/ISSUE_TEMPLATE/SOLODEV_new-feature.md" ]; then
        mv .github/ISSUE_TEMPLATE/new-feature.md .github/ISSUE_TEMPLATE/SOLODEV_new-feature.md
        echo "    Migrated: new-feature.md → SOLODEV_new-feature.md"
        migrated=true
    fi

    # Migrate PR template
    if [ -f ".github/PULL_REQUEST_TEMPLATE.md" ] && [ ! -f ".github/SOLODEV_PULL_REQUEST_TEMPLATE.md" ]; then
        mv .github/PULL_REQUEST_TEMPLATE.md .github/SOLODEV_PULL_REQUEST_TEMPLATE.md
        echo "    Migrated: PULL_REQUEST_TEMPLATE.md → SOLODEV_PULL_REQUEST_TEMPLATE.md"
        migrated=true
    fi

    if [ "$migrated" = true ]; then
        echo ""
        echo "  ════════════════════════════════════════════════════════"
        echo "  Migration Complete: Templates now use SOLODEV_ prefix"
        echo "  ════════════════════════════════════════════════════════"
        echo "  Custom templates (without SOLODEV_ prefix) are preserved"
        echo "  ════════════════════════════════════════════════════════"
        echo ""
    fi
}

echo "==> Self Dev Facilitation を更新しています..."

# tiged で強制上書き
npx tiged "$REPO" "$TOOLS_DIR" --force

# ファイルを更新
echo "  - テンプレートと設定ファイルを更新..."

# GitHub Issue Templates
if [ -d "$TOOLS_DIR/.github/ISSUE_TEMPLATE" ]; then
    # Run one-time migration from old naming to new naming
    migrate_templates_to_solodev_prefix

    # Create directory if needed
    mkdir -p .github/ISSUE_TEMPLATE

    # Remove old managed templates
    if compgen -G ".github/ISSUE_TEMPLATE/SOLODEV_*.md" > /dev/null 2>&1; then
        rm -f .github/ISSUE_TEMPLATE/SOLODEV_*.md
    fi

    # Copy new managed templates
    if compgen -G "$TOOLS_DIR/.github/ISSUE_TEMPLATE/SOLODEV_*.md" > /dev/null 2>&1; then
        cp -f "$TOOLS_DIR/.github/ISSUE_TEMPLATE/"SOLODEV_*.md .github/ISSUE_TEMPLATE/ 2>/dev/null || true
        echo "    ✓ Issue templates updated (custom templates preserved)"
    else
        echo "    ⚠ No managed templates found in $TOOLS_DIR"
    fi
fi

# GitHub Pull Request Template
if [ -f "$TOOLS_DIR/.github/SOLODEV_PULL_REQUEST_TEMPLATE.md" ]; then
    # Remove existing managed PR template
    if [ -f ".github/SOLODEV_PULL_REQUEST_TEMPLATE.md" ]; then
        rm -f .github/SOLODEV_PULL_REQUEST_TEMPLATE.md
    fi

    # Remove old non-prefixed version if it's a symlink or directory (cleanup)
    if [ -L ".github/PULL_REQUEST_TEMPLATE" ] || [ -d ".github/PULL_REQUEST_TEMPLATE" ]; then
        rm -rf .github/PULL_REQUEST_TEMPLATE
    fi

    cp -f "$TOOLS_DIR/.github/SOLODEV_PULL_REQUEST_TEMPLATE.md" .github/SOLODEV_PULL_REQUEST_TEMPLATE.md
    echo "    ✓ Pull request template updated"
fi

# GitHub Workflows
if [ -f "$TOOLS_DIR/.github/workflows/auto-pr-update-docs.yml" ]; then
    mkdir -p .github/workflows || { echo "    ✗ ワークフローディレクトリの作成に失敗"; exit 1; }
    cp -f "$TOOLS_DIR/.github/workflows/auto-pr-update-docs.yml" .github/workflows/auto-pr-update-docs.yml || {
        echo "    ✗ ワークフローファイルのコピーに失敗"; exit 1;
    }
    echo "    ✓ Workflow auto-pr-update-docs.yml updated"
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