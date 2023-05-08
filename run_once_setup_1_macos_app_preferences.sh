#!/bin/zsh --emulate sh
set -uo pipefail

# This is probably better? https://zacwe.st/2021/09/14/managing-preference-plists-under-chezmoi/

osascript -e 'quit app "Magnet"'
defaults import com.crowdcafe.windowmagnet.xml "$(chezmoi source-path)/preferences/com.crowdcafe.windowmagnet.xml"
osascript -e 'tell app "Magnet" to activate'


VALUE="$(cat "$(chezmoi source-path)"/preferences/keyboard_shortcuts.xml)"

defaults write pbs NSServicesStatus \
  -dict-add \
  'com.apple.Terminal - Open man Page in Terminal - openManPage' \
  "$VALUE"
defaults write pbs NSServicesStatus \
  -dict-add \
  'com.apple.Terminal - Search man Page Index in Terminal - searchManPages' \
  "$VALUE"
