#!/bin/sh
set -eu

ROOT_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"

# Each test run gets an isolated home directory so setup-links can be exercised
# without touching the real user environment.
TEST_HOME="$(mktemp -d /private/tmp/dotfiles-links-test.XXXXXX)"

cleanup() {
  rm -rf "$TEST_HOME"
}

trap cleanup EXIT INT TERM

assert_link() {
  expected_src="$1"
  dest="$2"

  # Verify both halves of the contract: the destination is a symlink and it
  # points at the expected file or directory in this checkout.
  if [ ! -L "$dest" ]; then
    echo "Expected symlink: $dest" >&2
    exit 1
  fi

  actual_src="$(readlink "$dest")"
  if [ "$actual_src" != "$expected_src" ]; then
    echo "Expected $dest -> $expected_src, got $actual_src" >&2
    exit 1
  fi
}

assert_file_exists() {
  file="$1"

  # Used for backup assertions where the backup path includes a timestamp and
  # has to be discovered dynamically.
  if [ ! -f "$file" ]; then
    echo "Expected file: $file" >&2
    exit 1
  fi
}

assert_path_missing() {
  path="$1"

  if [ -e "$path" ] || [ -L "$path" ]; then
    echo "Expected missing path: $path" >&2
    exit 1
  fi
}

# Fresh install: setup-links should create every managed dotfile link in the
# isolated home directory.
DOTFILES_HOME="$TEST_HOME" "$ROOT_DIR/bin/setup-links" >/dev/null

assert_link "$ROOT_DIR/config/zsh/.zshrc" "$TEST_HOME/.zshrc"
assert_link "$ROOT_DIR/config/zsh/.zprofile" "$TEST_HOME/.zprofile"
assert_link "$ROOT_DIR/config/tmux/tmux.conf" "$TEST_HOME/.tmux.conf"
assert_link "$ROOT_DIR/config/nvim" "$TEST_HOME/.config/nvim"
assert_link "$ROOT_DIR/config/git/config" "$TEST_HOME/.gitconfig"
assert_link "$ROOT_DIR/config/git/ignore" "$TEST_HOME/.config/git/ignore"

# Idempotency check: running setup-links again over the same links should
# succeed without backing up or replacing already-correct symlinks.
DOTFILES_HOME="$TEST_HOME" "$ROOT_DIR/bin/setup-links" >/dev/null
assert_path_missing "$TEST_HOME/.dotfiles-backups"

# Conflict install: pre-existing regular files should be moved into
# .dotfiles-backups and replaced with the managed symlinks. This includes
# nested destinations whose backup parent directories must be created.
CONFLICT_HOME="$(mktemp -d /private/tmp/dotfiles-links-conflict-test.XXXXXX)"
trap 'rm -rf "$TEST_HOME" "$CONFLICT_HOME"' EXIT INT TERM

mkdir -p "$CONFLICT_HOME/.config/git"
printf 'existing zshrc\n' > "$CONFLICT_HOME/.zshrc"
printf 'existing gitconfig\n' > "$CONFLICT_HOME/.gitconfig"
printf 'existing gitignore\n' > "$CONFLICT_HOME/.config/git/ignore"

DOTFILES_HOME="$CONFLICT_HOME" "$ROOT_DIR/bin/setup-links" >/dev/null

assert_link "$ROOT_DIR/config/zsh/.zshrc" "$CONFLICT_HOME/.zshrc"
assert_link "$ROOT_DIR/config/git/config" "$CONFLICT_HOME/.gitconfig"
assert_link "$ROOT_DIR/config/git/ignore" "$CONFLICT_HOME/.config/git/ignore"
assert_file_exists "$(find "$CONFLICT_HOME/.dotfiles-backups" -type f -name .zshrc | head -n 1)"
assert_file_exists "$(find "$CONFLICT_HOME/.dotfiles-backups" -type f -name .gitconfig | head -n 1)"
assert_file_exists "$(find "$CONFLICT_HOME/.dotfiles-backups" -type f -path '*/.config/git/ignore' | head -n 1)"

echo "setup-links tests passed."
