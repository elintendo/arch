if status is-interactive
    starship init fish | source
    set fish_greeting ""
    alias v "nvim"
    alias la "lsd -ail --blocks permission,links,user,group,size,date,name"
    alias ls "lsd -1"
    alias hdmi "xrandr --output HDMI-1 --mode 1920x1080"
end

function bat
    cat /sys/class/power_supply/BAT1/capacity
end 

function wt 
    curl "https://wttr.in/innopolis?format=3"
end

function cu 
    nmcli device wifi connect UniversityStudent
end 

function cg
    nmcli device wifi connect 5G_ays --ask
end
  
function orphan
    sudo pacman -Qtdq | sudo pacman -Rns -
end

function clean
    id3v2 -t "$argv"
end
