#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

git clone --separate-git-dir=$HOME/.dotfiles https://github.com/orf/dotfiles.git my-dotfiles-tmp
rsync --recursive --verbose --exclude '.git' my-dotfiles-tmp/ $HOME/
rm -R my-dotfiles-tmp
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config status.showUntrackedFiles no

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle -v --global

#git -C "$(brew --repo homebrew/core)" fetch --unshallow

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   echo "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   chsh -s /usr/local/bin/fish
fi

git lfs install --system

# MacOS stuff
mkdir -p ~/Pictures/screenshots/
defaults write com.apple.screencapture location ~/Pictures/screenshots/
