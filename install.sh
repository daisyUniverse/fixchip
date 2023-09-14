#!/bin/bash

# Please note that this is not anywhere near complete, and heavily work-in-progress, and also not tested. Will remove this line when I've implemented everything

echo "Step 0. Backup all system files that will be affected"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. HINT: The default password is 'chip' on a fresh image."
  exit
fi

mkdir /home/chip/.fixchip && cd /home/chip/.fixchip
cp /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
cp /etc/apt/preferences /etc/apt/preferences.bak
cp /etc/apt/sources.list /etc/apt/sources.list.bak

echo "\n\n >>> Step 1. Download latest tarball of filesystem changes from github or my site \n\n"

# Fails to get latest version tag for unknown reason.. will fix
# VER=$(curl --silent -qI https://github.com/daisyUniverse/chip/releases/latest | awk -F '/' '/^location/ {print  substr($NF, 1, length($NF)-1)}'); \
# wget -O /home/chip/.fixchip/fixchip.tar.gz https://github.com/daisyUniverse/chip/releases/download/$VER/fixchip.tar.gz

wget -O /home/chip/.fixchip/fixchip.tar.gz https://sh.universe.dog/fixchip.tar.gz

echo "\n\n >>> Step 2. untar the ball..\n\n"

tar -xzvf /home/chip/.fixchip/fixchip.tar.gz -C /home/chip/.fixchip

echo "\n\n >>> Step 3. Copy in apt configs\n\n"

cp /home/chip/.fixchip/etc/apt/sources.list /etc/apt/sources.list
cp /home/chip/.fixchip/etc/apt/preferences /etc/apt/preferences
cp /home/chip/.fixchip/etc/apt/apt.conf /etc/apt/apt.conf

echo "\n\n >>> Step 4. Apt update, apt upgrade, and then install required packages\n\n"

apt-get update && apt-get upgrade -y

echo "\n\n( git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https )\n\n"

apt-get install git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https -y

echo "\n\n >>> Step 5. Copy in dotfiles (xmodmap, xinitrc)\n\n"

cp /home/chip/.fixchip/home/chip/.XModmap /home/chip/.XModmap
cp /home/chip/.fixchip/home/chip/.Xinitrc /home/chip/.Xinitrc

echo "\n\n >>> Step 6. Run xinput-calibrator, and then copy in the new xorg.conf (ask user for ability to long-press)\n\n"

xinput_calibrator
read -p "\n\n ??? Would you like to enable long-press to right click? [Y/N]" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cp /home/chip/.fixchip/etc/X11/xorg-long-press.conf /etc/X11/xorg.conf
else
    cp /home/chip/.fixchip/etc/X11/xorg.conf /etc/X11/xorg.conf
fi

echo "\n\n >>> Step 7. Git-Clone chip-battery-status, run it's installer\n\n"

git clone https://github.com/editkid/chip-battery-status
cd chip-battery-status 
./install.sh
cd ..

echo "\n\n >>> Step 8. Ask user if they'd like to change the hostname, and if so, do that\n\n"

read -p "\n\n ??? Would you like to change the hostname? [Y/N]\n\n" -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "\n\n ??? What would you like your new hostname to be?"
  echo
  read newhostname
  sed -i "s/chip/$newhostname/g" /etc/hostname
  sed -i "s/chip/$newhostname/g" /etc/hosts
fi

# Options to explore:
# 1. Should I store all system files inside of the main script to keep it all contained?
# 2. How far should I take this? is a usable system okay, or should I include fun extras as well?
# 3. Should I consider mirroring the jfpossibilies repo myself for redundancy?
