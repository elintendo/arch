#!/bin/bash

USER_DIR=/home/me
DOTS_DIR=$USER_DIR/arch

foo () {
  rm -rf $USER_DIR/.config/$1
  ln -s $DOTS_DIR/configs/$1 $USER_DIR/.config
}

foo "rofi"
foo "kitty"
foo "fish"
foo "helix"
foo "awesome"
foo "autorandr"
foo "mpd"
foo "ncmpcpp"

if [ -d $USER_DIR/.config/Code/User/ ]; then
  ln -sf $DOTS_DIR/configs/vscode/settings.json $USER_DIR/.config/Code/User/
fi

ln -sf $DOTS_DIR/misc/.gitconfig $USER_DIR/
ln -sf $DOTS_DIR/x11/user-dirs.dirs $USER_DIR/.config/
ln -sf $DOTS_DIR/x11/.xinitrc $USER_DIR/
ln -sf $DOTS_DIR/misc/config $USER_DIR/.ssh/

# qbittorrent
ln -sf $DOTS_DIR/misc/qBittorrent.conf $USER_DIR/.config/qBittorrent

# btop
ln -sf $DOTS_DIR/misc/btop.conf $USER_DIR/.config/btop/

cp -f $DOTS_DIR/x11/30-touchpad.conf /etc/X11/xorg.conf.d/
cp -f $DOTS_DIR/x11/00-keyboard.conf /etc/X11/xorg.conf.d/
cp -f $DOTS_DIR/x11/vconsole.conf /etc/
