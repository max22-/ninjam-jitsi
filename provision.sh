#!/usr/bin/env bash

useradd ninjam
apt update
apt install git -y
git clone https://www-dev.cockos.com/ninjam/ninjam.git
apt install build-essential -y
make -C ninjam/ninjam/server
cp ninjam/ninjam/server/ninjamsrv /usr/local/bin
mkdir /etc/ninjam
cp /vagrant/ninjam.cfg /etc/ninjam
cp /vagrant/ninjam.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable ninjam
systemctl start ninjam

# PulseAudio
echo "Installation de PulseAudio"
apt install pulseaudio -y

# Jackd
echo "Installation de Jackd"
DEBIAN_FRONTEND=noninteractive apt install jackd pulseaudio-module-jack -yq

# Client faisant le lien entre ninjam et jack
apt install libncurses-dev libasound2-dev libjack-dev libvorbis-dev -y
make -C ninjam/ninjam/cursesclient
cp ninjam/ninjam/cursesclient/cninjam /usr/local/bin