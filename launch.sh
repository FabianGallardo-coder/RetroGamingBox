#!/bin/bash
# RetroGamingBox launch script
# Uses RetroArch with Ozone frontend (Batocera-like experience)

# Set the home directory to our box's directory for portable config
export HOME="$PWD"

# Launch RetroArch with our configuration
# The config file will be automatically loaded from configs/retroarch/retroarch.cfg
exec retroarch --config "$PWD/configs/retroarch/retroarch.cfg"