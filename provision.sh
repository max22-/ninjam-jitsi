#!/usr/bin/env bash

useradd ninjam
apt update
apt install git -y
git clone https://www-dev.cockos.com/ninjam/ninjam.git
apt install build-essential -y
make -C ninjam/ninjam/server
sudo cp ninjam/ninjam/server/ninjamsrv /usr/local/bin
sudo mkdir /etc/ninjam
cp /vagrant/ninjam.cfg /etc/ninjam
cp /vagrant/ninjam.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable ninjam
sudo systemctl start ninjam
