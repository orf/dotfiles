#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

print () {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

REPO="${REPO:-git@github.com:orf/dotfiles.git}"
DOTFILES_REF=${DOTFILES_REF:-master}
export DOTFILES_GIT_DIR="$HOME"/.dotfiles

if [ ! -d "$DOTFILES_GIT_DIR" ];
then
    print "Cloning dotfiles from {REPO}, branch {DOTFILES_REF}"
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
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree=my-dotfiles-tmp/ checkout "${DOTFILES_REF}"
    # Update the submodules. This requires changing directory, as git submodule does not work with --work-tree
    cd my-dotfiles-tmp/ && git --git-dir="$DOTFILES_GIT_DIR" submodule update --init && cd ../
    # Copy all files from the temporary working directory to $HOME.
    rsync --recursive --verbose --links --exclude '.git' my-dotfiles-tmp/ "$HOME"/ -q
    # Remove the temporary directory
    rm -R my-dotfiles-tmp
    # Disable untracked files. We do not want to show them in our home directory!
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
else
    print "Dotfiles directory already cloned. Pulling."
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" pull
fi

# The "echo |" ensures it's a silent install.
if ! [ -f "/usr/local/bin/brew" ]
then
  print "Installing homebrew"
	echo | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

print "Updating homebrew"
brew update >/dev/null
print "Installing brew bundle"
brew bundle -v --global

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   print "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   # This fails on github actions due to it having no password set. We assume it works locally.
   chsh -s /usr/local/bin/fish || true
fi

print "Installing misc utilities (git lfs, virtualfish, fzf, nvm)"
git lfs install --system
python3.7 -mpip install virtualfish
fish -c "/usr/local/opt/fzf/install --all --xdg"
fish -c "nvm install"
defaultbrowser firefoxdeveloperedition

print "Installing rustup"
fish -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -c clippy rustfmt"

# Non-homebrew install stuff
if ! [ -d "$(pyenv root)/plugins/xxenv-latest" ]
then
    print "Installing xxenv-latest"
    fish -c 'git clone https://github.com/momo-lab/xxenv-latest.git "$(pyenv root)"/plugins/xxenv-latest'
fi

if ! [ -d "/Applications/Little Snitch Configuration.app" ]
then
    if compgen -G "/usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg" > /dev/null; then
      print "Opening little snitch"
      open /usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg
    else
      print "Cannot find little snitch installer!";
    fi
fi

# Day One CLI
if [ -f "/Applications/Day\ One.app/Contents/Resources/install_cli.sh" ]; then
  print "Installing day1 CLI"
  sudo bash /Applications/Day\ One.app/Contents/Resources/install_cli.sh
fi

print "Configuring git"
# SSH fingerprints
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts

# User stuff
git config --global user.name "Tom Forbes"
git config --global user.email "tom@tomforb.es"
git config --global core.excludesfile ~/.gitignore

print "Configuring MacOS defaults"
# MacOS stuff
mkdir -p ~/Pictures/screenshots/
defaults write com.apple.screencapture location ~/Pictures/screenshots/
defaults write com.apple.finder NewWindowTargetPath file://"$HOME"/
defaults write com.apple.finder AppleShowAllFiles -boolean true
defaults write com.apple.dock autohide -boolean true
defaults write com.apple.dock show-recents -boolean false
defaults write com.apple.bird optimize-storage -boolean false
# Disable Zoom video by default
sudo defaults write /Library/Preferences/us.zoom.config.plist ZDisableVideo 1
killall Dock
killall Finder
print "Setting firewall to stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

print "Bootstrapped!"
print "Run the following command to unshallow homebrew:"
echo git -C "$(brew --repo homebrew/core)" fetch --unshallow

print "Adding /usr/local/bin to the launchctl path"
sudo launchctl config user path "/usr/local/bin:$PATH"

print "Running slow operation: installing cargo dependencies"
fish -c "cargo install cargo-edit cargo-tree cargo-bloat cargo-release flamegraph cargo-cache cargo-update cargo-watch"

print "Installing Python versions"
# Install Python versions
pyenv latest install 3.6 -s
pyenv latest install 2.7 -s
