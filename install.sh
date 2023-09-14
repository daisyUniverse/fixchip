#!/bin/bash

# Please note that this is not anywhere near complete, and heavily work-in-progress, and also not tested. Will remove this line when I've implemented everything

# Step 0. Backup all system files that will be affected
# Step 1. Download latest tarball of filesystem changes from github or my site
# Step 2. untar the ball..
# Step 3. Copy in apt configs
# Step 4. Apt update, apt upgrade, and then install required packages
# ( git vala-terminal xfce4-genmon-plugin xinput-calibrator software-properties-common apt-transport-https )
# Step 5. Copy in dotfiles (xmodmap, xinitrc)
# Step 6. Run xinput-calibrator, and then copy in the new xorg.conf (ask user for ability to long-press)
# Step 7. Git-Clone chip-battery-status, run it's installer
# Step 8. Ask user if they'd like to change the hostname, and if so, do that

# Options to explore:
# 1. Should I store all system files inside of the main script to keep it all contained?
# 2. How far should I take this? is a usable system okay, or should I include fun extras as well?
# 3. Should I consider mirroring the jfpossibilies repo myself for redundancy?
