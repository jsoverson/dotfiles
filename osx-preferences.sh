
sudo scutil --set ComputerName $COMPUTER_NAME
sudo scutil --set HostName $COMPUTER_NAME
sudo scutil --set LocalHostName $COMPUTER_NAME
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME

defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show the ~/Library folder
chflags nohidden ~/Library

###
# start SystemUIServer Dependent options
###

# Enable three finger drag
defaults -currentHost write -globalDomain com.apple.trackpad.threeFingerDragGesture -int 1

# Disable screenshot shadow
defaults write com.apple.screencapture disable-shadow -bool true
# Save screenshots to docs/screenshots
defaults write com.apple.screencapture location -string "$DOCS/screenshots"
# Save screenshots as png
defaults write com.apple.screencapture type -string "png"


defaults write com.apple.systemuiserver menuExtras -array \
  "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
  "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
  "/System/Library/CoreServices/Menu Extras/Battery.menu" \
  "/System/Library/CoreServices/Menu Extras/Clock.menu" \
  "/System/Library/CoreServices/Menu Extras/Volume.menu"

defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.airport" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.battery" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.bluetooth" -bool true
defaults write com.apple.systemuiserver "NSStatusItem Visible com.apple.menuextra.volume" -bool true

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

killall SystemUIServer
###
# end SystemUIServer Dependent options
###

# Set tilesize
defaults write com.apple.dock tilesize -int 36

# Get rid of all persistent apps in dock
defaults write com.apple.dock persistent-apps -array

defaults write com.apple.dock static-only -bool true

alfdefaults write com.apple.dock autohide -bool true

defaults write com.apple.dock autohide-delay -float 0;

killall Dock

# Fn-keys on by default
defaults -currentHost write -globalDomain com.apple.keyboard.fnState -bool true