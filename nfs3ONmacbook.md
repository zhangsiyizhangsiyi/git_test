如果你想要共享文件夹并设置用户名和密码，可以按照以下步骤操作：

首先创建一个文件夹，例如在桌面上创建一个名为 "share" 的文件夹。

打开终端并输入以下命令，创建 /etc/exports 文件：

bash
Copy code
sudo touch /etc/exports
使用以下命令打开 /etc/exports 文件并添加共享文件夹的路径：

bash
Copy code
sudo nano /etc/exports
在文件的末尾添加以下内容：

bash
Copy code
/Users/你的用户名/Desktop/share -alldirs -mapall=你的用户名:staff localhost
其中，/Users/你的用户名/Desktop/share 是你要共享的文件夹的路径，-alldirs 表示共享文件夹中的所有文件和子目录，-mapall=你的用户名:staff 表示所有访问者都将被映射到你的用户名和staff组。

设置共享文件夹的权限，输入以下命令：

bash
Copy code
sudo chmod -R 777 /Users/你的用户名/Desktop/share
这将授予所有用户对共享文件夹的读写权限。

重启 nfs 服务，输入以下命令：

Copy code
sudo nfsd restart
使用以下命令为共享文件夹设置用户名和密码：

bash
Copy code
sudo dscl . -create /Users/nfsuser
sudo dscl . -passwd /Users/nfsuser yourpassword
sudo dscl . -append /Groups/staff GroupMembership nfsuser
其中，nfsuser 是你为共享文件夹创建的用户名，yourpassword 是你为该用户设置的密码。

现在你的共享文件夹已经设置好了，其他用户可以通过 nfs3 协议访问你的共享文件夹，并且需要使用你设置的用户名和密码进行身份验证。

要允许所有 IP 访问 NFS 服务，可以将导出选项中的 IP 地址替换为一个通配符“*”。具体而言，您可以这样配置 /etc/exports 文件：

bash
Copy code
/Users/zhangsiyi/Desktop/nfs3-test-mac  -alldirs -mapall=zhang:staff *

Exports list on localhost: 
返回内容为空
这通常意味着你的NFS共享没有正确配置或启动。你需要确保NFS服务正在运行，可以通过运行命令 sudo nfsd checkexports 来检查导出是否有任何错误。另外，确保你已经正确配置了 /etc/exports 文件，以指定要共享的目录和允许访问的主机。如果你刚刚更新了 /etc/exports 文件，则需要重新启动 NFS 服务，可以使用 sudo nfsd restart 命令。


在Fedora 37中访问Mac上NFS共享目录的示例配置：

安装NFS客户端
首先需要安装NFS客户端，可以通过以下命令在Fedora 37上安装：

Copy code
sudo dnf install nfs-utils
挂载NFS共享目录
可以使用以下命令将Mac上的NFS共享目录挂载到Fedora 37上：

bash
Copy code
sudo mount -t nfs localhost:/Users/zhangsiyi/Desktop/nfs3-test-mac /mnt/nfs

---

---

fedora 37中配置的 nfs3 服务，如何给 共享出去的目录，配置用户名和密码，使之能通过用户名密码访问？给出详细实力







要在Fedora 37中配置NFSv3服务，以便通过用户名和密码访问共享目录，可以按照以下步骤进行：

1. 安装nfs-utils和rpcbind软件包：

```
Copy code
sudo dnf install nfs-utils rpcbind
```

1. 创建一个需要共享的目录：

```
arduinoCopy code
sudo mkdir /home/shared
```

1. 修改共享目录的权限，确保它是可读写的：

```
bashCopy code
sudo chmod -R 777 /home/shared
```

1. 编辑/etc/exports文件，添加以下行：

```
lessCopy code
/home/shared *(rw,all_squash,anonuid=1000,anongid=1000,sec=sys:krb5:krb5i:krb5p)
```

这将允许任何主机以读写方式访问共享目录，并使用用户ID和组ID为1000。还将启用基于Kerberos的身份验证机制，允许使用sys、krb5、krb5i和krb5p安全级别进行安全访问。

1. 重启rpcbind和nfs-server服务：

```
Copy code
sudo systemctl restart rpcbind
sudo systemctl restart nfs-server
```

1. 创建一个新用户和密码，用于远程访问：

```
Copy code
sudo useradd remoteuser
sudo passwd remoteuser
```

1. 创建NFS用户文件：

```
bashCopy code
sudo touch /etc/nfsusers
```

1. 编辑/etc/nfsusers文件，将新用户添加到文件中：

```
Copy code
remoteuser
```

1. 编辑/etc/nfsmount.conf文件，添加以下行：

```
makefileCopy code
nfsuserdarg="-n 4"
```

这将启用nfsuserd守护进程，该进程将根据/etc/nfsusers文件中的信息，为NFS客户端分配用户ID和组ID。

1. 重启nfs-idmapd和nfs-secure服务：

```
Copy code
sudo systemctl restart nfs-idmapd
sudo systemctl restart nfs-secure
```

1. 在客户端上，使用以下命令挂载NFS共享目录：

```
rubyCopy code
sudo mount -t nfs -o sec=sys,username=remoteuser,password=<password> <NFS server IP>:/home/shared /mnt/shared
```

