#!/bin/zsh --emulate sh
set -uo pipefail

# This is probably better? https://zacwe.st/2021/09/14/managing-preference-plists-under-chezmoi/

osascript -e 'quit app "Magnet"'
defaults import com.crowdcafe.windowmagnet.xml "$(chezmoi source-path)/preferences/com.crowdcafe.windowmagnet.xml"
osascript -e 'tell app "Magnet" to activate'
