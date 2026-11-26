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
  # Input menu in the menu bar, for switching keyboard layouts
  [com.apple.TextInputMenu visible -bool true]
  # Cursor: double size, default colors
  [com.apple.universalaccess mouseDriverCursorSize -float 2]
]

# Keyboard layouts: Colemak selected, U.S. available from the input menu.
const layouts = [
  [name id];
  [Colemak 12825]
  ["U.S." 0]
]

def layout-xml [l: record]: nothing -> string {
  $"<dict><key>InputSourceKind</key><string>Keyboard Layout</string><key>KeyboardLayout ID</key><integer>($l.id)</integer><key>KeyboardLayout Name</key><string>($l.name)</string></dict>"
}

# Domain is a parameter so tests can write to a temp plist. Applies at next login.
export def keyboard [domain = "com.apple.HIToolbox"] {
  # macOS's own entries: character viewer and press-and-hold accents.
  let methods = [com.apple.CharacterPaletteIM com.apple.PressAndHold] | each {|b|
    $"<dict><key>Bundle ID</key><string>($b)</string><key>InputSourceKind</key><string>Non Keyboard Input Method</string></dict>"
  }
  let all = $layouts | each {|l| layout-xml $l }
  ^defaults write $domain AppleEnabledInputSources -array ...$all ...$methods
  ^defaults write $domain AppleSelectedInputSources -array ($methods | last) (layout-xml ($layouts | first))
  ^defaults write $domain AppleCurrentKeyboardLayoutInputSourceID -string com.apple.keylayout.Colemak
}

# Caps Lock -> Escape on the built-in keyboard (vendor 0, product 0), as System Settings stores it.
# `defaults` persists it for the next login; hidutil applies it now.
const caps_lock = 0x700000039
const escape = 0x700000029

# With a plist path (tests), only that file is written.
export def caps-to-escape [plist?: string] {
  let target = if $plist == null { [-currentHost write -g] } else { [write $plist] }
  ^defaults ...$target com.apple.keyboard.modifiermapping.0-0-0 -array $"<dict><key>HIDKeyboardModifierMappingDst</key><integer>($escape)</integer><key>HIDKeyboardModifierMappingSrc</key><integer>($caps_lock)</integer></dict>"
  if $plist == null {
    ^hidutil property --matching '{"VendorID":0,"ProductID":0,"PrimaryUsagePage":1,"PrimaryUsage":6}' --set $'{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":($caps_lock),"HIDKeyboardModifierMappingDst":($escape)}]}' | ignore
  }
}

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

const hotkey_plist = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\"><dict><key>default</key><dict><key>key</key><integer>49</integer><key>mod</key><integer>1048576</integer><key>string</key><string> </string></dict></dict></plist>
"

# Alfred on cmd+space, started at login by a LaunchAgent (System Events login items need an
# Automation prompt, which fails over SSH). Its hotkey lives under a per-machine hash that Alfred
# writes to prefs.json on first launch, so launch it once before writing the hotkey.
export def alfred [] {
  let app = glob /Applications/Alfred*.app | sort | last
  if $app == null { print "alfred: not installed, skipping"; return }
  let prefs_json = $env.HOME | path join "Library/Application Support/Alfred/prefs.json"
  if not ($prefs_json | path exists) {
    ^open -a $app
    for _ in 1..30 { if ($prefs_json | path exists) { break }; sleep 1sec }
  }
  try { ^pkill -x Alfred }
  for _ in 1..10 { if (^pgrep -x Alfred | complete).exit_code != 0 { break }; sleep 500ms }
  let p = open $prefs_json
  let hotkey = $p.current | path join preferences local $p.localhash hotkey prefs.plist
  mkdir ($hotkey | path dirname)
  $hotkey_plist | save -f $hotkey
  let agent = $env.HOME | path join Library/LaunchAgents com.dotfiles.alfred.plist
  mkdir ($agent | path dirname)
  launch-agent $app | save -f $agent
  ^open -a $app
}

export def launch-agent [app: string]: nothing -> string {
  $"<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\"><dict>
<key>Label</key><string>com.dotfiles.alfred</string>
<key>ProgramArguments</key><array><string>/usr/bin/open</string><string>-a</string><string>($app)</string></array>
<key>RunAtLoad</key><true/>
</dict></plist>
"
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
  keyboard
  caps-to-escape
  spotlight
  ^/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  alfred
  for app in [Dock Finder SystemUIServer Spotlight TextInputMenuAgent] { try { ^killall $app } }
}
