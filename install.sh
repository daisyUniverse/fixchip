#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. HINT: The default password is 'chip' on a fresh image."
  exit
fi

echo -e "\n\n >>> Backup all system files that will be affected \n\n"
mkdir /home/chip/.fixchip && cd /home/chip/.fixchip
cp /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
cp /etc/apt/preferences /etc/apt/preferences.bak
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo -e "\n\n >>> Download latest tarball of filesystem changes from github or my site\n\n"

# Fails to get latest version tag for unknown reason.. will fix
# VER=$(curl --silent -qI https://github.com/daisyUniverse/chip/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'); \
# wget -O /home/chip/.fixchip/fixchip.tar.gz https://github.com/daisyUniverse/chip/releases/download/$VER/fixchip.tar.gz

wget -O /home/chip/.fixchip/fixchip.tar.gz https://sh.universe.dog/fixchip.tar.gz -q --show-progress

echo -e "\n\n >>> untar the ball..\n\n"

tar -xzvf /home/chip/.fixchip/fixchip.tar.gz -C /home/chip/.fixchip

echo -e "\n\n >>> Copy in apt configs\n\n"

cp /home/chip/.fixchip/etc/apt/sources.list /etc/apt/sources.list
cp /home/chip/.fixchip/etc/apt/preferences /etc/apt/preferences
cp /home/chip/.fixchip/etc/apt/apt.conf /etc/apt/apt.conf

echo -e "\n\n >>> Apt update, apt upgrade, and then install required packages\n\n"
apt-get update && apt-get upgrade -y
apt-get install git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https -y

echo -e "\n\n >>> Copy in dotfiles (xmodmap, xinitrc)\n\n"
cp /home/chip/.fixchip/home/chip/.XModmap /home/chip/.Xmodmap
cp /home/chip/.fixchip/home/chip/.Xinitrc /home/chip/.Xinitrc

echo -e "\n\n >>> Run xinput-calibrator, and then copy in the new xorg.conf\n\n"
xinput_calibrator
cp /home/chip/.fixchip/etc/X11/xorg.conf /etc/X11/xorg.conf

read -p " ??? Would you like to enable SSH? [Y/N]" -n 1 -r
echo; echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt-get install openssh-server -y
    systemctl enable sshd && systemctl start sshd
fi

echo -e "\n\n >>> Install chip-battery-status\n\n"
git clone https://github.com/editkid/chip-battery-status
cd chip-battery-status 
./install.sh
cd ..

echo -e "\n\n >>> Updating PICO-8 \n\n" # TODO Keep this in the system tarball
wget -O /home/chip/.fixchip/pico-8_0.2.5g_chip.zip www.lexaloffle.com/dl/chip/pico-8_0.2.5g_chip.zip --show-progress
unzip /home/chip/.fixchip/pico-8_0.2.5g_chip.zip -d /usr/lib

echo -e "\n\n >>> Updating libcurl \n\n" # Ditto
wget -O /usr/lib/pico-8/libcurl.so.3 https://raw.githubusercontent.com/mackemint/PocketCHIP-buster-update/main/assets/libcurl.so.3 --show-progress

echo -e "\n\n >>> Installing fixed PocketDesk \n\n" #...ditto
git clone https://git.nytpu.com/forks/PocketDesk
./PocketDesk/PocketDESK.sh

read -p " ??? Would you like to change the hostname? [Y/N]" -n 1 -r
echo; echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo; echo
  echo " ??? What would you like your new hostname to be?"
  echo; echo
  read newhostname
  sed -i "s/chip/$newhostname/g" /etc/hostname
  sed -i "s/chip/$newhostname/g" /etc/hosts
fi

# Options to explore:
# 1. Should I store all system files inside of the main script to keep it all contained?
# 2. How far should I take this? is a usable system okay, or should I include fun extras as well?
# 3. Should I consider mirroring the jfpossibilies repo myself for redundancy?
