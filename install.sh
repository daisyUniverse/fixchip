#!/bin/bash

# Please note that this is not anywhere near complete, and heavily work-in-progress, and also not tested. Will remove this line when I've implemented everything

# Step 0. Backup all system files that will be affected

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. HINT: The default password is 'chip' on a fresh image."
  exit
fi

mkdir ~/.fixchip && cd ~/.fixchip
cp /etc/X11/xorg.conf /etc/X11/xorg.conf.bak
cp /etc/apt/preferences /etc/apt/preferences.bak
cp /etc/apt/sources.list /etc/apt/sources.list.bak

# Step 1. Download latest tarball of filesystem changes from github or my site

# I still have to make the release...

# Step 2. untar the ball..

tar -xzvf fixchip.tar.gz 

# Step 3. Copy in apt configs

cp ~/.fixchip/etc/apt/sources.list /etc/apt/sources.list
cp ~/.fixchip/etc/apt/preferences /etc/apt/preferences
cp ~/.fixchip/etc/apt/apt.conf /etc/apt/apt.conf

# Step 4. Apt update, apt upgrade, and then install required packages

apt-get update && apt-get upgrade -y

# ( git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https )

apt-get install git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https -y

# Step 5. Copy in dotfiles (xmodmap, xinitrc)

cp ~/.fixchip/home/chip/.XModmap ~/.XModmap
cp ~/.fixchip/home/chip/.Xinitrc ~/.Xinitrc

# Step 6. Run xinput-calibrator, and then copy in the new xorg.conf (ask user for ability to long-press)

xinput_calibrator
read -p "Would you like to enable long-press to right click? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]] then
    cp ~/.fixchip/etc/X11/xorg-long-press.conf /etc/X11/xorg.conf
else
    cp ~/.fixchip/etc/X11/xorg.conf /etc/X11/xorg.conf
fi

# Step 7. Git-Clone chip-battery-status, run it's installer

git clone https://github.com/editkid/chip-battery-status
cd chip-battery-status 
./install.sh
cd ..

# Step 8. Ask user if they'd like to change the hostname, and if so, do that

read -p "Would you like to change the hostname? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]] then
  echo "What would you like your new hostname to be?"
  echo
  read newhostname
  sudo sed -i 's/chip/$newhostname/g' /etc/hostname
  sudo sed -i 's/chip/$newhostname/g' /etc/hosts
fi

# Options to explore:
# 1. Should I store all system files inside of the main script to keep it all contained?
# 2. How far should I take this? is a usable system okay, or should I include fun extras as well?
# 3. Should I consider mirroring the jfpossibilies repo myself for redundancy?
