#!/usr/bin/env nu
# Provision this machine: packages, config links, runtimes, git identity. Safe to re-run.
# Also available as `dot` (bin/dot links here).

# Module paths go through $repo because relative `use` would resolve against the bin/dot symlink.
const repo = path self | path expand | path dirname
const link_mod = $repo | path join lib link.nu
const os_install = $repo | path join os $nu.os-info.name install.nu
const defaults_mod = $repo | path join os macos defaults.nu
use $link_mod
use $os_install
use $defaults_mod

const overlay_repo = "https://github.com/jsoverson/dotfiles-overlay-2026"

def state-file [] { $env.HOME | path join .config dotfiles profile }

# Links shared by every OS. src is relative to the repo; dest is relative to $HOME unless absolute.
def base-links []: nothing -> list<record<src: string, dest: string>> {
  [
    [src dest];
    [nu/config.nu ($nu.default-config-dir | path join config.nu)]
    [nu/autoload ($nu.user-autoload-dirs | first)]
    [config/starship.toml .config/starship.toml]
    [config/ghostty .config/ghostty/config]
    [config/mise.toml .config/mise/config.toml]
    [config/git/config .config/git/config]
    [config/git/ignore .config/git/ignore]
    [config/zsh/zshrc .zshrc]
    [config/zsh/zprofile .zprofile]
    [claude/CLAUDE.md .claude/CLAUDE.md]
  ]
}

# Resolve a links list against its source root and $HOME.
def resolve [root: string, home: string]: list -> list {
  each {|l| {src: ($root | path join $l.src), dest: ($home | path join $l.dest)} }
}

def overlay-links [overlay: string]: nothing -> list {
  let f = $overlay | path join links.nuon
  if ($f | path exists) { open $f } else { [] }
}

def link-all [links: list, home: string] {
  let backup = $home | path join .dotfiles-backup (date now | format date "%Y%m%d-%H%M%S")
  link apply (link plan $links) $backup $home
  | each {|l| print $"linked ($l.dest) [($l.action)]" }
  | ignore
}

# Shell init scripts generated once per install instead of on every shell start.
def generate-vendor-autoload [] {
  let dir = $nu.data-dir | path join vendor autoload
  mkdir $dir
  ^starship init nu | save -f ($dir | path join starship.nu)
  ^mise activate nu | save -f ($dir | path join mise.nu)
}

def runtimes [] {
  ^mise install --yes
  # `rustup default` fails when no default toolchain is set; leave an existing choice alone.
  if (^rustup default | complete).exit_code != 0 { ^rustup default stable }
}

# Agent skills via the `skills` CLI (vercel-labs/skills), from config/skills.nuon.
# Installs only skills missing from ~/.agents/skills, so re-runs don't overwrite local edits.
def install-skills [home: string] {
  let dir = $home | path join .agents skills
  let have = if ($dir | path exists) { ls $dir | get name | path basename } else { [] }
  open ($repo | path join config skills.nuon) | each {|s|
    let missing = $s.skills | where $it not-in $have
    if ($missing | is-not-empty) {
      let flags = $missing | each {|n| [--skill $n] } | flatten
      ^mise exec -- npx -y skills add $s.source ...$flags --global --agent claude-code --yes
    }
  } | ignore
}

def ensure-gh-key [pub: string, kind: string, endpoint: string] {
  let body = open $pub | split row " " | first 2 | str join " "
  let have = ^gh api $endpoint --paginate --jq '.[].key' | lines
  if $body not-in $have {
    ^gh ssh-key add $pub --type $kind --title (sys host | get hostname)
  }
}

# GitHub auth, per-machine SSH key for auth + commit signing, and the private overlay.
def identity [home: string, profile: string] {
  let key = $home | path join .ssh id_ed25519
  if not ($key | path exists) {
    mkdir ($key | path dirname)
    ^ssh-keygen -t ed25519 -C (sys host | get hostname) -f $key
  }
  if (^gh auth status | complete).exit_code != 0 {
    ^gh auth login --web --git-protocol https --skip-ssh-key --scopes "admin:public_key,admin:ssh_signing_key"
  }
  ensure-gh-key $"($key).pub" authentication user/keys
  ensure-gh-key $"($key).pub" signing user/ssh_signing_keys

  # ~/.gitconfig is the machine-local layer; --file avoids writing into the linked XDG config.
  let local = $home | path join .gitconfig
  ^git config --file $local user.signingkey $"($key).pub"
  ^git config --file $local commit.gpgsign true

  let overlay = $home | path join .dotfiles-work
  if $profile == "work" and not ($overlay | path exists) {
    ^git clone $overlay_repo $overlay
  }
}

def main [
  --profile: string  # base, work or personal; remembered after first use
  --headless         # skip GUI apps, SSH key and GitHub auth (CI)
  --defaults         # apply macOS system preferences
] {
  let home = $env.HOME
  let state = state-file
  let saved = if ($state | path exists) { open $state | str trim } else { "base" }
  let profile = $profile | default $saved
  if $profile not-in [base work personal] { error make {msg: $"unknown profile: ($profile)"} }
  mkdir ($state | path dirname)
  $profile | save -f $state

  [src bin vendor tools] | each {|d| mkdir ($home | path join development $d) } | ignore
  mkdir ($home | path join Documents screenshots)

  install $profile --headless=$headless
  link-all (base-links | resolve $repo $home) $home

  if not $headless { identity $home $profile }

  let overlay = $home | path join .dotfiles-work
  if ($overlay | path exists) {
    let brewfile = $overlay | path join Brewfile
    if ($brewfile | path exists) { install bundle $brewfile }
    link-all (overlay-links $overlay | resolve $overlay $home) $home
  }

  generate-vendor-autoload
  runtimes
  install-skills $home
  if $defaults and $nu.os-info.name == "macos" { defaults }
  print $"done \(profile: ($profile)\)"
}
