#!/bin/zsh --emulate sh
set -uo pipefail

defaults write com.apple.screencapture location ~/Documents/screenshots/
defaults write com.apple.finder NewWindowTargetPath file://"$HOME"/
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.bird optimize-storage -boolean false
# Disable Zoom video by default
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1
killall Dock Finder
print "Setting firewall to stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

print "Adding /usr/local/bin to the launchctl path"
sudo launchctl config user path "/usr/local/bin:$PATH"

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells; then
  print "Fish not in /etc/shells, adding"
  echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
fi

chsh -s /usr/local/bin/fish
