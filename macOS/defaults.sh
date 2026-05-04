#!/bin/sh
set -eu

disable_symbolic_hotkey() {
  hotkey_id="$1"
  key_code="$2"
  modifiers="$3"
  plist="$HOME/Library/Preferences/com.apple.symbolichotkeys.plist"

  /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:$hotkey_id:enabled false" "$plist" 2>/dev/null ||
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$hotkey_id" \
      "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>$key_code</integer><integer>$modifiers</integer></array><key>type</key><string>standard</string></dict></dict>"
}

# Close System Settings before writing preferences
osascript -e 'tell application "System Settings" to quit' >/dev/null 2>&1 || true

###############################################################################
# Keyboard                                                                      #
###############################################################################

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Automatically illuminate built-in MacBook keyboard in low light
defaults write com.apple.BezelServices kDim -bool true
# Turn off keyboard illumination when computer is not used for 5 minutes
defaults write com.apple.BezelServices kDimTime -int 300

# Disable Spotlight and Finder search keyboard shortcuts
disable_symbolic_hotkey 64 49 1048576
disable_symbolic_hotkey 65 49 1572864

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Swipe between pages with two fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true

# Use trackpad for dragging with drag lock
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.AppleMultitouchTrackpad DragLock -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad DragLock -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Dock                                                                        #
###############################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# Don't show recently used applications in the Dock
defaults write com.Apple.Dock show-recents -bool false
# Set dock position to left side of the screen
defaults write com.apple.dock orientation -string "left"
# Top-left hot corner starts the screen saver
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom-left hot corner puts the display to sleep
defaults write com.apple.dock wvous-bl-corner -int 10
defaults write com.apple.dock wvous-bl-modifier -int 0
