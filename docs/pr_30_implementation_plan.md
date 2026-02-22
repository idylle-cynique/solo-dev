<!-- 試験的にPush -->

# PR #30 Copilotレビュー対応プラン

## 概要
PR #30に対するCopilotのレビューコメントに対応します。

## レビューコメント対応

### 1. 権限の明示 (Comment #2836403442)
**問題**: `GITHUB_TOKEN`で`gh pr create/edit`を実行する際、権限が不足する可能性
**対応**: ワークフローに`permissions`セクションを追加

```yaml
jobs:
  create-pr:
    permissions:
      contents: read
      pull-requests: write
```

### 2. null処理の修正 (Comment #2836403438)
**問題**: PRが存在しない場合、`--jq '.[0].number'`が`null`を返し、`[ -n "null" ]`が真になって誤動作

**詳細**:
- PRが存在しない場合、`gh pr list`は空配列`[]`を返す
- `.[0].number`で最初の要素にアクセスすると`null`が返される
- jqは`null`を文字列`"null"`として出力する
- シェルの`[ -n "null" ]`は文字列"null"が空でないため真となり、誤判定が発生

**対応**: jqの代替演算子`// empty`を使用して、nullの場合は空文字にする

```bash
PR_NUMBER=$(gh pr list --base main --head ${{ github.ref_name }} --json number --jq '.[0].number // empty' | tr -d '\n')
```

### 3. gh CLIインストールの削除 (Comment #2836403437)
**問題**: 不要なインストールステップ
**対応**: GitHub-hosted runnerには`gh`がプリインストールされているため、インストールステップは既に削除済み（現在のワークフローには存在しない）

### 4. Assigneeの自動設定 (Comment #2836403434)
**追加機能**: PRを作成したユーザーを自動的にアサインする

**対応**: `github.actor`を使用してプッシュしたユーザーをアサイン

```yaml
gh pr create \
  --assignee "${{ github.actor }}" \
  ...
```

**備考**: 以下の要件は対応しない
- `documentation`ラベルの自動付与 → 存在しないラベルが自動作成されてしまうため
- `Closes #N`の自動リンク → 対応Issueが存在しない場合があるため
- 日本語PRテンプレート形式の適用 → Issue側の記載が古いため

## 変更対象ファイル
- `.github/workflows/auto-pr-update-docs.yml`

## 実装ステップ

1. **権限セクションの追加**
   - `jobs.create-pr`に`permissions`を追加
   - `contents: read`と`pull-requests: write`を指定

2. **null処理の修正**
   - `Check for existing PR`ステップのjqクエリを修正
   - `// empty`を使用してnullを空文字に変換

3. **Assigneeの自動設定**
   - `gh pr create`と`gh pr edit`に`--assignee "${{ github.actor }}"`オプションを追加
   - プッシュしたユーザーが自動的にPRにアサインされる

## 検証方法

### 1. 構文チェック
```bash
# ワークフローファイルの構文チェック
gh workflow view auto-pr-update-docs
```

### 2. 新規PR作成のテスト
```bash
# 1. update-solo-dev-docsブランチに変更をプッシュ
git checkout -b update-solo-dev-docs
echo "test" >> test.md
git add test.md
git commit -m "test: PR #30対応テスト"
git push origin update-solo-dev-docs

# 2. ワークフロー実行を確認
gh run list --workflow=auto-pr-update-docs.yml

# 3. 作成されたPRを確認
gh pr list --head update-solo-dev-docs

# 4. PRの内容を確認
gh pr view <PR番号>
# - assigneeがプッシュしたユーザーに設定されているか確認
```

### 3. 既存PR更新のテスト
```bash
# 1. 同じブランチに追加の変更をプッシュ
echo "test2" >> test.md
git add test.md
git commit -m "test: 更新テスト"
git push origin update-solo-dev-docs

# 2. PRが更新されたことを確認
gh pr view <PR番号>

# 3. 本文が更新されていることを確認
```

### 4. エッジケースのテスト
- PRが存在しない場合（null処理が正しく動作するか）
- PRが既に存在する場合（更新処理が正しく動作するか）

## 成功基準
- [ ] 全てのCopilotレビューコメントに対応
- [ ] ワークフローが正常に実行される
- [ ] 新規PR作成時にassigneeが正しく設定される
- [ ] 既存PR更新時もassigneeが正しく設定される
- [ ] null処理が正しく動作し、誤判定が発生しない
