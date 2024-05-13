fish_config theme choose "Dracula Official"

if status is-interactive
    set fish_greeting ""
    alias hx helix
    alias se sudoedit
    alias wu "sudo wg-quick up wg0"
    alias wd "sudo wg-quick down wg0"
    alias b "cat /sys/class/power_supply/BAT1/capacity"
    alias v nvim
    alias g git
    alias gs "git status"
    alias nm nmcli
    alias bl bluetoothctl
    alias tar bsdtar
    alias s systemctl
    alias d "du -d 1 -h | sort -h"
    alias ls exa
    alias sx startx
    alias la "exa -la --no-time"
end
