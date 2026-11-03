#!/usr/bin/env nu
# Start a real interactive nu under a throwaway HOME with the repo's config linked in.
use std/assert

const repo = path self | path dirname | path dirname

def main [] {
  let home = mktemp -d
  # Ask nushell where its config dir is for this HOME (platform-specific).
  let cfg_dir = with-env {HOME: $home} { ^$nu.current-exe -n -c 'print $nu.default-config-dir' } | str trim
  mkdir $cfg_dir
  ^ln -s $repo ($home | path join dotfiles)
  ^ln -s ($repo | path join nu config.nu) ($cfg_dir | path join config.nu)
  ^ln -s ($repo | path join nu autoload) ($cfg_dir | path join autoload)
  '$env.LOCAL_LOADED = "yes"' | save ($cfg_dir | path join local.nu)

  let probe = '{local: $env.LOCAL_LOADED?, dotfiles: $env.DOTFILES_DIR?, path: ($env.PATH | first), banner: $env.config.show_banner} | to nuon | print; exit'
  let out = with-env {HOME: $home, PATH: "/usr/bin:/bin"} {
    "" | ^$nu.current-exe -e $probe | lines | last | from nuon
  }
  assert equal $out.local "yes"
  assert equal $out.dotfiles ($home | path join dotfiles)
  assert equal $out.path ($home | path join .local bin)
  assert equal $out.banner false

  rm -r $home
  print "nu_config_test ok"
}
