
docker run -itd --name ubuntu ubuntu && docker exec -it ubuntu /bin/bash

mkdir /git && cd /git
apt -y update
apt -y install git gcc gdb
git config --global user.name zhangxy
git config --global credential.helper cache
scp zhangsiyi@10.64.7.251:/Users/zhangsiyi/Desktop/nfs3-test-mac/git/github.com.cer .
git init && git remote add  origin https://github.com/samba-team/samba.git
git fetch