这将在客户端的/mnt/shared目录下挂载共享目录，并使用远程用户名和密码进行身份验证。

注意：为了使基于密码的身份验证机制工作，需要安装和配置NFSv4或更高版本的Kerberos。此外，为了提高安全性，建议使用基于SSH的端口转发或VPN等安全通信渠道，以便在NFS共享目录和客户端之间建立安全通信。

---

fedora 配置nfs3 能通过用户名密码，访问共享目录么？该如何配置，如何连接？给出详细示例



是的，您可以在 Fedora 中配置 NFSv3 共享目录，并启用基于用户名和密码的身份验证。以下是一些基本步骤：

1. 安装 nfs-utils 和 rpcbind 包。

   ```
   Copy code
   sudo dnf install nfs-utils rpcbind
   ```

2. 创建要共享的目录，并将其权限设置为所有用户可读写。

   ```
   bashCopy code
   sudo mkdir /mnt/nfs_share
   sudo chmod 777 /mnt/nfs_share
   ```

3. 编辑 /etc/exports 文件，添加要共享的目录和允许访问的客户端 IP 地址和访问权限。

   ```
   bashCopy code
   /mnt/nfs_share 192.168.1.0/24(rw,all_squash,anonuid=1000,anongid=1000)
   ```

   在这个示例中，我们将 /mnt/nfs_share 目录共享给 192.168.1.0/24 网络的客户端，并指定了访问权限。all_squash 选项将客户端的所有 UID 和 GID 映射为匿名 UID 和 GID。anonuid 和 anongid 选项指定了匿名 UID 和 GID 的值。

4. 重新加载 NFS 配置。

   ```
   cssCopy code
   sudo exportfs -a
   ```

5. 启动 nfs-server.service 服务。

   ```
   sqlCopy code
   sudo systemctl start nfs-server.service
   ```

6. 配置用户名和密码。在 /etc/passwd 文件中添加新的用户，然后为该用户设置密码。

   ```
   bashCopy code
   sudo useradd -m -s /bin/bash nfsuser
   sudo passwd nfsuser
   ```

7. 在客户端上挂载共享目录。

   ```
   rubyCopy code
   sudo mount -t nfs -o vers=3,proto=tcp,port=2049,username=nfsuser,password=password 192.168.1.10:/mnt/nfs_share /mnt/local_share
   ```

   在这个示例中，我们将 /mnt/nfs_share 目录从 192.168.1.10 服务器挂载到 /mnt/local_share 目录。请确保将 username 和 password 替换为实际的用户名和密码。

以上是基本的步骤，您可以根据需要进行调整和配置。

## 可用挂载命令，但是nfs4的

```shell
mount -t nfs -o sec=sys,user=root 192.168.20.135:/home/nfsuser/nfs3-test-fedora gghh
```



```
NFS服务本身并不具备用户身份验证的功能，而仅支持基于客户端IP进行认证。
是这样吗？nfs3支持用户身份验证么，nfs4用户身份验证么？
是的，NFS服务本身不具备用户身份验证的功能，而只支持基于客户端IP地址的认证。但是，NFS客户端可以在连接NFS服务器之前进行身份验证，以便NFS服务器能够识别并授权访问。

在NFS版本3中，用户身份验证通常是通过在NFS客户端和服务器之间使用RPCSEC_GSS进行完成的。RPCSEC_GSS是一种基于GSS-API的RPC安全机制，它提供身份验证和数据完整性和机密性保护。使用RPCSEC_GSS需要在NFS服务器和客户端之间配置和管理Kerberos服务和密钥。

在NFS版本4中，用户身份验证是内置在协议中的，使用NFSv4的客户端和服务器可以通过使用Kerberos v5进行身份验证，而无需使用额外的RPC安全机制。此外，NFSv4还提供了访问控制列表（ACL）和文件系统标签（FSAL）等功能，以提高安全性和可管理性。

```

```
nfs 服务本身并不具备用户身份验证的功能，而仅支持基于客户端IP进行认证。
是这样吗？
在NFSv3中，确实没有对用户进行身份验证的机制，因此只能通过基于客户端IP地址的方式进行认证。但在NFSv4中，加入了基于Kerberos的身份验证机制，可以对用户进行身份验证和授权。NFSv4也支持基于IP地址的认证方式，但Kerberos身份验证更加安全和灵活。因此，该说法只适用于NFSv3，对于NFSv4并不完全准确。
```



Fedora-mac   -->     mac
ip.addr == 192.168.20.124&&!mdns&&!arp&&!ssh
mount -t nfs 192.168.20.124:/Users/zhangsiyi/Desktop/nfs3-test-mac /mnt/nfs

Fedora-mac   -->   fedora-wlh
mount -t nfs  192.168.20.135:/home/nfsuser/nfs3-test-fedora gghh

mac   -->   fedora-wlh
Nfs manager
![image-20230418173448563](/Users/zhangsiyi/Library/Application Support/typora-user-images/image-20230418173448563.png)

192.168.20.135
/home/nfsuser/nfs3-test-fedora
/Users/zhangsiyi/Desktop/gghh

![image-20230418173600273](/Users/zhangsiyi/Library/Application Support/typora-user-images/image-20230418173600273.png)
