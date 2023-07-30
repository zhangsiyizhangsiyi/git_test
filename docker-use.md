# mac 访问 docker 域名时
# sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache

# docker stop samba && docker rm samba
docker run -itd --privileged  --name samba --hostname kersmb.com  ubuntu && \
    docker exec -it  --privileged samba /bin/bash
    
    docker run -itd --privileged  --name samba --network host --hostname kersmb.com  nsamba-new  /bin/zsh

docker stop samba && docker rm samba && \
    docker run -itd  --privileged --name samba --hostname kersmb.com  ubuntu && \
    docker exec -it --privileged  samba /bin/bash
# ifconfig eth0 down&& ifconfig eth0 192.168.1.14 netmask 255.255.255.0 && ifconfig eth0 up

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
\
mkdir /git && cd /git && apt -y update && apt -y install sed  git gcc gdb zsh curl vim  && git init && \
          git config --global user.name zhangxy &&\
          git config --global credential.helper cache  && \
git remote add  origin https://github.com/samba-team/samba.git && git fetch && git checkout master && git pull origin master &&\
        apt -y install python3 xsltproc  libxml-libxslt-perl libxslt1-dev  libcups2-dev  libicu-dev  libglib2.0-dev libsystemd-dev gcc-mingw-w64-x86-64 \
        libtracker-sparql-3.0-dev  python3-dev  pkg-config  libgnutls28-dev  liblmdb-dev  flex  bison  libgpgme11-dev python3-gpg \
        cpanminus && cpanm Parse::Yapp::Driver && \
        apt -y install   libjansson-dev  libarchive-dev  libacl1-dev  libldap2-dev  libpam-dev libdbus-1-dev libbsd-dev libkrb5-dev \
        python3-markdown python3-dnspython libc6-dev libpopt-dev libgpgme11-dev libgnutls28-dev libacl1-dev krb5-kdc krb5-admin-server \
        libldap2-dev libjansson-dev libarchive-dev libtasn1-bin libssl-dev libncurses5-dev libglusterfs-dev  xfslibs-dev krb5-user \
        libdmlc0   libdmlc-dev   libdmalloc5  libdmalloc-dev liburing-dev libfam-dev kmod selinux-utils apparmor  libdmapsharing-3.0-dev  && \
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
   echo 'export PATH="/usr/bin/setpriv:$PATH"' >> ~/.zshrc && chsh -s $(which zsh)  && source ~/.zshrc 


docker exec -it samba /bin/zsh

# scp zhangsiyi@10.64.7.251:/Users/zhangsiyi/Desktop/nfs3-test-mac/git/github.com.cer .



# 下面是 apt install安装

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
\
apt -y update && apt -y install sed git  zsh curl vim samba krb5-user krb5-config krb5-admin-server libpam-krb5  &&  \
    git init && git config --global user.name zhangxy && git config --global credential.helper cache &&\
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
   chsh -s $(which zsh)  && source ~/.zshrc
   
# 一些附加工具
apt -y install dnsutils iputils-ping net-tools ufw


# docker 和 mac宿主机的网络互连
自定义网络：
你还可以创建自定义的 Docker 网络，并将容器加入到该网络中。这样宿主机和容器都在同一个自定义网络中，从而它们可以直接通信。

docker network create my_custom_network
然后，启动容器时，将容器加入到该自定义网络：

docker run --network my_custom_network my_container
现在，宿主机和容器在 my_custom_network 中，可以相互通信。

# 两条可用的示例
docker run -itd --privileged  --name nsamba --network my_custom_network --hostname kersmb.com  nsamba-new  /bin/zsh
docker exec -it --privileged  nsamba /bin/zsh
