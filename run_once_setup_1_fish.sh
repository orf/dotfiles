#!/bin/zsh

fish -c "$(brew --prefix fzf)/install --all --xdg"
fish -c "fisher update"
