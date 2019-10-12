# My Dotfiles

## Pre-installation

1. Log into the Mac app store
2. Ensure SSH private keys are present
3. Set the computer name correctly

## Install

Run `curl https://raw.githubusercontent.com/orf/dotfiles/master/bootstrap.sh | bash`

This will add the configuration files present in this repository to your 
home directory.

## Updating

There is a `dotfiles` alias set up in `config.fish` that allows you to 
update your dotfiles. e.g:

`dotfiles add ~/.config/fish/config.fish`

It expands to `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME`.


