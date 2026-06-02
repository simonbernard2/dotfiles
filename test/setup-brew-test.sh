#!/bin/sh
set -eu

ROOT_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"
EXPECTED_CASKS="docker
font-meslo-lg-nerd-font
google-chrome
iterm2
karabiner-elements
logseq
postman
raycast
slack
spotify
visual-studio-code
vlc
zoom"

expected_casks_sorted="$(printf '%s\n' "$EXPECTED_CASKS" | sort)"
actual_casks_sorted="$(sed -n 's/^cask "\([^"]*\)".*/\1/p' "$ROOT_DIR/install/Caskfile" | sort)"

if [ "$actual_casks_sorted" != "$expected_casks_sorted" ]; then
  echo "Cask parser output changed unexpectedly." >&2
  echo "Expected:" >&2
  printf '%s\n' "$expected_casks_sorted" >&2
  echo "Actual:" >&2
  printf '%s\n' "$actual_casks_sorted" >&2
  exit 1
fi

echo "setup-brew tests passed."
