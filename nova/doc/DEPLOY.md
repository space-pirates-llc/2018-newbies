# Deployment

## Requirements

- `AWS_ACCESS_KEY_ID` : デプロイ可能なユーザーの IAM
- `AWS_SECRET_ACCESS_KEY` : デプロイ可能なユーザーの IAM

`.env` ファイルなどに書き込んでおけば使い回しが効く用に設計されています。各個人で利用するキーが違ってコミットされたくない場合は `.gitignore` に `.env` を追記してください。

## Steps

### 1) `bin/deploy` を実行

- `TEAM` の環境変数、もしくは `-t` によるチーム指定が必須です。
- `-r` もしくは `--revision` でデプロイするリビジョンを指定できます。
- 手元の git から生成するため、 push 不要です。

### 2) 待つ

だいたい 1, 2 分ほどでデプロイが完了します。
