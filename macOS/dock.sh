#!/bin/sh
set -eu

if ! command -v dockutil >/dev/null 2>&1; then
  echo "dockutil is required. Run: bin/setup brew" >&2
  exit 1
fi

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/iTerm.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --add '' --type small-spacer --section apps
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Reminders.app"
dockutil --add '' --type small-spacer --section apps
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"

killall Dock
