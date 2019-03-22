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
scripts/win/start.bat をダブルクリック
# Mac OSXの場合
scripts/mac/start.command をダブルクリック
```

## 仮想マシンの終了
```
# Windowsの場合
scripts/win/stop.bat をダブルクリック
# Mac OSXの場合
scripts/mac/stop.command をダブルクリック
```

## 仮想マシンの再起動
```
# Windowsの場合
scripts/win/restart.bat をダブルクリック
# Mac OSXの場合
scripts/mac/restart.command をダブルクリック
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
# Ansible関連
ansible用の暗号化のしかた
```
# 暗号化したいファイルを暗号化
ansible-vault encrypt /app/panic0/provision/vars/crypt_vars.yml --vault-pass /tmp/.ansible_vault_pass
# 暗号化されたファイルの内容を復号化して表示
ansible-vault view /app/panic0/provision/vars/crypt_vars.yml --vault-pass /tmp/.ansible_vault_pass
# 暗号化されたファイルを復号化
ansible-vault decrypt /app/panic0/provision/vars/crypt_vars.yml --vault-pass /tmp/.ansible_vault_pass

# プレイブックを実行する時に--vault-passを指定してパスワードファイルを指定するとkey入力無しで実行可能
ansible-playbook -l dev_local -i provision/inventory/default.yml provision/base_setting.yml --vault-pass /tmp/.ansible_vault_pass
```

Ansible Playbookをシェルから実行する
```
# VM環境向け
cd /app/panic0/ && sudo ansible-playbook -l dev_local -i provision/inventory/default.yml provision/base_setting.yml --vault-pass /tmp/.ansible_vault_pass
cd /app/panic0/ && sudo ansible-playbook -l dev_local -i provision/inventory/default.yml provision/service_start.yml --vault-pass /tmp/.ansible_vault_pass

# 本番環境向け
cd /app/panic0/ && sudo ansible-playbook -l prd -i provision/inventory/default.yml provision/base_setting.yml --vault-pass /tmp/.ansible_vault_pass
cd /app/panic0/ && sudo ansible-playbook -l prd -i provision/inventory/default.yml provision/service_start.yml --vault-pass /tmp/.ansible_vault_pass
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
