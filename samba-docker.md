
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


