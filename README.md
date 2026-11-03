# dotfiles

Bootstraps a machine and its shell environment. macOS is implemented; Linux and Windows are stubs.

## New machine

```sh
curl -fsSL https://raw.githubusercontent.com/jsoverson/dotfiles/main/bootstrap.sh | sh -s -- --profile work
```

`bootstrap.sh` installs Homebrew (and with it the Command Line Tools), installs nushell, clones this repo to `~/dotfiles`, and runs `install.nu`. Everything after that is nushell.

## Existing machine

```nu
dot                 # re-apply: packages, links, runtimes, git identity
dot --profile personal
dot --defaults      # also apply macOS system preferences
```

The profile (`base`, `work`, `personal`) is saved in `~/.config/dotfiles/profile`.

## What `dot` does

1. Installs packages: `os/macos/Brewfile`, `Brewfile.apps` (GUI, skipped with `--headless`), `Brewfile.personal` for the personal profile.
2. Symlinks config into place. Anything it replaces moves to `~/.dotfiles-backup/<timestamp>/`.
3. Unless `--headless`: creates `~/.ssh/id_ed25519` if missing, logs into GitHub with `gh`, registers the key for auth and commit signing, and writes the signing settings to `~/.gitconfig`. The work profile clones the private overlay to `~/.dotfiles-work`.
4. Applies the overlay, if present: its `Brewfile`, its `links.nuon` (`[{src, dest}]`, src relative to the overlay, dest relative to `$HOME`), and its `gitconfig` (included by `config/git/config`).
5. Generates starship and mise init scripts into nushell's vendor autoload dir, runs `mise install`, and sets a default rust toolchain if none exists.

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
