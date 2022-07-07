#!/bin/bash

brew bundle --no-lock --file=/dev/stdin <<EOF

# App Store Apps
brew "mas"
mas "Magnet", id: 441258766

# Core casks
cask "firefox-developer-edition"
cask "little-snitch"
cask "micro-snitch"
cask "vlc"
cask "dash"
cask "alfred"
cask "docker"
cask "istat-menus"
cask "postgres"
cask "deckset"
cask "intel-power-gadget"

# Quicklook plugins
cask "qlmarkdown"
cask "quicklook-json"

# Fonts
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-pro'
cask 'font-source-serif-pro'

# Core brews
brew "fish"
brew "python"
brew "pyenv"
brew "poetry"
brew "ipython"
brew "pipx"

brew "exa"
brew "bat"
brew "fd"
brew "httpie"

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
brew "git-workspace"
brew "pgcli"

# Completion
brew "docker-completion"
brew "cargo-completion"

# Kubernetes and Docker
brew "kubectl"
brew "stern"
brew "kubectx"
brew "dive"
brew "derailed/k9s/k9s"

# Other
brew "defaultbrowser"

EOF