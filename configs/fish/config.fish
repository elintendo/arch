fish_config theme choose "Dracula Official"

if status is-interactive
    set fish_greeting ""
end

# system
abbr -a k kubectl
abbr -a hx helix
abbr -a se sudoedit
abbr -a nm nmcli
abbr -a bl bluetoothctl
abbr -a tar bsdtar
abbr -a s systemctl
abbr -a ls exa
abbr -a sx startx
abbr -a la exa -la --no-time
abbr -a b cat /sys/class/power_supply/BAT1/capacity
abbr -a ki kitten ssh

# git
abbr -a g git
abbr -a gs git status
