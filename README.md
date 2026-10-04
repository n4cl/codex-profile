# codex-profile

Codex の設定と skills を管理するリポジトリです。

## config 運用方針

`~/.codex/config.toml` には `projects."<path>".trust_level` のようなホスト固有情報が自動で追記されます。
このため、リポジトリの設定ファイルをシンボリックリンクで直接運用する方法は、差分汚染が起きやすく非推奨です。

このリポジトリをグローバル設定の管理元として使います。

1. グローバルに適用したい設定をリポジトリの `.codex/config.toml` で管理する
2. 配布スクリプトで `~/.codex/config.toml` に上書き反映する
3. Codex がホーム側に追記した設定も、次回配布時にはリポジトリの内容で置き換える

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

`config.toml` もファイル単位で置き換えます。設定項目のマージは行わないため、
ホーム側のファイルだけにあるモデル、MCP、プラグイン、プロジェクトの信頼設定などは、
配布後の `config.toml` には残りません。これは、管理元のグローバル設定に揃えるための
意図した動作です。置き換え前の設定はバックアップから確認・復元できます。

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

## Context7 の設定

このリポジトリの `.codex/config.toml` には Context7 の接続設定を含めていません。
Context7 を利用する場合は、各環境の `~/.codex/config.toml` で接続設定を管理し、
選択した接続方式に応じて認証してください。認証情報はこのリポジトリに保存しないでください。
ホーム側だけに追加した接続設定は、次回配布時に上書きされます。
