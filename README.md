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
- このリポジトリがローカルにクローンされていること

```bash
git clone https://github.com/idylle-cynique/self-dev-facilitation.git ~/github/self-dev-facilitation
```

### 新規プロジェクトへの導入

プロジェクトのルートディレクトリで以下を実行：

```bash
bash ~/github/self-dev-facilitation/setup.sh
```

これにより以下が自動的に行われます：

1. `.dev-tools/` ディレクトリに最新のファイルを取得
2. 必要なシンボリックリンクを作成
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

導入後、以下のシンボリックリンクが作成されます：

- `.github/ISSUE_TEMPLATE/` → `.dev-tools/.github/ISSUE_TEMPLATE/`
- `.github/PULL_REQUEST_TEMPLATE/` → `.dev-tools/.github/PULL_REQUEST_TEMPLATE/`
- `.pylintrc` → `.dev-tools/.pylintrc`
- `.git/hooks/pre-push` → Git フック

これらは `.gitignore` で除外されるため、**リポジトリにコミットされません**。

## 仕組み

1. **tiged** を使用してこのリポジトリの最新版を `.dev-tools/` にコピー
2. シンボリックリンクで各プロジェクトから参照
3. 実ファイルは `.dev-tools/` 内にのみ存在
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

### シンボリックリンクが壊れている

再度セットアップスクリプトを実行してください：

```bash
bash ~/github/self-dev-facilitation/setup.sh
```
