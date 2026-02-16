# codex-profile

Codex の設定と skills を管理するリポジトリです。

## config 運用方針

`~/.codex/config.toml` には `projects."<path>".trust_level` のようなホスト固有情報が自動で追記されます。
このため、リポジトリの設定ファイルをシンボリックリンクで直接運用する方法は、差分汚染が起きやすく非推奨です。

推奨運用:

1. リポジトリの `.codex/config.toml` をベースとして使う
2. 実運用はローカルの `~/.codex/config.toml` で管理する
3. 共有したい変更だけをリポジトリへ手動反映する

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
