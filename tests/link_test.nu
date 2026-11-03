#!/usr/bin/env nu
use std/assert
use ../lib/link.nu

def main [] {
  let root = mktemp -d
  let home = $root | path join home
  let repo = $root | path join repo
  mkdir $home $repo
  "a" | save ($repo | path join a)
  "b" | save ($repo | path join b)
  "old" | save ($home | path join existing)
  ^ln -s ($repo | path join a) ($home | path join linked)

  let links = [
    {src: ($repo | path join a), dest: ($home | path join linked)}
    {src: ($repo | path join a), dest: ($home | path join nested/new)}
    {src: ($repo | path join b), dest: ($home | path join existing)}
  ]
  let p = link plan $links
  assert equal ($p | get action) [ok create replace]

  let backup = $root | path join backup
  link apply $p $backup $home | ignore
  assert equal (link plan $links | get action) [ok ok ok]
  assert equal (open ($backup | path join existing)) "old"
  assert equal (open ($home | path join existing)) "b"

  rm -r $root
  print "link_test ok"
}
