#!/bin/zsh --emulate sh

temp=$(mktemp)

cat <<EOF > $temp

tap "derailed/k9s"
tap "homebrew/cask-versions"

# App Store Apps
brew "mas"
mas "Magnet", id: 441258766

# Core casks
cask "iterm2"
cask "firefox-developer-edition"
cask "little-snitch"
cask "micro-snitch"
cask "vlc"
cask "dash"
cask "alfred"
cask "bartender"
cask "batteries"
cask "docker"
cask "istat-menus"
cask "postgres-unofficial"  # postgres.appfi
cask "deckset"
cask "jetbrains-toolbox"
cask "mullvadvpn"
cask "1password"

# Quicklook plugins
cask "qlmarkdown"
cask "quicklook-json"

# Fonts - needs svn for some reason?
brew "svn"
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-pro'
cask 'font-source-serif-pro'

# Core brews
brew "python"
brew "pyenv"
brew "poetry"
brew "ipython"
brew "pipx"
brew "exa"
brew "bat"
brew "fd"
brew "httpie"
brew "chezmoi"

# Fish utils
brew "fish"
brew "fisher"

# Standard utils
brew "wget"
brew "git"
brew "git-lfs"
brew "nano"
brew "coreutils"
brew "findutils"
brew "watch"
brew "pkg-config"
brew "screen"
brew "ncdu"
brew "htop"
brew "tmux"
brew "curl"
brew "yarn"
brew "awscli"
brew "terraform"

# Useful utilities
brew "tokei"
brew "pv"
brew "fzf"
brew "tree"
brew "ripgrep"
brew "jq"
brew "youtube-dl"
brew "watchman"
brew "pstree"
brew "ffmpeg"
brew "tealdeer"
brew "pgcli"
brew "gpg"
brew "gping"
brew "git-workspace"
brew "nanorc"

# Kubernetes and Docker
brew "kubectl"
brew "stern"
brew "kubectx"
brew "dive"
brew "derailed/k9s/k9s"

# Other
brew "defaultbrowser"

EOF

HOMEBREW_NO_INSTALL_CLEANUP=1 brew bundle --verbose --cleanup --no-lock --file=$temp

brew cleanup --prune=all -s