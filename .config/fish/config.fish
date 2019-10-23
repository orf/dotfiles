alias j "z"
alias tmpd "pushd (mktemp -d)"
abbr -a ccwd "pwd | pbcopy"
alias ls "exa -a"
alias tree "ls -T"
alias cat "bat"
alias cs "open-project"
abbr -a dotfiles "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias cloc "tokei"

set -gx HOMEBREW_AUTO_UPDATE_SECS 86400

set -gx XDG_CACHE_HOME "$HOME/Library/Caches"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx HTTPIE_CONFIG_DIR "$XDG_CONFIG_HOME/httpie"
set -gx PYCHARM_VM_OPTIONS "$XDG_CONFIG_HOME/pycharm/pycharm.vmoptions"
set -gx IPYTHONDIR "$XDG_CONFIG_HOME/ipython"
set -gx NODE_REPL_HISTORY "$XDG_CONFIG_HOME/node_repl_history"
set -gx RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
set -gx CARGO_HOME "$XDG_CONFIG_HOME/cargo"
set -gx VIRTUALFISH_HOME "$XDG_CONFIG_HOME/virtualfish"
set -gx NVM_DIR "$XDG_CONFIG_HOME/nvm"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx PYENV_ROOT "$XDG_CONFIG_HOME/pyenv"

set -gx GIT_WORKSPACE "$HOME/PycharmProjects/"

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx GPG_TTY (tty)

status --is-interactive; and source (pyenv init -|psub)

eval (python3 -m virtualfish auto_activation compat_aliases global_requirements projects)

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

if not functions -q fisher
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set PATH /Users/tom/Library/Python/3.7/bin /Applications/Postgres.app/Contents/Versions/latest/bin ~/.cargo/bin/ $CARGO_HOME/bin/ $PATH

if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

if test -e ~/.config/secrets.fish
    source ~/.config/secrets.fish
end


