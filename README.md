# docker-php5.3.20
# dockerで開発環境構築の巻

## 前提
- dockerインストール済み
- docker-composeインストール済み

## 準備
- instantclient-basic-linux.x64-11.2.0.4.0.zip
- instantclient-sdk-linux.x64-11.2.0.4.0.zip
- instantclient-sqlplus-linux.x64-11.2.0.4.0.zip

を以下のように配置する。

```
.
├── README.md
├── docker-compose.yml
└── web
    ├── Dockerfile
    ├── httpd_conf
    │   └── httpd-10080.conf
    ├── instantclient-basic-linux.x64-11.2.0.4.0.zip
    ├── instantclient-sdk-linux.x64-11.2.0.4.0.zip
    ├── instantclient-sqlplus-linux.x64-11.2.0.4.0.zip
    ├── log
    ├── project
    │   ├── repo.list
    │   └── setup.sh
    └── share
        ├── create_mysql.sql
        └── tnsnames.ora
```

## コンテナのビルド
```
docker-compose build
```
## コンテナの起動
```
docker-compose up -d
```
## gitリポジトリのclone
```
cd ./web/project
sh setup.sh
```
## webサーバーでbash実行
```
docker exec -it `docker ps | grep docker_web | awk '{print $1}'` /bin/bash
```
## mysqlの必要なテーブルを作成(コンテナ内での作業)
```
mysql -h local-mysql5.6 -u root -p < /home/www/share/create_mysql.sql
```
## apache起動(コンテナ内での作業)
```
/etc/init.d/httpd restart
```

