# macOS system preferences. `dot` applies these unless run with `--no-defaults`.

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
  # Widgets: hide on the desktop and in Stage Manager
  [com.apple.WindowManager StandardHideWidgets -bool true]
  [com.apple.WindowManager StageManagerHideWidgets -bool true]
]

# Spotlight categories, copied from the primary Mac's com.apple.Spotlight.
const spotlight_items = [
  [name enabled];
  [APPLICATIONS true] [MENU_EXPRESSION true] [CONTACT false] [MENU_CONVERSION false]
  [MENU_DEFINITION false] [DOCUMENTS false] [EVENT_TODO false] [DIRECTORIES true]
  [FONTS false] [IMAGES false] [MESSAGES false] [MOVIES false] [MUSIC false]
  [MENU_OTHER false] [PDF false] [PRESENTATIONS false] [MENU_SPOTLIGHT_SUGGESTIONS false]
  [SPREADSHEETS false] [SYSTEM_PREFS true] [TIPS false] [BOOKMARKS false] [SOURCE true]
]
const spotlight_disabled_types = [
  com.adobe.pdf com.apple.iwork.numbers.numbers com.apple.iwork.numbers.sffnumbers
  com.apple.iwork.numbers.template com.apple.localized-pdf-bundle com.apple.protected-mpeg-4-audio
  com.apple.quicktime-movie com.microsoft.excel.sheet.binary.macroenabled com.microsoft.excel.xls
  org.openxmlformats.spreadsheetml.sheet org.openxmlformats.spreadsheetml.sheet.macroenabled
  public.3gpp public.3gpp2 public.audio public.image public.movie public.mpeg public.mpeg-4
  public.mpeg-4-audio public.mpeg-video public.spreadsheet
]
const spotlight_rules = [
  com.apple.tips com.apple.AddressBook Domain.PDF Domain.SPREADSHEETS Domain.MOVIES
  com.apple.Dictionary Custom.relatedContents Domain.IMAGES Domain.MUSIC
]

const alfred_app = "/Applications/Alfred 5.app"

# Domains are parameters so tests can write to temp plists.
export def spotlight [domain = "com.apple.Spotlight", hotkeys = "com.apple.symbolichotkeys"] {
  let items = $spotlight_items | each {|i|
    $"<dict><key>enabled</key><($i.enabled)/><key>name</key><string>($i.name)</string></dict>"
  }
  ^defaults write $domain orderedItems -array ...$items
  ^defaults write $domain DisabledUTTypes -array ...$spotlight_disabled_types
  ^defaults write $domain EnabledPreferenceRules -array ...$spotlight_rules
  # Unbind cmd+space (symbolic hotkey 64) so Alfred can take it.
  ^defaults write $hotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>"
}

# Alfred on cmd+space, launched at login. Its hotkey lives under a per-machine hash that
# Alfred writes to prefs.json on first launch, so launch it once before writing the hotkey.
def alfred [] {
  if not ($alfred_app | path exists) { return }
  let prefs_json = $env.HOME | path join "Library/Application Support/Alfred/prefs.json"
  if not ($prefs_json | path exists) {
    ^open -a $alfred_app
    for _ in 1..30 { if ($prefs_json | path exists) { break }; sleep 1sec }
  }
  ^osascript -e 'quit app "Alfred 5"'
  let p = open $prefs_json
  let hotkey = $p.current | path join preferences local $p.localhash hotkey prefs.plist
  mkdir ($hotkey | path dirname)
  '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict><key>default</key><dict><key>key</key><integer>49</integer><key>mod</key><integer>1048576</integer><key>string</key><string> </string></dict></dict></plist>
' | save -f $hotkey
  let login_items = ^osascript -e 'tell application "System Events" to get the name of every login item'
  if not ($login_items | str contains "Alfred 5") {
    ^osascript -e $'tell application "System Events" to make login item at end with properties {path:"($alfred_app)", hidden:false}'
  }
  ^open -a $alfred_app
}

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
  spotlight
  ^/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  alfred
  for app in [Dock Finder SystemUIServer Spotlight] { try { ^killall $app } }
}
