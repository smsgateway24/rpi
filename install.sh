#!/bin/bash

echo "Input your smsgateway24 login"
read LOGIN
echo "Input your smsgateway24 password"
read -s PASS


curl -fsSL https://get.docker.com -o get-docker.sh
apt list --installed |grep docker-ce/ || bash ./install-docker.sh
apt list --installed |grep usb-modeswitch/ || apt-get install --assume-yes usb-modeswitch
systemctl enable docker
systemctl start docker

docker container stop smsgw24
docker container rm smsgw24
docker run -d --restart unless-stopped --env LOGIN=${LOGIN} --env PASS=${PASS} --name smsgw24  filimon43g/smsgateway24:huawei-1.0

sed -i "s/DisableSwitching=10/DisableSwitching=0/g" /etc/usb_modeswitch.conf
cp huawei.cfg /etc/usb_modeswitch.d/huawei.cfg

usb_modeswitch -c /etc/usb_modeswitch.d/huawei.cfg
