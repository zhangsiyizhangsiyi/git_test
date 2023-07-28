# docker stop samba && docker rm samba
# docker run -itd --name samba ubuntu && docker exec -it samba /bin/bash
# docker stop samba && docker rm samba && docker run -itd --name samba ubuntu && docker exec -it samba /bin/bash

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
\
mkdir /git && cd /git && apt -y update && apt -y install sed  git gcc gdb zsh curl vim  && git init && \
          git config --global user.name zhangxy &&\
          git config --global credential.helper cache  && \
git remote add  origin https://github.com/samba-team/samba.git && git fetch && git checkout master && git pull origin master &&\
        apt -y install python3 xsltproc  libxml-libxslt-perl libxslt1-dev  libcups2-dev  libicu-dev  libglib2.0-dev \
        libtracker-sparql-3.0-dev  python3-dev  pkg-config  libgnutls28-dev  liblmdb-dev  flex  bison  libgpgme11-dev python3-gpg \
        cpanminus && cpanm Parse::Yapp::Driver && \
        apt -y install   libjansson-dev  libarchive-dev  libacl1-dev  libldap2-dev  libpam-dev libdbus-1-dev \
        python3-markdown python3-dnspython libc6-dev libpopt-dev libgpgme11-dev libgnutls28-dev libacl1-dev krb5-kdc krb5-admin-server \
        libldap2-dev libjansson-dev libarchive-dev libtasn1-bin libssl-dev libncurses5-dev libglusterfs-dev  xfslibs-dev krb5-user \
        libdmlc0   libdmlc-dev   libdmalloc5  libdmalloc-dev liburing-dev libfam-dev kmod selinux-utils apparmor  libdmapsharing-3.0-dev  && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
   chsh -s $(which zsh)  && source ~/.zshrc 


docker exec -it samba /bin/zsh

# scp zhangsiyi@10.64.7.251:/Users/zhangsiyi/Desktop/nfs3-test-mac/git/github.com.cer .

