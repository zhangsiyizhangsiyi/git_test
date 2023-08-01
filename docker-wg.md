
 docker run -itd -p 50814:50814/udp  --privileged --name samba  ubuntu &&     docker exec -it --privileged  samba /bin/bash

# 阿里云部署docker
 snap install docker && docker && docker pull ubuntu

# 容器内部

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
mkdir /git && cd /git && apt -y update && apt -y install vim  sed language-pack-zh-hans &&\
apt -y install libterm-readline-gnu-perl  dnsutils iputils-ping net-tools ufw iproute2 lsof resolvconf ;
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

# 查看当前的路由表
ip route show






似乎你正在尝试在 macOS 上的 Docker 中运行 WireGuard 容器，并出现了 IPv6 相关的问题。

在 macOS 上运行 Docker，你不直接访问底层的 Linux 内核，而是使用 Docker Desktop 应用程序来管理容器。因此，与在 Linux 系统上运行的 Docker 不同，macOS 上的 Docker 不支持直接通过宿主机添加 IPv6 路由。这就解释了为什么出现了 "Error: IPv6 is disabled on nexthop device." 错误。

目前在 macOS 上，Docker 官方版本并不支持直接运行 WireGuard 容器来实现 VPN 功能。虽然 macOS 有对 IPv6 的支持，但是 Docker Desktop 环境不支持直接在容器中添加 IPv6 路由。

如果你想在 macOS 上使用 WireGuard VPN，可能需要使用其他方法，比如在 macOS 主机上直接配置 WireGuard。你可以在 macOS 上安装原生的 WireGuard 应用程序，并通过配置文件来运行 WireGuard VPN。


