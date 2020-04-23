#!/usr/bin/env bash

function addService () {
    echo "Installation du service $1"
    cp /vagrant/$1.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable $1
    systemctl start $1
    systemctl is-active --quiet $1
    if [ $? -ne 0 ]
    then
        echo "Erreur : le service $1 n'a pas démarré."
        exit 1
    else
        echo "Le service $1 est actif"
    fi
}

export DEBIAN_FRONTEND=noninteractive

echo "Création de l'utilisateur ninjam"
useradd ninjam --groups audio --create-home

echo "apt update"
apt update

echo "Installation de git"
apt install git -y

echo "Installation du serveur ninjam"
git clone https://www-dev.cockos.com/ninjam/ninjam.git
apt install build-essential -y
make -C ninjam/ninjam/server
cp ninjam/ninjam/server/ninjamsrv /usr/local/bin
mkdir /etc/ninjam
cp /vagrant/ninjam.cfg /etc/ninjam


echo "Installation de PulseAudio"
apt install pulseaudio -y


echo "Installation de Jackd"
apt install jackd pulseaudio-module-jack -yq




echo "Installation du client ninjam faisant le lien avec jack"
apt install libncurses-dev libasound2-dev libjack-dev libvorbis-dev -y
make -C ninjam/ninjam/cursesclient
cp ninjam/ninjam/cursesclient/cninjam /usr/local/bin
apt install tmux -y
cp /vagrant/cninjam.sh /home/ninjam/cninjam.sh
chown ninjam:ninjam /home/ninjam/cninjam.sh
chmod u+x /home/ninjam/cninjam.sh



echo "Création d'une carte son virtuelle"
modprobe snd-dummy
echo "snd-dummy" >> /etc/modules    # pour que le module soit chargé à chaque démarrage par la suite

echo "Renommage de audio.conf.disable en audio.conf (pour le temps réel de jackd)"
mv /etc/security/limits.d/audio.conf.disabled /etc/security/limits.d/audio.conf

echo "Ajout des services"
addService ninjam
addService jackd
echo "Attente de quelques secondes..."
sleep 10
addService cninjam