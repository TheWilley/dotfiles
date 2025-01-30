#!/bin/bash

# set the icon and a temporary location for the screenshot to be stored
tmpbg='/tmp/screen.png'

# remove old screenshot
rm "$tmpbg"

# take a screenshot
scrot "$tmpbg"

# blur the screenshot by resizing and scaling back up
convert "$tmpbg" -brightness-contrast -5x23 -filter Gaussian -thumbnail 20% -sample 500% "$tmpbg"

# lock the screen with the blurred screenshot
i3lock -i "$tmpbg"
