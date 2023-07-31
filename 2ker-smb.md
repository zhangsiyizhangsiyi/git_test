编辑 /etc/hostname 文件：在终端中使用以下命令来编辑 /etc/hostname 文件，将其中的主机名设置为 kersmb.com。

sudo nano /etc/hostname
在编辑器中，将主机名修改为 kersmb.com，然后保存并关闭文件。请确保只有一行内容，表示新的主机名。

编辑 /etc/hosts 文件：使用以下命令来编辑 /etc/hosts 文件，将其中的 127.0.1.1 行的主机名也设置为 kersmb.com。

sudo nano /etc/hosts
在编辑器中找到 127.0.1.1 行，并将其修改为：
127.0.1.1    kersmb.com
保存并关闭文件。

重启计算机：为了使更改生效，请在终端中输入以下命令重启计算机。
sudo reboot

apt -y install sed && sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g' /etc/apt/sources.list && \
\
apt -y update && apt -y install sed git  zsh curl vim samba krb5-user krb5-config krb5-admin-server libpam-krb5  &&  \
    git init && git config --global user.name zhangxy && git config --global credential.helper cache &&\
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
   chsh -s $(which zsh)  && source ~/.zshrc

apt -y install dnsutils iputils-ping net-tools iproute2

# 本文是 apt 安装 ker smb

ubuntu安装samba，配置krb5集成给samba，samba不需在Linux系统中实现Windows域的用户和组的映射，Kerberos的网络域名命名为 kersmb.com，
服务器命名为 kersmb.server.com，为 Samba 创建一个单独的 Kerberos 用户，命名为 ker-sam-user, 要求samba只能通过kerberos配置的用户名密码登陆，
samba的共享目录是/samba-share 给我详细步骤
ChatGPT
为在Ubuntu上安装Samba并配置Kerberos集成，同时创建名为ker-sam-user的单独Kerberos用户，并要求Samba只能通过Kerberos配置的用户名密码登录，按照以下详细步骤操作：

步骤1：安装Samba和Kerberos软件包

在终端中运行以下命令来安装Samba和Kerberos软件包：

bash
Copy code
sudo apt update
sudo apt install samba krb5-user krb5-config krb5-admin-server libpam-krb5
在安装过程中，您将被要求输入Kerberos领域（Realm）的名称，按照您的要求设置为kersmb.com。
您还需要设置Kerberos服务器主机的FQDN（Fully Qualified Domain Name），按照您的要求设置为kersmb.server.com。

//----------------------------------------------------
# rm -rf /var/lib/krb5kdc/*
# kdb5_util create -r KERSMB.COM -s
kdb5_util create -s
service krb5-kdc start && vim /etc/krb5kdc/kadm5.acl &&  chmod 644 /etc/krb5kdc/kadm5.acl && service krb5-admin-server start

        */admin@KERSMB.COM *
//----------------------------------------------------
生成主机密钥表：
sudo ktutil
ktutil: add_entry -password -p host/kersmb.server.com@KERSMB.COM -k 1 -e aes256-cts-hmac-sha1-96
ktutil: wkt /etc/krb5.keytab
ktutil: quit
//--------//以上几行待验证

步骤2：配置Kerberos服务器

运行以下命令来配置Kerberos服务器：

bash
Copy code
sudo krb5_newrealm
在配置过程中，您需要输入Kerberos管理员（KDC）的密码。请记住这个密码，因为它将用于管理Kerberos数据库。

步骤3：创建Samba使用的Kerberos用户

运行以下命令来创建名为ker-sam-user的Kerberos用户，供Samba使用：

bash
Copy code
sudo kadmin.local -q "addprinc ker-sam-user@kersmb.com"
在这里，我们在kersmb.com领域中创建了一个名为ker-sam-user的Kerberos用户，用于Samba服务。

步骤4：配置Samba

编辑Samba配置文件 /etc/samba/smb.conf，并添加以下内容来启用Kerberos认证和限制登录方式：

[global]
    workgroup = WORKGROUP
    realm = KERSMB.COM
    security = ads
    encrypt passwords = yes
    dedicated keytab file = /etc/krb5.keytab
    kerberos method = secrets and keytab
    map to guest = Bad User
    restrict anonymous = 2
    server string = Samba Server %v
    log file = /var/log/samba/log.%m
    max log size = 1000
    interfaces = eth0
    bind interfaces only = yes

[samba-share]
    path = /samba-share
    valid users = ker-sam-user@kersmb.com
    read only = no
    create mask = 0777
    directory mask = 0777
请将WORKGROUP替换为您的工作组名称，将KERSMB.COM替换为您的Kerberos领域名称。

在[global]段中，restrict anonymous = 2的配置将限制匿名访问，valid users = ker-sam-user@kersmb.com的配置将限制只有ker-sam-user用户可以登录Samba。

步骤5：将计算机加入Kerberos领域

运行以下命令将Ubuntu计算机加入Kerberos领域：
//-----> apt -y install dnsutils iputils-ping net-tools
sudo net ads join -U ker-sam-user@kersmb.com
您将被要求输入Kerberos用户ker-sam-user的密码。
    如果你目前只有一台Ubuntu设备，并且希望在该设备上搭建Kerberos领域（单机模式），那么运行 sudo net ads join 命令是不正确的，
    因为该命令是用于将Ubuntu设备加入到现有的Windows域中。

service krb5-kdc start
service krb5-admin-server start

确保Kerberos服务器正在运行，并验证配置是否正确：
    sudo kadmin.local
在 kadmin.local 提示符下，尝试列出已创建的Kerberos用户：
    listprincs

步骤6：重启Samba服务

运行以下命令来重启Samba服务以应用配置更改：

sudo service smbd restart

# 修改/etc/krb5.conf 指定krb服务对应的ip
vim /etc/krb5.conf
[realms]
        kersmb.com = {
                kdc = 172.17.0.2
                admin_server = 172.17.0.2
        }
//-----------------------------------------------------------------------------

步骤7：测试Kerberos认证

使用以下命令测试Kerberos认证：

bash
Copy code
kinit ker-sam-user@kersmb.com
您将被要求输入ker-sam-user的密码。如果一切正常，Kerberos将为该用户提供一张票证，表示身份验证成功。

步骤8：测试Samba共享

现在，您应该能够通过Samba访问共享目录。首先，确保您在Samba配置文件中定义了共享目录，并且已经设置了/samba-share的共享目录。然后，运行以下命令来验证访问：

bash
Copy code
smbclient //your_samba_server_hostname/samba-share -k
请将your_samba_server_hostname替换为运行Samba的计算机的主机名。如果一切正确，您应该可以无需输入密码直接访问共享目录。

以上是在Ubuntu上安装Samba并配置Kerberos集成的详细步骤，并创建了名为ker-sam-user的单独Kerberos用户，并要求Samba只能通过Kerberos配置的用户名密码登录。根据您的需求，这样的配置将提供Kerberos认证的功能，同时限制了Samba的访问权限。请注意，配置Kerberos和Samba集成可能因网络和域设置而异，确保根据您的实际环境进行相应的调整。如果您有特定需求或有其他问题，请查阅相关文档和资源以获得更多帮助。



# macos 中 krb5 的krb5.conf 
vim /usr/local/Cellar/krb5/1.21.1/share/examples/krb5/krb5.conf

# 重启krb5 服务
service krb5-kdc start;service krb5-admin-server start
