#!/bin/zsh
set -uo pipefail

print "Configuring git"
# SSH fingerprints
ssh-keyscan github.com >>~/.ssh/known_hosts 2>&1
ssh-keyscan gitlab.com >>~/.ssh/known_hosts 2>&1

git lfs install

if defaultbrowser | grep -q "firefoxdeveloperedition"; then
   defaultbrowser firefoxdeveloperedition
else
   echo "Not setting defaultbrowser as firefoxdeveloperedition is not available"
fi
