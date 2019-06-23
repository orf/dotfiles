alias j "z"
alias tmpd "pushd (mktemp -d)"
abbr -a ccwd "pwd | pbcopy"
alias ls "exa"
alias cat "bat"
abbr -a dotfiles "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias cloc "tokei"

set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx XDG_CACHE_HOME "$HOME/Library/Caches/"
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx GPG_TTY (tty)

status --is-interactive; and source (pyenv init -|psub)

eval (python3 -m virtualfish auto_activation compat_aliases global_requirements projects)

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set PATH /Applications/Postgres.app/Contents/Versions/latest/bin ~/.cargo/bin/ $PATH

set -gx NVM_DIR "$HOME/.local/share/nvm"
set -gx CARGO_HOME "$HOME/.local/share/cargo"
set -gx RUSTUP_HOME "$HOME/.local/share/rustup"
set -gx VIRTUALFISH_HOME "$HOME/.local/share/virtualfish"

if status --is-interactive
    set BASE16_SHELL "$HOME/.config/base16-shell/"
    source "$BASE16_SHELL/profile_helper.fish"
end
