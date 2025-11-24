# writing this resets all attributes to a default value
hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1

##############################
# Frame                      #
##############################
hc set show_frame_decorations 'none'

##############################
# Border                     #
##############################

hc attr theme.inner_width 0
hc attr theme.inner_color blue

hc attr theme.outer_width 2
hc attr theme.outer_color white

# sum of borders
hc attr theme.border_width 2


##############################
# Title                      #
##############################

hc attr theme.title_height 20
hc attr theme.title_when 'multiple_tabs'
hc attr theme.title_depth 6 # space below the title's baseline
hc attr theme.title_align 'left'
hc attr theme.title_color '#ffffff'

# /usr/share/fonts/TTF/JetBrainsMonoNerdFontMono-Medium.ttf:
hc attr theme.title_font 'JetBrainsMonoNerdFontMono:size=11:medium'


##############################
# Colors                     #
##############################

# active (configures the decoration of the focused client)
hc attr theme.active.color '#1F4172' # the basic background color of the border
hc attr theme.active.tab_title_color '#FDF0F0' # the title color of non-urgent and unfocused tabs

# normal (the default decoration scheme for clients)
hc attr theme.normal.title_color '#898989'
hc attr theme.normal.color '#132043'

hc attr theme.urgent.color '#7811A1dd'


##############################
# Miscellaneous              #
##############################
hc set window_gap 20
