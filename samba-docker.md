
docker pull dperson/samba

docker run -it -d \
    --name samba \
    -p 139:139 -p 445:445 \
     -v /smb-share:/smb-share \
     --user $(id -u):$(id -g) \
     dperson/samba \
     -s "smb-share;/smb-share;yes;no;yes;all;all;all"

docker exec -it samba /bin/bash

useradd smb-share

smbpasswd -a smb-share

docker stop samba

docker rm samba


win10 访问 Ubuntu 的 samba 时 ，问题解决 :
    https://www.cnblogs.com/harry66/p/12609184.html#:~:text=Windows%E5%BE%BD%E6%A0%87%2BR%20%E5%9C%A8%E5%BC%B9%E5%87%BA%E7%9A%84%E8%BF%90%E8%A1%8C%E7%AA%97%E5%8F%A3%E4%B8%AD%E8%BE%93%E5%85%A5%20%5Cip%20%E5%8D%B3%E5%8F%AF%E8%AE%BF%E9%97%AE%E3%80%82,%E5%A6%82%5C192.168.182.188%2C%E8%BE%93%E5%85%A5samba%E7%94%A8%E6%88%B7%E5%90%8D%E5%8F%8A%E5%AF%86%E7%A0%81%E8%AE%BF%E9%97%AE%E5%8D%B3%E5%8F%AF%E7%9C%8B%E5%88%B0%E5%85%B1%E4%BA%AB%EF%BC%8C%E7%84%B6%E5%90%8E%E5%B0%B1%E5%8F%AF%E4%BB%A5%E5%9C%A8Linux%E7%B3%BB%E7%BB%9F%E4%B8%8EWindows%E7%B3%BB%E7%BB%9F%E7%9B%B4%E6%8E%A5%E8%BF%9B%E8%A1%8C%E6%96%87%E4%BB%B6%E5%85%B1%E4%BA%AB%E4%BA%86%20Win%2BR%3A%E5%9C%A8%E5%BC%B9%E5%87%BA%E7%9A%84%E8%BF%90%E8%A1%8C%E7%AA%97%E5%8F%A3%E4%B8%AD%E8%BE%93%E5%85%A5ip%20%28%E5%9C%A8ubuntu%E4%B8%AD%E7%94%A8ifconfig%E6%9F%A5%E7%9C%8Bip%29%E5%8D%B3%E5%8F%AF%E8%AE%BF%E9%97%AE%E3%80%82%20%E5%A6%82%E4%B8%8B%E5%9B%BE%E8%BE%93%E5%85%A5samba%E7%94%A8%E6%88%B7%E5%92%8C%E5%AF%86%E7%A0%81%E5%B0%B1%E8%83%BD%E7%9C%8B%E5%88%B0%E5%85%B1%E4%BA%AB%E7%9A%84%E7%9B%AE%E5%BD%95%E4%BA%86%E3%80%82

    https://zhuanlan.zhihu.com/p/164721714

    https://blog.csdn.net/Ciellee/article/details/91048285
