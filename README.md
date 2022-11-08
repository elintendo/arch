# arch

### HOW TO
1. `rmmod pcspkr` — turn off beep sound
2. `setfont /usr/share/kbd/consolefonts/ter-132n` — turn on big font in console
3. `iwctl`, `station wlan0 scan`, `station wlan0 connect`
4. `cfdisk` — make two partitions: EFI (1Gb) and Linux filesystem
5. `mkfs.ext4 /dev/<linux part>` and `mkfs.fat -F32 /dev/<efi part>`
6. `mkdir /mnt/boot` then, `mount /dev/<linux part> /mnt` and `mount /dev/<efi> /mnt/boot`
7. `pacstrap /mnt linux linux-firmware base base-devel sudo neovim grub efibootmgr networkmanager bspwm sxhkd xorg-server fish xorg-xinit ttf-jetbrains-mono kitty git openssh stow xclip`
8. `genfstab -U /mnt >> /mnt/etc/fstab`
8. `cp /usr/share/kbd/consolefonts/ter-132n /mnt/usr/share/`
9. `arch-chroot /mnt` 
10. `echo intent > /etc/hostname`
11. edit /etc/hosts
12. `passwd`
13. `useradd -mG wheel intent` then `passwd intent`
14. `chsh -s /usr/bin/fish intent`
15. uncomment in /etc/sudoers:  `%wheel ALL=(ALL) ALL`
16. `mount /dev/sda1 /boot/efi`, then `grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi`, then `grub-mkconfig -o /boot/grub/grub.cfg`
17. cp /etc/X11/xinit/xinitrc ~/.xinitrc
18. `exec bspwm` in .xinitrc

after restart:
1. setup internet: `systemctl enable/start NetworkManager`, then `*sudo* nmcli device wifi connect <> --ask` 
2. setup github: `ssh-keygen -t ed25519 -C "your_email@example.com"`, then `ssh-add ~/.ssh/id_ed25519`, then add in github
3. `sudo pacman -S ttf-font-awesome lsd rofi starship firefox vscode xbindkeys xdg-user-dirs flameshot feh xorg-xsetroot telegram-desktop gnumeric backlight_control (aur)`
4. stow everything!
5. `git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim`, then `:PackerSync`
6. `sudo pacman -S pulseaudio alsa-utils`, then toggle Master in alsamixer, turn on Speaker
7. `echo blacklist pcspkr >> /etc/modprobe.d/nobeep.conf`
8. `localectl set-x11-keymap --no-convert us,ru pc105 "" grp:win_space_toggle`
9. `30-touchpad.conf in /etc/X11/xorg.conf.d`
>Section "InputClass"  
Identifier "libinput touchpad catchall"  
MatchIsTouchpad "on"  
Option "Tapping" "on"  
MatchDevicePath "/dev/input/event*"  
Driver "libinput"  
EndSection
8. `nmcli device set wlp2s0 autoconnect yes`
9. `timedatectl set-timezone <>`
10. `sudo pacman -S wmctrl xdotool` and libinput-gestures from AUR. `sudo gpasswd -a $USER input`, `stow libinput`, then restart


### Best apps
1. bspwm/sxhkd — window manager
2. fish 
5. kitty
6. neovim
7. rofi
8. starship
9. flameshot (screenshots)
10. qbittorrent 
11. gnumeric
12. simplescreenrecorder
13. texlive + texinfo
15. mpv 
16. jdk17-openjdk
17. telegram-desktop : https://t.me/addtheme/tale_at_summer_night



### MISC
1. [set up ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
2. [change cursor](https://tronche.com/gui/x/xlib/appendix/b/)
2. cure usb --> `dd if=/dev/zero of=/dev/sda bs=1k count=1024` and `mkfs.ext4 /dev/sda` 
4. copy to os' clipboard in vim? --> `vim.opt.clipboard = "unnamedplus"` in settings.lua
5. pgp signatures could not be verified?
gpg --recv-key "key in makepkg file"
6. sudo does not work?
systemctl start systemd-homed
7. know app's name to write in picom?
xprop | grep "CLASS"     in bash!
8. want to replace default app?
> xdg-mime query filetype <file>  
xdg-mime query default <filetype>  
xdg-mime default <app> <filetype>  
9. [connect peap using nmcli](https://gist.github.com/JQiu/10489304a71c8a3f25dd1f5a127c75d9)
10. sudo ip link set wlp2s0 up -- Operation not possible due to RF-kill, solve: rfkill unblock wifi
11. setup ublock for FF: toggle RUS in filter lists and install [this](https://forums.lanik.us/viewtopic.php?t=22512-%D0%BE-%D1%84%D0%B8%D0%BB%D1%8C%D1%82%D1%80%D0%B5-ru-adlist-%D0%B8-%D0%B4%D0%BE%D0%BF%D0%BE%D0%BB%D0%BD%D0%B5%D0%BD%D0%B8%D1%8F%D1%85) (find Counter and install it)  

12. add the following to ~/.ssh/config  
Host github.com  
 Hostname ssh.github.com  
 Port 443  
then run `ssh -T git@github.com`
13. woeusb from aur to install windows iso on usb

### GIT 
1. `git rm --cached` removes files from staging area (or index)
2. `git status -s` shows short status 
3. `git commit -am ""` commits all changes with invoking stating area 
4. `git diff` shows difference between working directory and staging area, `git diff --staged` shows difference between last commit and current staging area (or simply speaking it shows files to commit)
5. `git log --oneline` 
6. `git restore --staged file1` replaces file1 with the latest version from staging area
7. `git restore file1` discards local changes of file1
8. `git restore --source=HEAD~1 file1` restore deleted file from previous commit

### Check sensors
1. `watch free -m` gives info on memory
2. `sensors` gives CPU and SSD temperatures
