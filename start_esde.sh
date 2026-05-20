#!/bin/bash

echo "Launching ES-DE Frontend..."
echo ""

ES_DE_APPIMAGE="/home/fabian/RetroGamingBox/es-de/ES-DE_x64.AppImage"

if [ ! -f "$ES_DE_APPIMAGE" ]; then
    echo "ERROR: ES-DE not found at $ES_DE_APPIMAGE"
    exit 1
fi

# Make executable and launch
chmod +x "$ES_DE_APPIMAGE"
cd /home/fabian/RetroGamingBox
"$ES_DE_APPIMAGE"

echo ""
echo "ES-DE closed."