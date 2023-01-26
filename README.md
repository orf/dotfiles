# Dotfiles

To setup, first:

* Log into iCloud
* Wait for keychain to sync 

Then run:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install --cask 1password 1password-cli chezmoi
op account add --email=tom@tomforb.es --address=my.1password.com
eval $(op signin)
$ sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply orf
```
