alias j "z"
alias tmpd "pushd (mktemp -d)"
abbr -a ccwd "pwd | pbcopy"
alias ls "exa -a"
alias tree "ls -T"
alias cat "bat"
alias cs "open-project"
alias js "cd-project"
alias copy-venv "echo (pwd)/.venv/bin/python | pbcopy"

abbr -a dotfiles "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias cloc "tokei"

set -gx AWS_DEFAULT_REGION "eu-west-1"

set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx XDG_CACHE_HOME "$HOME/Library/Caches"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx POETRY_HOME "$XDG_CONFIG_HOME/poetry"
set -gx HTTPIE_CONFIG_DIR "$XDG_CONFIG_HOME/httpie"
set -gx IPYTHONDIR "$XDG_CONFIG_HOME/ipython"
set -gx NODE_REPL_HISTORY "$XDG_CONFIG_HOME/node_repl_history"
set -gx RUSTUP_HOME "$XDG_CONFIG_HOME/rustup"
set -gx CARGO_HOME "$XDG_CONFIG_HOME/cargo"
set -gx VIRTUALFISH_HOME "$XDG_CONFIG_HOME/virtualfish"
set -gx NVM_DIR "$XDG_CONFIG_HOME/nvm"
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
set -gx WGETRC "$XDG_CONFIG_HOME/wget/wgetrc"
set -gx GIT_WORKSPACE "$HOME/PycharmProjects/"
set -gx PIPX_HOME "$XDG_CONFIG_HOME/pipx"
set -gx PIPX_BIN_DIR "$PIPX_HOME/bin"

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx GPG_TTY (tty)

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

set PATH /usr/local/lib/ruby/gems/2.6.0/bin/ /Users/tom/Library/Python/3.7/bin /Applications/Postgres.app/Contents/Versions/latest/bin ~/.cargo/bin/ $CARGO_HOME/bin/ $POETRY_NAME/bin $PIPX_BIN_DIR /usr/sbin $PATH

if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end

if test -e ~/.config/secrets.fish
    source ~/.config/secrets.fish
end

# Color schemes
set fish_color_command $pure_color_normal


# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.fish ]; and . ~/.config/tabtab/__tabtab.fish; or true

# Pyenv setup
set -gx PYENV_ROOT "$XDG_CONFIG_HOME/pyenv"
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

if command -v pyenv 1>/dev/null 2>&1
	status is-login; and pyenv init --path | source
    pyenv init - | source
end
