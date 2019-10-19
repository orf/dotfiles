#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO="${REPO:-git@github.com:orf/dotfiles.git}"
DOTFILES_REF=${DOTFILES_REF:-master}

export DOTFILES_GIT_DIR="$HOME"/.dotfiles

if [ ! -d "$DOTFILES_GIT_DIR" ];
then
    # The ultimate git checkout for dotfiles.
    # Clone the dotfiles at a given reference, into a specific git directory (~/.dotfiles)
    # We specify --no-checkout here so that we can exclude some files from the checkout
    git clone --separate-git-dir="$DOTFILES_GIT_DIR" --no-checkout "${REPO}" my-dotfiles-tmp
    # Enable sparse checkouts and exclude .github/ and README.md. The order matters, /* must be the first rule.
    git --git-dir="$DOTFILES_GIT_DIR" config --local core.sparsecheckout true
    cat <<EOF >> "$DOTFILES_GIT_DIR"/info/sparse-checkout
/*
!.github/
!README.md
EOF
    # Checkout the dotfiles
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree=my-dotfiles-tmp/ checkout "${DOTFILES_REF}" --recurse-submodules
    # Copy all files from the temporary working directory to $HOME.
    rsync --recursive --verbose --links --exclude '.git' my-dotfiles-tmp/ "$HOME"/
    # Remove the temporary directory
    rm -R my-dotfiles-tmp
    # Disable untracked files. We do not want to show them in our home directory!
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
else
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" pull
fi

# The "echo |" ensures it's a silent install.
if ! [ -f "/usr/local/bin/brew" ]
then
	echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update >/dev/null

brew bundle -v --global

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   echo "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   # This fails on github actions due to it having no password set. We assume it works locally.
   chsh -s /usr/local/bin/fish || true
fi

git lfs install --system

python3.7 -mpip install virtualfish

fish -c "rustup-init -y"
fish -c "rustup component add clippy rustfmt"
fish -c "cargo install cargo-edit cargo-tree cargo-bloat"
/usr/local/opt/fzf/install --all
defaultbrowser firefoxdeveloperedition
fish -c "fisher"

# Non-homebrew install stuff
if ! [ -d "$(pyenv root)/plugins/xxenv-latest" ]
then
    git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest
fi

if ! [ -d "/Applications/Little Snitch Configuration.app" ]
then
    if compgen -G "/usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg" > /dev/null; then
      open /usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg
    else
      echo "Cannot find little snitch installer!";
    fi
fi

# Day One CLI
if [ -f "/Applications/Day\ One.app/Contents/Resources/install_cli.sh" ]; then
  echo "Installing day1 CLI"
  sudo bash /Applications/Day\ One.app/Contents/Resources/install_cli.sh
fi

# SSH fingerprints
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

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
defaults write com.apple.finder NewWindowTargetPath file://"$HOME"/
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.bird optimize-storage -boolean false
# Disable Zoom video by default
echo "Disabling zoom video by default"
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1
killall Dock
killall Finder
echo "Setting firewall to stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

echo "Bootstrapped!"
echo "Run the following command to unshallow homebrew:"
echo git -C "$(brew --repo homebrew/core)" fetch --unshallow 

echo "Adding /usr/local/bin to the launchctl path"
sudo launchctl config user path "/usr/local/bin:$PATH"
