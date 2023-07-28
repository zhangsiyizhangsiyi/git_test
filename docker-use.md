# docker stop ubuntu && docker rm ubuntu

docker run -itd --name ubuntu ubuntu && docker exec -it ubuntu /bin/bash

mkdir /git && cd /git && apt -y update && apt -y install git gcc gdb && git init \
          && git config --global user.name zhangxy &&\
          git config --global credential.helper cache 

# scp zhangsiyi@10.64.7.251:/Users/zhangsiyi/Desktop/nfs3-test-mac/git/github.com.cer .

git remote add  origin https://github.com/samba-team/samba.git && git fetch && git checkout master &&\
        apt -y install python3 xsltproc  libxml-libxslt-perl libxslt1-dev  libcups2-dev  libicu-dev  libglib2.0-dev \
        libtracker-sparql-3.0-dev  python3-dev  pkg-config  libgnutls28-dev  liblmdb-dev  flex  bison  libgpgme11-dev python3-gpg \
        cpanminus && cpanm Parse::Yapp::Driver && \
        apt -y install   libjansson-dev  libarchive-dev  libacl1-dev  libldap2-dev  libpam-dev libdbus-1-dev \
        python3-markdown python3-dnspython libc6-dev libpopt-dev libgpgme11-dev libgnutls28-dev libacl1-dev \
        libldap2-dev libjansson-dev libarchive-dev libtasn1-bin libssl-dev libncurses5-dev libglusterfs-dev  xfslibs-dev \
        libdmlc0   libdmlc-dev   libdmalloc5  libdmalloc-dev liburing-dev libfam-dev
