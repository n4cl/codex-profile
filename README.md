# codex-profile

Codex の設定と skills を管理するリポジトリです。

## config 運用方針

`~/.codex/config.toml` には `projects."<path>".trust_level` のようなホスト固有情報が自動で追記されます。
このため、リポジトリの設定ファイルをシンボリックリンクで直接運用する方法は、差分汚染が起きやすく非推奨です。

推奨運用:

1. リポジトリの `.codex/config.toml` をベースとして使う
2. 実運用はローカルの `~/.codex/config.toml` で管理する
3. 共有したい変更だけをリポジトリへ手動反映する

## `~/.codex` への配布（シンボリックリンクなし）

このリポジトリの `.codex` 配下を、ローカルの `~/.codex` にコピー配布するスクリプトを用意しています。

```sh
./scripts/deploy-codex-profile.sh
```

変更内容だけ確認したい場合:

```sh
./scripts/deploy-codex-profile.sh --dry-run
```

スクリプトの挙動:

- リポジトリの `.codex` 配下のファイルを `~/.codex` に上書きコピー
- `codex` コマンドが見つからない場合は終了
- `~/.codex` が未作成の場合は終了（自動作成しない）
- 既存ファイルに差分がある場合は、上書き前に `~/.codex/.backup/<timestamp>/...` へ退避
- `~/.codex` 側の余剰ファイルは削除しない


## skills の管理方針

このリポジトリでは skills を次の 2 系統で管理します。

- 常用（グローバル適用してよい）: `.codex/skills/`
- 任意（必要時だけ導入）: `skills-catalog/`

`scripts/deploy-codex-profile.sh` は `.codex/` 配下を `~/.codex` に配布するため、
`.codex/skills/` にある skills はグローバルに適用されます。
常用ではない skills は `skills-catalog/` に置き、必要なときだけ個別導入します。

### 任意 skills の個別導入

一覧確認:

```sh
./scripts/install-skill.sh --list
```

導入:

```sh
./scripts/install-skill.sh <skill-name>
```

差分確認のみ:

```sh
./scripts/install-skill.sh --dry-run <skill-name>
```

## Context7 認証（OAuth）

このリポジトリの `.codex/config.toml` は Context7 の OAuth 認証を前提にしています。
API キーの `http_headers` / `env_http_headers` は使いません。

```toml
[mcp_servers.context7]
url = "https://mcp.context7.com/mcp"
```

必要に応じて初回だけ認証します。

```sh
codex mcp login context7
```
