# CLAUDE.md

Personal dotfiles: machine bootstrap plus shell environment. See README.md for layout and flow.

## Rules for this repo

- Write scripts and utilities in nushell. The only POSIX script is `bootstrap.sh`, because it runs before nushell exists.
- zsh stays the login shell (nushell is not POSIX). Interactive terminals launch nushell directly, so nushell config sets its own env (Homebrew, PATH) instead of inheriting it.
- PATH entries shared by both shells go in `config/paths`.
- `install.nu` is re-run as the update command, so every step has to be idempotent.
- The repo is public. Work-specific config (packages, identity, org names) goes in the private overlay `jsoverson/dotfiles-overlay-2026`, cloned to `~/.dotfiles-work`.
- macOS is implemented. `os/linux` and `os/windows` are stubs.

## Nushell config

- New config: add a numbered file to `nu/autoload/`. Nushell loads it on the next shell start.
- Per-OS config: `nu/autoload/os/<os>.nu`, sourced by `00-os.nu`.
- Machine-local overrides: `<nushell config dir>/local.nu`, sourced by `99-local.nu`.
- `use`/`source` paths need parse-time constants. Build them from `path self` (see `install.nu`).

## Tests

```sh
nu tests/link_test.nu
nu tests/nu_config_test.nu
```

CI (`.github/workflows/bootstrap.yml`) runs the headless bootstrap on `macos-latest`, re-runs it, then runs the tests.

## Git

- Conventional commits, lowercase, 1-3 bullet points.
