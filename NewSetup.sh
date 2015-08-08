#!/bin/bash
#My setup script for minimal use of Ubuntu Server as desktop os
#Setup wireless interfaces
read -p "Enter SSID: " SSID
read -p "Enter PSK: " PSK

sudo tee /etc/wpa_supplicant/wpa_supplicant.conf <<EOL
ctrl_interface=/run/wpa_supplicant
EOL

wpa_passphrase $SSID $PSK | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf

sudo tee /etc/network/interfaces <<EOL
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
pre-up wpa_supplicant -Dnl80211 -iwlan0 -B -c/etc/wpa_supplicant/wpa_supplicant.conf
post-down killall -q wpa_supplicant
EOL

#restart networking
sudo ifdown -a && sudo ifup -a

# Update apt
sudo apt-get update && apt-get upgrade

# Install some packages
binaries=(
    xorg
    i3
    xfce4-terminal
    build-essential
    openvpn
    ffmpeg
    git
    emacs24
    markdown
    pandoc
    imagemagick
    aspell
    youtube-dl
    chromium-browser
    vlc
    transmission
    python3-pip
    gnupg
    pass
    unzip
    emacs-goodies-el
)

sudo apt-get install ${binaries[@]}

# Grab virtualenv for python development
sudo pip3 install virtualenv

#grab my dotfiles
git clone https://github.com/MarcScott/dotfiles.git
ln -s ~/dotfiles/.emacs.d ~/.emacs.d
ln -s ~/dotfiles/.emacs ~/.emacs
ln -s ~/dotfiles/.i3 ~/.i3
ln -s ~/dotfiles/.bashrc ~/.bashrc

#Make i3 start with X
echo 'exec i3' > ~/.xinitrc

#Start X
startx
