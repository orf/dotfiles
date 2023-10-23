#!/bin/zsh

# fisher hash: {{ include (joinPath .chezmoi.sourceDir "dot_config" "fish" "fish_plugins" | quote) | sha256sum }}

fish -c "$(brew --prefix fzf)/install --all --xdg"
fish -c "fisher update"
