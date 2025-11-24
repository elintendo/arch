#!/bin/bash

USER_DIR=/home/me
DOTS_DIR=$USER_DIR/.arch

echo "*"
echo "sound support"
pacman -Su --needed pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber sof-firmware
echo "*"

echo "*"
echo "installing wm-related packages"
pacman -S --needed hyprland waybar kitty wofi exa brightnessctl openssh
echo "*"

echo "*"
echo "installing fonts"
pacman -S --needed noto-fonts{,-cjk,-emoji,-extra} ttf-jetbrains-mono-nerd
echo "*"

go () {
  rm -rf $USER_DIR/.config/$1
  ln -s $DOTS_DIR/configs/$1 $USER_DIR/.config
  chown -h me:me $USER_DIR/.config/$1
}

go "kitty"
go "fish"
go "hypr"
go "nvim"
go "kanshi"
go "waybar"
go "wofi"

ln -sf $DOTS_DIR/misc/.gitconfig $USER_DIR/
chown -h me:me $USER_DIR/.gitconfig
