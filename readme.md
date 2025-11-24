# install

## (0)
- [acquire Arch ISO file](https://archlinux.org/download/)
- [verify checksums](https://archlinux.org/download/#checksums)
- copy image onto a USB stick (e.g, using [Ventoy](https://www.ventoy.net/en/index.html))
  - obtain Ventoy from [AUR](https://aur.archlinux.org/ventoy-bin.git)
  - `ventoy /dev/sdb` (paste here your USB drive)
  - `mount /dev/sdb1 /mnt`
  - `cp image.iso /mnt`
- load Arch (e.g, via UEFI boot manager)

## (1)
- aperitif
  - `rmmod pcspkr`
  - `setfont ter-132n`
- disk layout
  - `fdisk /dev/sda`, `g (GUID)`, `n (new partition)`, `w (write)`
  - `mkfs.fat -F 32 /dev/sda1`, `mkfs.ext4 /dev/sda2`,
  - `mount /dev/sda2 /mnt`
  - `mount -m /dev/sda1 /mnt/boot`
- installing packages
  - `iwctl`
  - mirrors setup
    - `reflector --latest 5 --sort rate --country "" --save /etc/pacman.d/mirrorlist`
  - `pacstrap -i /mnt linux linux-firmware-intel base base-devel grub efibootmgr networkmanager nvim fish git`
- before chroot
  - `genfstab -U /mnt > /mnt/etc/fstab`
  - `cp {,/mnt}/usr/share/kbd/consolefonts/ter-132n.psf.gz`
  - `echo blacklist pcspkr > /mnt/etc/modprobe.d/nobeep.conf`
  - `arch-chroot /mnt`
- user birth
  - `useradd -mG wheel -s $(which fish) ""`
  - `passwd ""`, `passwd`
  - `EDITOR=nvim visudo`
- grub
  - `grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot`
  - `grub-mkconfig -o /boot/grub/grub.cfg`
- digestif
  - exit from chroot
  - `umount -R /mnt`
  - `shutdown now`

## (2)
- `systemctl enable --now NetworkManager`, `nmcli device wifi connect <> --ask`
- `timedatectl set-timezone`
- `git clone https://github.com/elintendo/arch.git`
- `./zeze.sh`
- install paru-bin
- `paru google-chrome`
- setting up repo properly
  - `pacman -S openssh github-cli`
  - `ssh-keygen -t ed25519 -C ""`
  - `gh auth login`
  - `git remote set-url origin git@github.com:elintendo/arch.git`
  - `gh ssh-key list/delete <old key>`
- chrome
    <details>
    <summary>RU Adlist: Counters</summary>
    chrome-extension://cjpalhdlnbpafiamejdnhcphjbkeiagm/asset-viewer.html?url=https%3A%2F%2Feasylist-downloads.adblockplus.org%2Fcntblock.txt&title=RU%20AdList%3A%20Counters&subscribe=1
    </details>
- skip username prompt on login (still requires password)
  - `sudo systemctl edit getty@tty1`
  - add:
    ```
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-p -f me' --noclear --skip-login --login-options me %I $TERM
    ```

## (ricing)
- cursor setup
  - [breezex](https://aur.archlinux.org/packages/breezex-cursor-theme)
  - `mkdir ~/.local/share/icons/default`
  - `ln -sf /usr/share/icons/BreezeX-Black/cursors ~/.local/share/icons/default`
  - `ln -sf /usr/share/icons/BreezeX-Black/index.theme ~/.local/share/icons/default`
- libinput-gestures
  - `sudo gpasswd -a $USER input`
  - `reboot`
  - `sudo pacman -S wmctrl xdotool`
  - [libinput-gestures](https://aur.archlinux.org/libinput-gestures.git)
  - `libinput-gestures-setup start`
  - `libinput-gestures-setup autostart`

# dump
- bios/gpt setup: fdisk, partition 1 (+1M) is of type Bios (t to change partition type), do not create file system, do not mount. then, chroot and `grub-install --target=i386-pc /dev/sda`, make config
- fix pgp: `pacman-key --init`, `pacman-key --populate`
- after installing pipewire: `systemctl --user --now enable pipewire pipewire-pulse`
- audio switching with wpctl/pactl
  - view devices: `wpctl status`
  - if `wpctl set-default <id>` doesn't work, change card profile first:
    - `pactl set-card-profile alsa_card.pci-0000_00_1f.3-platform-skl_hda_dsp_generic "HiFi (HDMI1, HDMI2, HDMI3, Mic1, Mic2, Speaker)"`
    - then: `wpctl set-default <speaker-id>` (laptop speakers)
- add ssh key to server
  - `ssh-copy-id -i ~/.ssh/key.pub user@ip
  - `ssh user@ip`
- gpg
  - `gpg --recv-key <key in makepkg>`
  - gpg problems? `pacman-key -p`
- cure sudo: `systemctl start systemd-homed`
- `dd if=/dev/zero of=/dev/sda bs=1k count=1024`, `mkfs.ext4 /dev/sda` 
- [connect peap using nmcli](https://gist.github.com/JQiu/10489304a71c8a3f25dd1f5a127c75d9)
- operation not possible due to RF-kill: `rfkill unblock wifi`
- `watch free -m` gives info on memory
- `pacman -S noto-fonts-cjk` for chinese characters
- `pacman -S noto-fonts` if any problems with fonts
- toolkit.legacy for firefox's css
- install gnome-keyring for VScode copilot
- `timedatectl set-local-rtc 1 --adjust-system-clock` to fix time shift (windows, linux dual boot)
- [org.bluez.Error.Failed br-connection-unknown?](https://askubuntu.com/questions/1423297/org-bluez-error-authenticationtimeout-org-bluez-error-failed-br-connection-unkn)
- `git remote set-url origin git@github.com:elintendo/arch.git`
- feh, open window for ricing: `feh -x. /img`
- picom
  - only `picom &` in wm config
  - `xprop | grep "CLASS"`
- `pacman -S wireguard-tools openresolv`, `wg-quick up wg0`
- `pacman -S docker docker-compose`, `systemctl start docker`, `usermod -aG docker ""`
- install lutris with xdg-desktop-portal-wlr, no need for any other xdg-desktop-portal on x11
- `hostnamectl` to find out laptop's name
- `set -Ux foo bar` for fish global vars
- telegram-desktop file picker workaround: set global var QT_QPA_PLATFORMTHEME=gtk3, run `telegram-desktop` `GTK_THEME=.. telegram-desktop`
- `git remote set-url origin` to change to ssh
- [cannot connect to peap? read this article](https://archtemis.readthedocs.io/en/latest/network.html#eduroam)
- install nvm
  - [install fisher](https://github.com/jorgebucaran/fisher)
  - `fisher install jorgebucaran/nvm.fish`
- proper autorandr configuration:
  - `autorandr --save laptop`
  - `autorandr --default laptop`
  - `autorandr --save docked`
  - now plugging and unplugging HDMI will automatically choose the correct setup
