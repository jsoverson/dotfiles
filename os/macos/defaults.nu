# macOS system preferences. Run via `dot install --defaults`.

const prefs = [
  # Security: require password immediately after sleep/screensaver
  [domain key type value];
  [com.apple.screensaver askForPassword -int 1]
  [com.apple.screensaver askForPasswordDelay -int 0]
  # UI
  [NSGlobalDomain NSTableViewDefaultSizeMode -int 2]
  [NSGlobalDomain AppleShowScrollBars -string Always]
  [NSGlobalDomain NSUseAnimatedFocusRing -bool false]
  [NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true]
  [NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true]
  [NSGlobalDomain PMPrintingExpandedStateForPrint -bool true]
  [NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true]
  [NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false]
  [com.apple.print.PrintingPrefs "Quit When Finished" -bool true]
  [NSGlobalDomain NSTextShowsControlCharacters -bool true]
  [com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false]
  [NSGlobalDomain NSDisableAutomaticTermination -bool true]
  # Typing
  [NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false]
  [NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false]
  [NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false]
  [NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false]
  [NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false]
  # Screenshots
  [com.apple.screencapture type -string png]
  [com.apple.screencapture disable-shadow -bool true]
  # Trackpad: three finger drag
  [com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -int 1]
  [com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0]
  [com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0]
  # Dock
  [com.apple.dock tilesize -int 36]
  [com.apple.dock static-only -bool true]
  [com.apple.dock autohide -bool true]
  [com.apple.dock autohide-delay -float 0]
  [com.apple.dock wvous-tl-corner -int 5]
  [com.apple.dock wvous-tl-modifier -int 0]
  # Finder
  [NSGlobalDomain AppleShowAllExtensions -bool true]
  [com.apple.finder ShowStatusBar -bool true]
  [com.apple.finder ShowPathbar -bool true]
  [com.apple.finder _FXShowPosixPathInTitle -bool true]
  [com.apple.finder _FXSortFoldersFirst -bool true]
  [com.apple.finder FXDefaultSearchScope -string SCcf]
  [com.apple.finder FXEnableExtensionChangeWarning -bool false]
]

# Power: [flag setting value]
const pmset = [
  [-a lidwake 1]
  [-a displaysleep 10]
  [-c sleep 90]
  [-b sleep 15]
  [-a standbydelay 86400]
]

export def main [] {
  for p in $prefs {
    ^defaults write $p.domain $p.key $p.type ($p.value | into string)
  }
  ^defaults write com.apple.screencapture location -string ($env.HOME | path join Documents screenshots)
  ^defaults write com.apple.dock persistent-apps -array
  ^defaults -currentHost write -globalDomain com.apple.keyboard.fnState -bool true
  ^chflags nohidden ($env.HOME | path join Library)
  for p in $pmset { ^sudo pmset ...$p }
  for app in [Dock Finder SystemUIServer] { try { ^killall $app } }
}
