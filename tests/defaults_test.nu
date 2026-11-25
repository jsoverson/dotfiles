#!/usr/bin/env nu
# Writes macOS settings to temp plists and checks the values defaults reads back.
use std/assert
use ../os/macos/defaults.nu

def extract [key: string, plist: string] {
  ^plutil -extract $key json -o - $plist | from json
}

def main [] {
  let root = mktemp -d

  let spot = $root | path join spotlight
  let keys = $root | path join hotkeys
  defaults spotlight $spot $keys
  let items = extract orderedItems $"($spot).plist"
  assert equal ($items | length) 22
  assert equal ($items | where enabled | get name) [APPLICATIONS MENU_EXPRESSION DIRECTORIES SYSTEM_PREFS SOURCE]
  assert ("public.image" in (extract DisabledUTTypes $"($spot).plist"))
  assert equal (^plutil -extract AppleSymbolicHotKeys.64.enabled raw -o - $"($keys).plist" | str trim) "false"

  let kb = $root | path join hitoolbox
  defaults keyboard $kb
  let enabled = extract AppleEnabledInputSources $"($kb).plist"
  assert equal ($enabled | where InputSourceKind == "Keyboard Layout" | get "KeyboardLayout Name") [Colemak "U.S."]
  assert ("com.apple.PressAndHold" in ($enabled | get -o "Bundle ID"))
  let selected = extract AppleSelectedInputSources $"($kb).plist"
  assert equal ($selected | where InputSourceKind == "Keyboard Layout" | get "KeyboardLayout ID") [12825]
  assert equal (^plutil -extract AppleCurrentKeyboardLayoutInputSourceID raw -o - $"($kb).plist" | str trim) "com.apple.keylayout.Colemak"

  rm -r $root
  print "defaults_test ok"
}
