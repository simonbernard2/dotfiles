# dotfiles

My dotfiles, inspired by [webpro's](https://github.com/webpro/dotfiles)

## Fresh macOS setup

Start with Apple's command line tools:

```bash
sudo softwareupdate -i -a
xcode-select --install
```

Clone this repository, then run the setup modules from the repo root:

```bash
bin/setup brew
bin/setup essentials
bin/setup links
bin/setup macos
bin/setup dock
bin/setup apps
```

You can also run the full sequence:

```bash
bin/setup all
```

## Setup modules

- `bin/setup brew`: installs Homebrew if missing, installs formulae from `install/Brewfile`, then installs casks from `install/Caskfile` unless the app already exists in `/Applications`, `~/Applications`, or `/System/Applications`.
- `bin/setup essentials`: installs Oh My Zsh, tmux plugin manager, and the directories expected by shell tooling.
- `bin/setup links`: links dotfiles into your home directory.
- `bin/setup macos`: applies macOS defaults from `macOS/defaults.sh`.
- `bin/setup dock`: configures the Dock from `macOS/dock.sh`.
- `bin/setup apps`: prints manual import steps for Raycast and iTerm.

## Linked files

`bin/setup links` creates these symlinks:

- `config/zsh/.zshrc` -> `~/.zshrc`
- `config/zsh/.zprofile` -> `~/.zprofile`
- `config/tmux/tmux.conf` -> `~/.tmux.conf`
- `config/nvim` -> `~/.config/nvim`
- `config/git/config` -> `~/.gitconfig`
- `config/git/ignore` -> `~/.config/git/ignore`

Existing files are moved to `~/.dotfiles-backups/YYYYmmdd-HHMMSS/` before symlinks are created. Existing correct symlinks are left untouched.

## Manual app imports

Raycast and iTerm need manual imports after the apps are installed:

- Raycast: import `config/raycast/raycast_config.rayconfig` from Raycast Settings > Advanced.
- iTerm2: import `config/iterm/itermProfile.json` from iTerm2 Settings > Profiles.

## Tests

Run the shell checks and fixture tests:

```bash
bin/test
```
