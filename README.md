# self-dev-facilitation

個人開発用の共通ツール・テンプレート集

## 概要

このリポジトリには、複数のプロジェクトで共通して使用する以下のリソースが含まれています：

- GitHub Issue/PR テンプレート
- Git フック（pre-push など）
- 設定ファイル（.pylintrc など）
- ドキュメント・ガイドライン

## セットアップ

### 前提条件

- Node.js（npx コマンドが使用可能であること）
- このリポジトリへのアクセス権限があるか、ローカルにクローンされていること

### 新規プロジェクトへの導入

ローカルクローンを使用する場合（初回のみ）：

```bash
git clone https://github.com/idylle-cynique/self-dev-facilitation.git ~/github/self-dev-facilitation
```

プロジェクトのルートディレクトリで以下を実行：

```bash
bash ~/github/self-dev-facilitation/setup.sh
```

これにより以下が自動的に行われます：

1. `.dev-tools/` ディレクトリに最新のファイルを取得
2. テンプレートと設定ファイルをコピー
3. Git フックをインストール
4. `.gitignore` に除外設定を追加

### 最新版への更新

プロジェクト内で以下を実行：

```bash
bash .dev-tools/update.sh
```

または直接：

```bash
npx tiged idylle-cynique/self-dev-facilitation .dev-tools --force
bash .dev-tools/utils/git/install-hooks.sh
```

## 導入されるファイル

導入後、以下のファイルがコピーされます：

- `.github/ISSUE_TEMPLATE/SOLODEV_*.md` ← `.dev-tools/.github/ISSUE_TEMPLATE/`
- `.github/SOLODEV_PULL_REQUEST_TEMPLATE.md` ← `.dev-tools/.github/SOLODEV_PULL_REQUEST_TEMPLATE.md`
- `.pylintrc` ← `.dev-tools/.pylintrc`
- `.git/hooks/pre-push` ← Git フック

これらは `.gitignore` で除外されるため、**リポジトリにコミットされません**。

## 管理テンプレートとカスタムテンプレート

### 管理されるテンプレート (Managed Templates)

このツールによって管理されるテンプレートは `SOLODEV_` プレフィックスが付いています:

- `.github/ISSUE_TEMPLATE/SOLODEV_bug-fix.md`
- `.github/ISSUE_TEMPLATE/SOLODEV_new-feature.md`
- `.github/SOLODEV_PULL_REQUEST_TEMPLATE.md`

これらのテンプレートは更新時に自動的に上書きされます。

### カスタムテンプレート (Custom Templates)

プレフィックスなしのテンプレートはカスタムテンプレートとして扱われ、更新時に削除されません:

```bash
# カスタムテンプレートの例
.github/ISSUE_TEMPLATE/custom-workflow.md
.github/ISSUE_TEMPLATE/documentation-update.md
```

カスタムテンプレートを追加するには:

1. `.github/ISSUE_TEMPLATE/` に新しい `.md` ファイルを作成
2. ファイル名に `SOLODEV_` プレフィックスを**付けない**
3. YAML frontmatter を含める (name, about, title, labels など)

例:

```markdown
---
name: カスタムワークフロー
about: プロジェクト固有のワークフロー用テンプレート
title: ''
labels: workflow
assignees: ''
---

## 内容
<!-- テンプレートの内容 -->
```

### 注意事項

- `SOLODEV_` プレフィックス付きテンプレートは編集しないでください (更新時に上書きされます)
- カスタムテンプレートをバージョン管理に含めたい場合は、コミット可能です (`.gitignore` で除外されません)

## 仕組み

1. **tiged** を使用してこのリポジトリの最新版を `.dev-tools/` にコピー
2. テンプレートと設定ファイルを各プロジェクトにコピー
3. 元ファイルは `.dev-tools/` 内に保持され、更新時に再コピー
4. `.gitignore` で除外されるため、Git の追跡対象外

## このリポジトリの更新

このリポジトリ自体を更新した場合：

```bash
cd ~/github/self-dev-facilitation
git pull
```

各プロジェクトで `bash .dev-tools/update.sh` を実行すれば最新版が反映されます。

## トラブルシューティング

### npx が見つからない

Node.js をインストールしてください：

```bash
# Ubuntu/Debian
sudo apt install nodejs npm

# macOS
brew install node
```

### ファイルが正しくコピーされていない

再度セットアップスクリプトを実行してください：

```bash
bash ~/github/self-dev-facilitation/setup.sh
```

または更新スクリプトを実行：

```bash
bash .dev-tools/update.sh
```
