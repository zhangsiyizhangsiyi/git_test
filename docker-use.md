
docker run -itd --name ubuntu ubuntu && docker exec -it ubuntu /bin/bash

mkdir /git && cd /git
apt -y update
apt -y install git gcc gdb
git init && git config --global user.name zhangxy
git config --global credential.helper cache
scp zhangsiyi@10.64.7.251:/Users/zhangsiyi/Desktop/nfs3-test-mac/git/github.com.cer .
git remote add  origin https://github.com/samba-team/samba.git
git fetch
git checkout master
apt -y install python3
apt -y install xsltproc
apt -y install   libxml-libxslt-perl
apt -y install   libxslt1-dev
apt -y install   libcups2-dev
apt -y install   libicu-dev
apt -y install   libglib2.0-dev
apt -y install   libtracker-sparql-3.0-dev
apt -y install  python3-dev
apt -y install   pkg-config  libgnutls28-dev
apt -y install   liblmdb-dev
apt -y install   flex
apt -y install   bison
apt -y install   libgpgme11-dev python3-gpg
apt -y install   cpanminus && cpanm Parse::Yapp::Driver
apt -y install   libjansson-dev
apt -y install   libarchive-dev
apt -y install   libacl1-dev
apt -y install   libldap2-dev
apt -y install   libpam-dev
apt -y install   libdbus-1-dev
apt -y install   python3-markdown
apt -y install   python3-dnspython
apt -y install   libc6-dev libpopt-dev libgpgme11-dev libgnutls28-dev libacl1-dev libldap2-dev libjansson-dev libarchive-dev
apt -y install   libtasn1-bin
apt -y install   libssl-dev
apt -y install   libncurses5-dev
apt -y install   libglusterfs-dev
apt -y install   xfslibs-dev
