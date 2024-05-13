#!/bin/bash

USER_DIR=/home/me
DOTS_DIR=$USER_DIR/arch

echo "*"
echo "installing wm-related packages"
pacman -S --needed xorg-{server,xinit,xset} herbstluftwm kitty polybar rofi feh i3lock
echo "*"

echo "*"
echo "installing QOL packages"
pacman -S --needed autorandr exa qbittorrent btop parcellite flameshot brightnessctl
echo "*"

echo "*"
echo "installing fonts"
pacman -S --needed noto-fonts{,-cjk,-emoji,-extra} ttf-{jetbrains-mono-nerd,0xproto-nerd}
cp $DOTS_DIR/configs/polybar/flags_color_world.ttf /usr/share/fonts
echo "*"

echo "*"
echo "sound support"
pacman -Su --needed bluez bluez-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber pavucontrol
echo "*"

go () {
  rm -rf $USER_DIR/.config/$1
  ln -s $DOTS_DIR/configs/$1 $USER_DIR/.config
}

go "rofi"
go "kitty"
go "fish"
go "helix"
go "herbstluftwm"
go "autorandr"
go "polybar"

# X11 / low-end
ln -sf $DOTS_DIR/misc/config $USER_DIR/.ssh/
ln -sf $DOTS_DIR/misc/.gitconfig $USER_DIR/
ln -sf $DOTS_DIR/x11/user-dirs.dirs $USER_DIR/.config/
ln -sf $DOTS_DIR/x11/.xinitrc $USER_DIR/
ln -sf $DOTS_DIR/x11/.Xresources $USER_DIR/
cp -f $DOTS_DIR/x11/30-touchpad.conf /etc/X11/xorg.conf.d/
cp -f $DOTS_DIR/x11/00-keyboard.conf /etc/X11/xorg.conf.d/
cp -f $DOTS_DIR/x11/vconsole.conf /etc/

# qbittorrent
# ln -sf $DOTS_DIR/misc/qBittorrent.conf $USER_DIR/.config/qBittorrent

# if [ -d $USER_DIR/.config/Code/User/ ]; then
#   ln -sf $DOTS_DIR/configs/vscode/settings.json $USER_DIR/.config/Code/User/
# fi

# btop
ln -sf $DOTS_DIR/misc/btop.conf $USER_DIR/.config/btop/
