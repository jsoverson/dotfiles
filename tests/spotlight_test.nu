#!/usr/bin/env nu
# Writes the Spotlight settings to temp plists and checks the values defaults reads back.
use std/assert
use ../os/macos/defaults.nu

def main [] {
  let root = mktemp -d
  let spot = $root | path join spotlight
  let keys = $root | path join hotkeys
  defaults spotlight $spot $keys

  let items = ^plutil -extract orderedItems json -o - $"($spot).plist" | from json
  assert equal ($items | length) 22
  assert equal ($items | where enabled | get name) [APPLICATIONS MENU_EXPRESSION DIRECTORIES SYSTEM_PREFS SOURCE]
  assert ("public.image" in (^plutil -extract DisabledUTTypes json -o - $"($spot).plist" | from json))
  assert equal (^plutil -extract AppleSymbolicHotKeys.64.enabled raw -o - $"($keys).plist" | str trim) "false"

  rm -r $root
  print "spotlight_test ok"
}
