#!/bin/zsh
set -eu -o pipefail

brew tap "derailed/k9s"

temp=$(mktemp)

cat <<EOF > $temp

is_not_ci = !ENV.has_value?("CI")
puts "CI: #{is_not_ci}"

# Core brews
brew "python"
brew "poetry"
brew "ipython"
brew "pipx"
brew "exa"
brew "bat"
brew "fd"
brew "httpie"
brew "chezmoi"
brew "asdf"
brew "nushell"

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
brew "awscli", link: is_not_ci
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
brew "podman"
brew "kubectl"
brew "stern"
brew "kubectx"
brew "dive"
brew "derailed/k9s/k9s"

# Other
brew "defaultbrowser"

# Common build deps
brew "cmake"

EOF

if [[ ! -v CI ]]; then
  brew tap "homebrew/cask-fonts"

  cat >> "$temp" <<EOF

# Fonts - needs svn for some reason?
brew "svn"
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-pro'
cask 'font-source-serif-pro'

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
cask "istat-menus"
cask "postgres-unofficial"  # postgres.app
cask "deckset"
cask "jetbrains-toolbox"
cask "mullvadvpn"
cask "1password"
cask "1password-cli"

# Quicklook plugins
cask "qlmarkdown"
cask "quicklook-json"

# App Store Apps
brew "mas"
mas "Magnet", id: 441258766
mas "ShellHistory", id: 1564015476
EOF
fi

top_level_temp=$(mktemp)
brew bundle list --file="$temp" > "$top_level_temp"

deps_temp=$(mktemp)
brew deps -n --union --full-name $(cat "$top_level_temp") > "$deps_temp"

cat "$deps_temp" "$top_level_temp" | xargs -P20 -n10 brew fetch --retry -q | grep -v 'SHA256: '

HOMEBREW_NO_INSTALL_CLEANUP=1 brew bundle --verbose --cleanup --no-lock --file="$temp"

if [[ ! -v CI ]]; then
  brew cleanup --prune=all -s
fi
