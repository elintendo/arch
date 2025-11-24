fish_config theme choose "Dracula Official"

# Customize exa colors
set -x EXA_COLORS "di=38;5;33:ln=38;5;201:ex=38;5;46:*.md=38;5;214:*.rs=38;5;208:*.py=38;5;226:*.js=38;5;229:*.json=38;5;178:*.yml=38;5;105:*.yaml=38;5;105:*.toml=38;5;219:*.conf=38;5;141:*.sh=38;5;48:*.fish=38;5;81:*.lua=38;5;147:*.vim=38;5;35:*.txt=38;5;252:*.pdf=38;5;196:*.zip=38;5;203:*.tar=38;5;203:*.gz=38;5;203:*.rar=38;5;203:*.jpg=38;5;227:*.jpeg=38;5;227:*.png=38;5;227:*.gif=38;5;227:*.svg=38;5;227:*.mp3=38;5;213:*.mp4=38;5;213:*.mkv=38;5;213:*.avi=38;5;213:ur=38;5;46:uw=38;5;226:ux=38;5;196:gr=38;5;83:gw=38;5;220:gx=38;5;203:tr=38;5;121:tw=38;5;228:tx=38;5;210:da=38;5;147:sn=38;5;141:sb=38;5;105"

# Auto-start Hyprland on TTY1
if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec Hyprland
    end
end

if status is-interactive
    set fish_greeting ""
    
    # Enable vim mode
    fish_vi_key_bindings
end

# system
abbr -a k kubectl
abbr -a hx helix
abbr -a se sudoedit
abbr -a nm nmcli
abbr -a bl bluetoothctl
abbr -a tar bsdtar
abbr -a s systemctl
abbr -a sx startx
abbr -a la exa -la --no-time
abbr -a ki kitten ssh
abbr -a cal cal -mn3
abbr -a v nvim

# battery
abbr -a b cat /sys/class/power_supply/BAT1/capacity
abbr -a bs cat /sys/class/power_supply/BAT1/status

# git
abbr -a g git
abbr -a gs git status
