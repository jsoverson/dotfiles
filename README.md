# dotfiles

Bootstraps a machine and its shell environment. macOS is implemented; Linux and Windows are stubs.

## New machine

```sh
curl -fsSL https://raw.githubusercontent.com/jsoverson/dotfiles/main/bootstrap.sh | sh -s -- --profile work
```

`bootstrap.sh` installs Homebrew (and with it the Command Line Tools), installs nushell, clones this repo to `~/dotfiles`, and runs `install.nu`. Everything after that is nushell.

## Existing machine

```nu
dot                 # re-apply: packages, links, runtimes, git identity, macOS preferences
dot --profile personal
dot --no-defaults   # skip macOS system preferences
```

The profile (`base`, `work`, `personal`) is saved in `~/.config/dotfiles/profile`.

## Resetting the user account

To get a clean home directory without erasing the Mac and going through Setup Assistant, recreate the daily account from a separate admin account. `dot` creates that account (`reset`) on macOS. Log in as `reset` and run:

```sh
~/reset-daily-user
```

`dot` installs it from [`os/macos/reset-daily-user.sh`](os/macos/reset-daily-user.sh) with your user name and UID filled in. It asks for confirmation, deletes the account and its home directory, recreates it with the same UID, grants a FileVault secure token if needed, allows SSH login, and copies `reset`'s `authorized_keys`.

Then log in as that user (or SSH in) and run the new-machine `curl | sh` command. Apps in `/Applications` and `/opt/homebrew` stay installed.

- Keep the same UID: `/opt/homebrew` is owned by the account that installed Homebrew, and a new UID can't run `brew`. A test account with a different UID can't run `dot` past the package step.
- `-adminUser` authenticates as the admin you are logged in as, and that admin needs a secure token itself. An account without a token can't unlock the disk, so it is missing from the FileVault screen after a restart, though it still appears at the normal login window.
- If SSH closes right after `Server accepts key`, the account is missing from `com.apple.access_ssh`. Check with `dseditgroup -o checkmember -m jsoverson com.apple.access_ssh`.
- `dot` creates a new SSH key, so delete the old one from GitHub (`gh ssh-key list`, `gh ssh-key delete`).

## What `dot` does

1. Installs packages: `os/macos/Brewfile`, `Brewfile.apps` (GUI, skipped with `--headless`), `Brewfile.personal` for the personal profile.
2. Symlinks config into place. Anything it replaces moves to `~/.dotfiles-backup/<timestamp>/`.
3. Unless `--headless`: creates `~/.ssh/id_ed25519` if missing, logs into GitHub with `gh`, registers the key for auth and commit signing, and writes the signing settings and this machine's git email (prompted once) to `~/.gitconfig`. The work profile clones the overlay ([jsoverson/dotfiles-overlay-2026](https://github.com/jsoverson/dotfiles-overlay-2026)) to `~/.dotfiles-work`. On macOS, creates the `reset` admin account if missing (prompts for its password, then yours), with a FileVault secure token, SSH access and a copy of `~/.ssh/authorized_keys`, and installs `~/reset-daily-user` in its home.
4. Applies the overlay, if present: its `Brewfile`, its `links.nuon` (`[{src, dest}]`, src relative to the overlay, dest relative to `$HOME`), and its `gitconfig` (included by `config/git/config`).
5. Generates starship and mise init scripts into nushell's vendor autoload dir, runs `mise install`, then `lib/rust.nu`: installs rustup (official installer) or updates it to the latest stable, installs cargo-binstall, binstalls the crates in `config/cargo.nuon` (kache), and runs `kache init --yes --no-shell` unless `--headless`.
6. Installs agent skills listed in `config/skills.nuon` with the [`skills`](https://github.com/vercel-labs/skills) CLI, globally for Claude Code. Files go in `~/.agents/skills`, linked from `~/.claude/skills`. Skills already in `~/.agents/skills` are left alone.
7. On macOS, unless `--no-defaults`: applies system preferences from `os/macos/defaults.nu` (security, UI, typing, screenshots, trackpad, Dock, Finder, widgets, Spotlight categories, power, Colemak keyboard with U.S. in the input menu, Caps Lock as Escape on the built-in keyboard, double-size cursor). Moves cmd+space from Spotlight to Alfred and adds Alfred as a login item, then restarts the affected apps.

## Layout

| Path | Purpose |
| --- | --- |
| `bootstrap.sh` | POSIX shim for a fresh machine |
| `install.nu`, `bin/dot` | Provisioning entry point |
| `lib/link.nu` | Symlink plan/apply |
| `os/<os>/` | Per-OS packages and settings |
| `nu/autoload/` | Nushell config, linked as nushell's autoload dir; `os/<os>.nu` is sourced per OS |
| `config/` | starship, ghostty, mise, git, zsh, shared `paths` list |
| `claude/` | `~/.claude/CLAUDE.md` |
| `tests/` | `nu tests/<name>.nu` |

## Local overrides

- nushell: `<nushell config dir>/local.nu` (secrets, machine-specific env)
- zsh: `~/.zshrc.local`
- git: `~/.gitconfig`
