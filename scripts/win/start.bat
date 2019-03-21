cd /d %~dp0
cd ..\..
vagrant box update --force
vagrant up

exit
