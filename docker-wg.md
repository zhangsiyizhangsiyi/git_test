
 docker run -itd  --privileged --name samba  ubuntu &&     docker exec -it --privileged  samba /bin/bash

# 容器内部

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
mkdir /git && cd /git && apt -y update && apt -y install sed language-pack-zh-hans &&\
apt -y install libterm-readline-gnu-perl  dnsutils iputils-ping net-tools ufw iproute2 lsof resolvconf &&\
mv /var/lib/dpkg/info/resolvconf.* /tmp/ && apt -y update && apt -y install resolvconf &&
echo "export LANG=zh_CN.UTF-8" >> ~/.bashrc && source ~/.bashrc &&\
apt -y install wireguard

# 开启ipv4流量转发
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p

# 创建并进入WireGuard文件夹
mkdir -p /etc/wireguard && chmod 0777 /etc/wireguard
cd /etc/wireguard
umask 077

# 生成服务器和客户端密钥对
wg genkey | tee server_privatekey | wg pubkey > server_publickey
wg genkey | tee client_privatekey | wg pubkey > client_publickey

##生成服务端的配置文件
vim /etc/wireguard/wg0.conf

[Interface]
PrivateKey = $(cat server_privatekey) # 填写本机的privatekey 内容
Address = 10.0.8.1/32
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 50814 # 注意该端口是UDP端口
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey =  $(cat client_publickey)  # 填写对端的publickey 内容
AllowedIPs = 10.0.8.10/32 
# " > wg0.conf
# 设置开机自启
systemctl enable wg-quick@wg0
# 重要！如果名字不是eth0, 以下PostUp和PostDown处里面的eth0替换成自己服务器显示的名字
# ListenPort为端口号，可以自己设置想使用的数字
# 以下内容一次性粘贴执行，不要分行执行

##生成客户端的配置文件
vim  /etc/wireguard/client.conf

[Interface]
  PrivateKey = $(cat client_privatekey)  # 填写本机的privatekey 内容
  Address = 10.0.8.10/24
  DNS = 8.8.8.8
  MTU = 1420

[Peer]
  PublicKey = $(cat server_publickey)  # 填写对端的publickey 内容
  Endpoint = server公网的IP:50814
  AllowedIPs = 0.0.0.0/0, ::0/0
  PersistentKeepalive = 25
# " > client.conf
# 注：文件在服务端配好了可以下载下来传到客户端



# 关停容器
docker stop samba && docker rm samba
