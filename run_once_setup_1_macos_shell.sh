#!/bin/zsh
set -uo pipefail

print "Adding /opt/homebrew/bin/fish to the launchctl path"
sudo launchctl config user path "/opt/homebrew/bin:$PATH"

if ! grep -Fxq "/opt/homebrew/bin/fish" /etc/shells; then
  print "Fish not in /etc/shells, adding"
  echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
fi

chsh -s /opt/homebrew/bin/fish
