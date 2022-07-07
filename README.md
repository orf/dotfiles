# Dotfiles

To setup, first:

* Log into iCloud
* Wait for keychain to sync 

Then run:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi

$ sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply orf
```