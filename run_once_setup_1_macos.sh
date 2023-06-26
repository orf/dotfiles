#!/bin/zsh
set -uo pipefail

defaults write com.apple.screencapture location ~/Documents/screenshots/
defaults write com.apple.finder NewWindowTargetPath file://"$HOME"/
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.bird optimize-storage -boolean false
# Disable the globe emoji picker shortcut
defaults write com.apple.HIToolbox AppleFnUsageType -int 0
# Disable Zoom video by default
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1
killall Dock Finder
print "Setting firewall to stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Fix key permissions
chmod 600 ~/.ssh/id_ed25519*

# Enable locate
if [[ ! -v CI ]]; then
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
fi
