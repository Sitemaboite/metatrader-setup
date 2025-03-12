#!/bin/bash
set -xeuo pipefail

export WINEPREFIX=$HOME/.mt5_$1


unset DISPLAY
unset XAUTHORITY
unset XDG_RUNTIME_DIR

# Set environment to Windows 10
WINEPREFIX=$WINEPREFIX winetricks -q win10 || true
# Install WebView2 Runtime

Xvfb :99 -screen 0 1024x768x24 -nolisten tcp &
sleep 5
export DISPLAY=:99.0

WINEPREFIX=$WINEPREFIX DISPLAY=$DISPLAY wine /tmp/MicrosoftEdgeWebview2Setup.exe /silent /install
# Start MetaTrader installer
WINEPREFIX=$WINEPREFIX XDG_RUNTIME_DIR=$WINEPREFIX DISPLAY=$DISPLAY wine /tmp/mt5setup.exe /auto || true

# Move Desktop shortcuts
cd $HOME/Desktop
mv 'MetaEditor 5.desktop' "MetaEditor 5 - $1.desktop"
mv 'MetaTrader 5.desktop' "MetaTrader 5 - $1.desktop"