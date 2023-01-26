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

print "Adding /opt/homebrew/bin/fish to the launchctl path"
sudo launchctl config user path "/opt/homebrew/bin:$PATH"

if ! grep -Fxq "/opt/homebrew/bin/fish" /etc/shells; then
  print "Fish not in /etc/shells, adding"
  echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
fi

chsh -s /opt/homebrew/bin/fish

# Fix key permissions
chmod 600 ~/.ssh/id_ed25519*