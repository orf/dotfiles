#!/bin/zsh --emulate sh
set -uo pipefail

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- '-y'
source "$HOME/.cargo/env"
rustup toolchain install nightly
