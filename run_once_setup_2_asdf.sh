#!/bin/zsh

asdf plugin add python
asdf plugin add nodejs

# Force stuff to be downloaded
asdf list all nodejs > /dev/null
asdf list all python > /dev/null

asdf install
