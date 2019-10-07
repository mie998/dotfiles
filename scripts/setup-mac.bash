#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ "$(uname)" != "Darwin" ] && exit

touch "$HOME/.hushlogin"

# GPG
ln -sfv "$REPO_DIR/config/gnupg/gpg-agent.conf.mac" "$HOME/.gnupg/gpg-agent.conf"

# Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder NewWindowTarget -string PfHm

# Keyboard
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Menubar
defaults write com.apple.menuextra.battery ShowPercent -bool true
defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm:ss"

# Mission Control
defaults write com.apple.dock wvous-br-corner -int 4 # Bottom right -> Desktop
defaults write com.apple.dock mru-spaces -bool false # Don't automatically rearrange spaces
defaults write com.apple.dock mcx-expose-disabled -bool TRUE # disable mission Control

# Disable .DS_Store on network disks
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Screen capture
defaults write com.apple.screencapture disable-shadow -bool true

# Configure hammerspoon config location
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"

killall Dock
killall Finder
killall SystemUIServer
