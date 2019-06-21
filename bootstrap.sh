#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

if ! [ -d "$HOME/.dotfiles" ]
then
    git clone --separate-git-dir=$HOME/.dotfiles https://github.com/orf/dotfiles.git my-dotfiles-tmp
    rsync --recursive --verbose --exclude '.git' my-dotfiles-tmp/ $HOME/
    rm -R my-dotfiles-tmp
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no
fi

# Silent install
echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle -v --global

#git -C "$(brew --repo homebrew/core)" fetch --unshallow

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   echo "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   chsh -s /usr/local/bin/fish
fi

git lfs install --system
rustup-init -y
/usr/local/opt/fzf/install --all

# Non-homebrew install stuff
if [ -d "$(pyenv root)/plugins/xxenv-latest" ]
    git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
fi

# User stuff
git config --global user.name "Tom Forbes"
git config --global user.email "tom@tomforb.es"
git config --global core.excludesfile ~/.gitignore

# Install Python versions
pyenv latest install 3.6
pyenv latest install 2.7

# MacOS stuff
mkdir -p ~/Pictures/screenshots/
defaults write com.apple.screencapture location ~/Pictures/screenshots/
defaults write com.apple.finder NewWindowTargetPath file://$HOME/
defaults write com.apple.finder AppleShowAllFiles -boolean true
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
