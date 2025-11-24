function r
    sudo reflector --latest 5 --sort rate --country Russia --save /etc/pacman.d/mirrorlist

end
