cd /d %~dp0
cd ..\..
vagrant halt
vagrant box update --force
vagrant up
exit
