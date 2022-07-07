#!/bin/zsh --emulate sh
set -uo pipefail

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

rustup toolchain install nightly
