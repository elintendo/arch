# remove all existing keybindings
hc keyunbind --all

# keybindings
Mod=Mod4

hc keybind $Mod-Shift-q quit
hc keybind $Mod-Shift-r reload
hc keybind $Mod-q close
hc keybind $Mod-Return spawn "kitty"
hc keybind $Mod-b spawn "google-chrome-stable"
hc keybind $Mod-r spawn rofi -show drun

# basic movement in tiling and floating mode
# focusing clients
hc keybind $Mod-Left  focus left
hc keybind $Mod-Down  focus down
hc keybind $Mod-Up    focus up
hc keybind $Mod-Right focus right
hc keybind $Mod-h     focus left
hc keybind $Mod-j     focus down
hc keybind $Mod-k     focus up
hc keybind $Mod-l     focus right

# moving clients in tiling and floating mode
hc keybind $Mod-Shift-Left  shift left
hc keybind $Mod-Shift-Down  shift down
hc keybind $Mod-Shift-Up    shift up
hc keybind $Mod-Shift-Right shift right
hc keybind $Mod-Shift-h     shift left
hc keybind $Mod-Shift-j     shift down
hc keybind $Mod-Shift-k     shift up
hc keybind $Mod-Shift-l     shift right

# splitting frames
# create an empty frame at the specified direction
hc keybind $Mod-u       split   bottom  0.5
hc keybind $Mod-o       split   right   0.5
# let the current frame explode into subframes
hc keybind $Mod-Control-space split explode

# resizing frames and floating clients
resizestep=0.02
hc keybind $Mod-Control-h       resize left +$resizestep
hc keybind $Mod-Control-j       resize down +$resizestep
hc keybind $Mod-Control-k       resize up +$resizestep
hc keybind $Mod-Control-l       resize right +$resizestep
hc keybind $Mod-Control-Left    resize left +$resizestep
hc keybind $Mod-Control-Down    resize down +$resizestep
hc keybind $Mod-Control-Up      resize up +$resizestep
hc keybind $Mod-Control-Right   resize right +$resizestep


# cycle through tags
hc keybind $Mod-period use_index +1 --skip-visible
hc keybind $Mod-comma  use_index -1 --skip-visible

# layouting
hc keybind $Mod-w remove
hc keybind $Mod-s floating toggle
hc keybind $Mod-f fullscreen toggle
hc keybind $Mod-Shift-f set_attr clients.focus.floating toggle
hc keybind $Mod-Shift-d set_attr clients.focus.decorated toggle
hc keybind $Mod-Shift-m set_attr clients.focus.minimized true
hc keybind $Mod-Control-m jumpto last-minimized
hc keybind $Mod-p pseudotile toggle
# The following cycles through the available layouts within a frame, but skips
# layouts, if the layout change wouldn't affect the actual window positions.
# I.e. if there are two windows within a frame, the grid layout is skipped.
# hc keybind $Mod-space                                                           \
#             or , and . compare tags.focus.curframe_wcount = 2                   \
#                      . cycle_layout +1 vertical horizontal max vertical grid    \
#                , cycle_layout +1
hc keybind Alt-space                                                           \
            or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

# mouse
hc mouseunbind

#left click
hc mousebind $Mod-Button1 move

# wheel
hc mousebind $Mod-Button2 zoom

# right click
# why alt works? :)
hc mousebind $Mod-Button3 resize

# focus
hc keybind $Mod-BackSpace   cycle_monitor
hc keybind $Mod-Tab         cycle_all +1
hc keybind $Mod-Shift-Tab   cycle_all -1
hc keybind $Mod-c cycle
hc keybind $Mod-i jumpto urgent

# custom keybindings
hc keybind Print spawn flameshot gui
hc keybind XF86MonBrightnessDown spawn brightnessctl set 10%-
hc keybind XF86MonBrightnessUp spawn brightnessctl set 10%+
hc keybind XF86AudioLowerVolume spawn pactl set-sink-volume @DEFAULT_SINK@ -5%
hc keybind XF86AudioRaiseVolume spawn pactl set-sink-volume @DEFAULT_SINK@ +5%
hc keybind XF86AudioMute spawn pactl set-sink-mute @DEFAULT_SINK@ toggle
# hc keybind XF86AudioLowerVolume spawn amixer set 'Master' 5%-
# hc keybind XF86AudioRaiseVolume spawn amixer set 'Master' 5%+
# hc keybind XF86AudioMute        spawn amixer set 'Master' toggle
hc keybind F9 spawn i3lock -k -i /home/me/arch/wp/pastel.png

