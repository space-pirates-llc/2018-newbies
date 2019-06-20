# Setup

## 開発環境のセットアップ手順

### Without Docker

#### Requirements

- rbenv
- ndenv (or nodenv)
- MySQL 5.6+

#### Steps

1) git checkout 後 `.ruby-version` で定義された必要な Ruby のバージョンをインストールします。

```shell
$ rbenv install -s
# すでに該当バージョンがインストール済みの場合はスキップされます。
```

2) 念のため `.nod-version` で定義された必要な Node.js のバージョンをインストールします。

```shell
$ ndenv install -s
```

3) 環境構築のため、 `bin/setup` を実行します。

```shell
$ ./bin/setup
# 実行すると DB 内のデータがすべて削除されるため、
# 環境アップデート時は bin/update を実行すること。
```

##### うまく setup が実行できない場合

1. Ruby は正しいバージョンが入っているか確認しましょう
2. ローカルで立ち上がっている MySQL のバージョンは適切ですか？立ち上がっていますか？
  - 立ち上がっているが動かない場合
    - ポート番号やソケットファイルの位置を確認しましょう
    - MySQL に接続するユーザー名やポート名が正確か確認しましょう
3. その他の場合
  - メンターや講師に相談してください
  - 無根拠に環境をいじるとかえって状況が悪化する可能性があります

4) Rails の起動

```shell
$ bin/rails server  # サーバーの起動
$ bin/rails console # デバッグコンソール
$ bin/rails generate [GENERATOR] [OPTIONS] # ジェネレータの実行
```

5) 設定ファイルや Gemfile を書き換えた際、必ず反映させたい場合

```shell
$ bin/spring stop && bin/update
```


### With Docker

#### Requirements

- Docker
- Docker Compose

#### Steps

1) git checkout 後必要なイメージをビルドします。

```shell
$ docker-compose build
```

2) コンテナの立ち上げを行います。

```shell
$ docker-compose up
# バックグラウンドで実行させたい場合は docker-compose up -d
# その際は docker-compose down で停止
```

3) Rails の起動

```shell
$ docker-compose run rails bundle exec rails console # デバッグコンソール
$ docker-compose run rails bundle exec rails generate [GENERATOR] [OPTIONS] # ジェネレータの実行
```

4) MySQL に直に接続したい場合

docker-compose により立ち上がった Docker 内の MySQL は `3307` のホストポートにマッピングされています。

必要であれば 3307 に `root` ユーザーで空のパスワードを用いて接続することが可能です。
