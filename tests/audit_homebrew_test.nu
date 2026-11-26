#!/usr/bin/env nu
use std/assert
use ../bin/audit-homebrew-apps *

def main [] {
  let listed = brewfile-entries "# comment\nbrew \"jq\"\n  cask \"zed\"\nbrew \"jfrog/tap/jfrog-cli\"\ntap \"x/y\"\n"
  assert equal $listed [[type name]; [formula jq] [cask zed] [formula jfrog-cli]]

  let installed = [[type name]; [formula jq] [formula jfrog-cli] [formula htop] [cask zed] [cask jq]]
  assert equal (unlisted $installed $listed) [[type name]; [formula htop] [cask jq]]
  print "audit_homebrew_test: ok"
}
