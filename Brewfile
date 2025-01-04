# Core brews
brew "httpie"
brew "chezmoi"
brew "nushell"
brew "mise"

# Fish utils
brew "fish"
brew "fisher"

# Standard utils
brew "wget"
brew "wget2"
brew "git"
brew "git-lfs"
brew "curl"

# GNU stuff
brew "gnu-sed"
brew "gnu-tar"
brew "coreutils"
brew "findutils"
brew "parallel"
brew "screen"
brew "nano"
brew "watch"
brew "htop"

# My tools
brew "gping"
brew "git-workspace"
brew "hq"

# Useful utilities
brew "ffmpeg"
brew "ncdu"
brew "pv"
brew "tree"
brew "yt-dlp"
brew "pstree"
brew "litecli"
brew "gpg"
brew "nanorc"
brew "graphviz"
brew "skopeo"
brew "shfmt"
brew "libmagic"
brew "trash"

# Other
brew "defaultbrowser"

# For alfred plugins
brew "php"

# Common build deps
brew "cmake"
brew "pkg-config"

# for fix-code-permissions.sh
brew "duti"

# Casks:

tap "homebrew/cask-fonts"
tap "homebrew/cask-versions"

# Fonts - needs svn for some reason?
brew "svn"
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-3'
cask 'font-source-serif-4'

# Core casks
cask "iterm2"
cask "firefox@developer-edition"
cask "dash"
cask "alfred"
cask "bartender"
cask "batteries"
cask "istat-menus"
cask "postgres-unofficial"  # postgres.app
cask "deckset"
cask "jetbrains-toolbox"
cask "1password-cli"

# Useful stuff
cask "wireshark"

# Data utils
cask "clickhouse"

# Other apps
cask "notion"
cask "claude"

# Default apps changing
cask "swiftdefaultappsprefpane"

# Quicklook plugins
cask "qlmarkdown"
cask "quicklook-json"

# GPG stuff
cask "gpg-suite-no-mail"

# App Store Apps
brew "mas"
mas "Magnet", id: 441258766
mas "ShellHistory", id: 1564015476

# Docker stuff
cask "docker"

# Personal deps:
{{- if (not (.is_work_machine)) }}
cask "1password", args: {"adopt": true}
cask "mullvadvpn"
cask "little-snitch"
cask "micro-snitch"
cask "vlc"

mas "UTM Virtual Machines", id: 1538878817
{{- end }}

# Work deps:
{{- if (.is_work_machine) }}
cask "linear-linear"
{{- end }}
