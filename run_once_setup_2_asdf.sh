#!/bin/zsh --emulate sh
set -uo pipefail

export XDG_CONFIG_HOME="$HOME/.config"
export CARGO_HOME="$XDG_CONFIG_HOME/cargo"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- '-y'
source "$HOME/.cargo/env"
rustup toolchain install nightly
