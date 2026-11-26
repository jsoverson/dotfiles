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

To get a clean home directory without erasing the Mac and going through Setup Assistant, recreate the daily account from a separate admin account:

```sh
# recreate the account with the same name and UID
sudo sysadminctl -deleteUser jsoverson interactive
sudo sysadminctl -addUser jsoverson -UID 501 -admin -password - interactive
sudo createhomedir -c -u jsoverson

# allow SSH login (only needed if Remote Login is limited to specific users)
sudo dseditgroup -o edit -a jsoverson -t user com.apple.access_ssh

# copy the admin's authorized keys so the same SSH key works
sudo install -d -o jsoverson -g staff -m 700 /Users/jsoverson/.ssh
sudo install -o jsoverson -g staff -m 600 ~/.ssh/authorized_keys /Users/jsoverson/.ssh/authorized_keys
```

Then log in as that user (or SSH in) and run the new-machine `curl | sh` command. Apps in `/Applications` and `/opt/homebrew` stay installed.

- Keep the same UID: `/opt/homebrew` is owned by the account that installed Homebrew, and a new UID can't run `brew`. A test account with a different UID can't run `dot` past the package step.
- `interactive` authenticates as the admin, which grants the new account a FileVault secure token. Check with `sysadminctl -secureTokenStatus jsoverson`.
- If SSH closes right after `Server accepts key`, the account is missing from `com.apple.access_ssh`. Check with `dseditgroup -o checkmember -m jsoverson com.apple.access_ssh`.
- `dot` creates a new SSH key, so delete the old one from GitHub (`gh ssh-key list`, `gh ssh-key delete`).

## What `dot` does

1. Installs packages: `os/macos/Brewfile`, `Brewfile.apps` (GUI, skipped with `--headless`), `Brewfile.personal` for the personal profile.
2. Symlinks config into place. Anything it replaces moves to `~/.dotfiles-backup/<timestamp>/`.
3. Unless `--headless`: creates `~/.ssh/id_ed25519` if missing, logs into GitHub with `gh`, registers the key for auth and commit signing, and writes the signing settings and this machine's git email (prompted once) to `~/.gitconfig`. The work profile clones the overlay ([jsoverson/dotfiles-overlay-2026](https://github.com/jsoverson/dotfiles-overlay-2026)) to `~/.dotfiles-work`.
4. Applies the overlay, if present: its `Brewfile`, its `links.nuon` (`[{src, dest}]`, src relative to the overlay, dest relative to `$HOME`), and its `gitconfig` (included by `config/git/config`).
5. Generates starship and mise init scripts into nushell's vendor autoload dir, runs `mise install`, and sets a default rust toolchain if none exists.
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
