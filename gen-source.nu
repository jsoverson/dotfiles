#!/usr/bin/env nu

def main [dir: string = "source"] {
  let files = ls ($dir) | $in.name | where $in =~ ".*nu$" |  each {|n| $"source ($n)"}
  print ($files | str join "\n");
}

