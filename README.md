# 目的
1. 個人開発のスマホアプリのWEBAPIサーバー(Django)
1. GCPのStackDriverへログ集積のためのログ中継サーバー

## 環境構築
### (必須) 仮想化ソフトの導入
Windowsの場合
```
# PowerShellを管理者権限で開いて実行
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# 必要なソフトのインストール
choco install -y sourcetree
choco install -y virtualbox
choco install -y vagrant
```

Mac OSXの場合
```
# home brewのインストール
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 必要なソフトのインストール
homebrew cask install sourcetree
homebrew cask install virtualbox
homebrew cask install vagrant
```

#### 仮想マシンの起動
```
# Windowsの場合
bin/win/start.bat をダブルクリック
# Mac OSXの場合
bin/mac/start.command をダブルクリック
```

## 仮想マシンの終了
```
# Windowsの場合
bin/win/stop.bat をダブルクリック
# Mac OSXの場合
bin/mac/stop.command をダブルクリック
```

## 仮想マシンの再起動
```
# Windowsの場合
bin/win/restart.bat をダブルクリック
# Mac OSXの場合
bin/mac/restart.command をダブルクリック
```

## 仮想マシンにSSHでアクセスする
```
# Windowsの方
sshクライアントからvm.panic0.test へuser:vagrant password:vagrantでログインする
# Mac OSXの方は下記コマンドで　password:vagrantでログインする
ssh vagrant@vm.panic0.test 
```

## DDLを作成してコンテナでテストしたい場合にコンテナ内のpostgresに接続する方法
```
# rootユーザーになる
sudo su -
# postgresに接続
docker exec -it postgres bash -c "psql -d panic0_db  -h postgres -p 5432 -U postgres"
```

### gunicorn再読み込み(djangoの変更を読み込みたいとき)
```
docker exec -it django pgrep gunicorn
docker exec -it django kill -HUP [↑で確認した番号]
```

# vagrantでやっているansibleの手実行
```
ansible-playbook -l dev_local -i provision/hosts/panic0.toshi.click.yml provision/01_dev.yml
ansible-playbook -l dev_local -i provision/hosts/panic0.toshi.click.yml provision/02_dev_service.yml
```

# GCP はswap領域がないので作る
```
# 2GBのスワップ領域を作成する
dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

vi /etc/fstab
追記--------
/swapfile       swap            swap        defaults        0       0
```
