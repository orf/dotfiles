#!/usr/local/bin/zsh --emulate sh
set -euo pipefail
IFS=$'\n\t'

print () {
  # strict mode my ass 🤷‍
  local IFS=" "
  printf "\r\033[2K  [ \033[00;32m%s\033[0m ] %s\n" "$(date +'%r')" "$*"
}

fail () {
  local IFS=" "
  printf "\r\033[2K  [ \033[00;31m%s\033[0m ] 🛑 %s\n" "$(date +'%r')" "$*"
}

info () {
  local IFS=" "
  printf "  [ \033[00;34m%s\033[0m ] %s\n" "$(date +'%r')" "$*"
}

run_cmd() {
  output_file=$(mktemp)
  info "Running" "$@"
  # shellcheck disable=SC2068
  if ! $@ &> "${output_file}"
  then
    cat "${output_file}"
    fail "There was an error running" "$@"
    fail "You can view the bundle output above for diagnostics."
    exit 1
  fi
}

REPO="${REPO:-git@github.com:orf/dotfiles.git}"
DOTFILES_REF=${DOTFILES_REF:-master}
export DOTFILES_GIT_DIR="$HOME"/.dotfiles

if [ ! -d "$DOTFILES_GIT_DIR" ];
then
    print "Cloning dotfiles from ${REPO}, branch ${DOTFILES_REF}"
    # The ultimate git checkout for dotfiles.
    # Clone the dotfiles at a given reference, into a specific git directory (~/.dotfiles)
    # We specify --no-checkout here so that we can exclude some files from the checkout
    run_cmd git clone --separate-git-dir="$DOTFILES_GIT_DIR" --no-checkout "${REPO}" my-dotfiles-tmp
    # Enable sparse checkouts and exclude .github/ and README.md. The order matters, /* must be the first rule.
    run_cmd git --git-dir="$DOTFILES_GIT_DIR" config --local core.sparsecheckout true
    cat <<EOF >> "$DOTFILES_GIT_DIR"/info/sparse-checkout
/*
!.github/
!README.md
EOF
    # Checkout the dotfiles
    run_cmd git --git-dir="$DOTFILES_GIT_DIR" --work-tree=my-dotfiles-tmp/ checkout "${DOTFILES_REF}"
    # Update the submodules. This requires changing directory, as git submodule does not work with --work-tree
    cd my-dotfiles-tmp/ && run_cmd git --git-dir="$DOTFILES_GIT_DIR" submodule update --init && cd ../
    # Copy all files from the temporary working directory to $HOME.
    run_cmd rsync --recursive --verbose --links --exclude '.git' my-dotfiles-tmp/ "$HOME"/ -q
    # Remove the temporary directory
    rm -R my-dotfiles-tmp
    # Disable untracked files. We do not want to show them in our home directory!
    git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" config status.showUntrackedFiles no
else
    print "Dotfiles directory already cloned. Pulling."
    run_cmd git --git-dir="$DOTFILES_GIT_DIR" --work-tree="$HOME" pull
fi

# The "echo |" ensures it's a silent install.
if ! [ -f "/usr/local/bin/brew" ]
then
  print "Installing homebrew"
	run_cmd /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

run_cmd brew update
run_cmd brew bundle -v --global

if ! grep -Fxq "/usr/local/bin/fish" /etc/shells
then
   print "Fish not in /etc/shells, adding"
   echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
   # This fails on github actions due to it having no password set. We assume it works locally.
   chsh -s /usr/local/bin/fish || true
fi

print "Installing misc utilities (git lfs, virtualfish, fzf, nvm)"
run_cmd git lfs install --system
run_cmd python3.7 -mpip install virtualfish
run_cmd fish -c "/usr/local/opt/fzf/install --all --xdg"
run_cmd fish -c "nvm install"
run_cmd defaultbrowser firefoxdeveloperedition
run_cmd fish -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y -c clippy rustfmt"

# Non-homebrew install stuff
if ! [ -d "$(pyenv root)/plugins/xxenv-latest" ]
then
    print "Installing xxenv-latest"
    run_cmd fish -c 'git clone https://github.com/momo-lab/xxenv-latest.git "(pyenv root)"/plugins/xxenv-latest'
fi

if ! [ -d "/Applications/Little Snitch Configuration.app" ]
then
    if compgen -G "/usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg" > /dev/null; then
      print "Opening little snitch"
      run_cmd open /usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg
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
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>&1
ssh-keyscan gitlab.com >> ~/.ssh/known_hosts 2>&1

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
run_cmd killall Dock Finder
print "Setting firewall to stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

print "Bootstrapped!"
print "Run the following command to unshallow homebrew:"
print git -C "$(brew --repo homebrew/core)" fetch --unshallow

print "Adding /usr/local/bin to the launchctl path"
sudo launchctl config user path "/usr/local/bin:$PATH"

if [ -z "${SKIP_SLOW_DEPENDENCIES}" ];
then
  print "Running slow operation: installing cargo dependencies"
  run_cmd fish -c "cargo install cargo-edit cargo-tree cargo-bloat cargo-release flamegraph cargo-cache cargo-update cargo-watch"

  print "Installing Python versions"
  # Install Python versions
  run_cmd pyenv latest install 3.6 -s
  run_cmd pyenv latest install 2.7 -s
fi

print "Bootstrapped!"
