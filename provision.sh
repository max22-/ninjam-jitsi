#!/usr/bin/env bash

# Générer le mot de passe crypté à l'aide de cette commande :
# mkpasswd -sha256
useradd -m -p "$6$yYuKAckgiH1DSaT1$pynCbNOuFlt.cyrrvrqLPMQZlI5B/AjdznpZ2PfvAXwYwDpFFjveDgVLE6YLnxz4LQPPgjkcYHdX/cNXI61Li0" -s /bin/bash ninjam
apt update
apt install git -y
git clone https://www-dev.cockos.com/ninjam/ninjam.git /home/ninjam/ninjam
apt install build-essential -y
make -C /home/ninjam/ninjam/ninjam/server
sudo cp /home/ninjam/ninjam/ninjam/server/ninjamsrv /usr/local/bin
cp /vagrant/ninjam.cfg /home/ninjam/
cp /vagrant/ninjam.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ninjam
sudo systemctl start ninjam
