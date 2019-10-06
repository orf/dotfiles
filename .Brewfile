tap 'homebrew/cask-versions'
tap 'homebrew/cask-fonts'
tap 'homebrew/cask'


if ENV.has_key?('SKIP_MAS') then
    brew "mas"

    mas '1Password', id:1333542190
    mas "Things", id: 904280696
    mas "WhatsApp", id: 1147396723
    mas "Textual 7", id: 1262957439
    mas "Slack", id: 803453959
    mas "Magnet", id: 441258766
    mas "Day One", id:1055511498
end

cask "thingsmacsandboxhelper"
cask "firefox-developer-edition"
cask "little-snitch"
cask "iterm2"
cask "pycharm"
cask "alfred3"
cask "docker"
cask "gpg-suite"
cask "google-chrome"
cask "plex-media-server"
cask "istat-menus"
cask "deckset"
cask "postgres"
cask "vlc"
cask "dash"
cask "micro-snitch"
cask "flux"

# Fonts
cask 'font-source-code-pro-for-powerline'
cask 'font-source-code-pro'
cask 'font-source-sans-pro'
cask 'font-source-serif-pro'

brew "fish"
brew "python"
brew "pyenv"
brew "pipenv"
brew "bat"
brew "git"
brew "coreutils"
brew "findutils"
brew "fd"
brew "httpie"
brew "tokei"
brew "docker-completion"
brew "nano"
brew "pv"
brew "tldr"
brew "wget"
brew "watch"
brew "pkg-config"
brew "fzf"
brew "git-lfs"
brew "exa"
brew "nvm"
brew "rustup-init"
brew "tree"
brew "ripgrep"
brew "docker-completion"
brew "jq"
brew "screen"
brew "ncdu"
brew "ipython"
brew "htop"
brew "tmux"
brew "wget"
brew "youtube-dl"
brew "node", args: ["--overwrite"]
brew "nvm"
brew "curl"
brew "watchman"
brew "defaultbrowser"
brew "cargo-completion"
brew "pstree"
brew "hugo"
brew "sccache"
brew "stern"
brew "kubectx"
brew "dive"

custom_brewfile = "#{Dir.home}/.Brewfile.#{Socket.gethostname}"
if File.file?(custom_brewfile)
	instance_eval(File.read(custom_brewfile))
else
	puts "#{custom_brewfile} does not exist!"
end
