#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! [ -d "$HOME/.dotfiles" ]
then
    git clone --recurse-submodules --separate-git-dir=$HOME/.dotfiles https://github.com/orf/dotfiles.git my-dotfiles-tmp
    rsync --recursive --verbose --exclude '.git' my-dotfiles-tmp/ $HOME/
    rm -R my-dotfiles-tmp
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no
fi

# Silent install
if ! [ -f "/usr/local/bin/brew" ]
then
	echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle -v --global

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   echo "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   chsh -s /usr/local/bin/fish
fi

git lfs install --system
rustup-init -y
/usr/local/opt/fzf/install --all
python3.7 -mpip install virtualfish
defaultbrowser firefoxdeveloperedition
fish -c "fisher"

# Non-homebrew install stuff
if ! [ -d "$(pyenv root)/plugins/xxenv-latest" ]
then
    git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
fi

if ! [ -d "/Applications/Little Snitch Configuration.app" ]
then
    open /usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg
fi

# User stuff
git config --global user.name "Tom Forbes"
git config --global user.email "tom@tomforb.es"
git config --global core.excludesfile ~/.gitignore

# Install Python versions
pyenv latest install 3.6 -s
pyenv latest install 2.7 -s

# MacOS stuff
mkdir -p ~/Pictures/screenshots/
defaults write com.apple.screencapture location ~/Pictures/screenshots/
defaults write com.apple.finder NewWindowTargetPath file://$HOME/
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.bird optimize-storage -boolean false
# Disable Zoom video by default
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1
killall Dock
killall Finder
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

echo "Bootstrapped!"
echo "Run the following command to unshallow homebrew:"
echo git -C "$(brew --repo homebrew/core)" fetch --unshallow 

sudo launchctl config user path "/usr/local/bin:$PATH"
