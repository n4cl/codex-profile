# Optional Skills Catalog

`skills-catalog/` は「常用ではない skills」の保管場所です。

- ここに置いた skill は自動では `~/.codex` に配布されません
- 必要なときだけ `scripts/install-skill.sh <skill-name>` で導入します

## Structure

各 skill は次のように 1 ディレクトリで管理します。

```text
skills-catalog/
  <skill-name>/
    SKILL.md
    ...
```

`<skill-name>` は `scripts/install-skill.sh` で指定する名前です。
