# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repository contains personal dotfiles and shell configuration for macOS and Linux systems, using Nushell as the primary shell. It manages system initialization, environment configuration, and development tools through a modular sourcing system.

## Key Architecture

1. **init.sh** - Initial setup script (runs once on new system)
2. **source.nu** - Main Nushell entry point
3. **Modular Source System** (source/ directory)
4. **Local Overrides** (~/.local.nu)
5. **Local bins** (./bin)

### System Setup

```bash
# Initial system setup
./init.sh

# Platform-specific dependencies
./install-darwin.sh  # macOS (via Homebrew)
./install-linux.sh   # Linux (via apt, tmux, autokey)
```

### Configuration

- **starship.toml** - Prompt theme configuration (can switch to starship-screencast.toml for presentations)
- **~/.local/bin**, ~/dotfiles/bin - User scripts and binaries
- **~/development/bin** - Development tools and scripts

## Development Notes

### Modifying Shell Configuration

- **Adding new configuration**: Create a new file in source/ with appropriate numbering (e.g., source/50-my-config.nu). It will be auto-sourced on next shell startup.
- **Platform-specific changes**: Place in source/macos/ or source/linux/ directories; loaded after generic files.
- **Testing changes**: Source the file directly or restart the shell (new terminal window).
- **Local overrides**: Add to ~/.local.nu (sourced after all other files, safe from git tracking).

This ensures new source files are automatically discovered without manual registration.

### mise Integration

Version managers (Node, Ruby, Python, etc.) are configured through mise. The mise.nu wrapper:
- Parses mise environment hooks
- Integrates with Nushell's environment system
- Automatically activated on directory change (pwd hook)

### Completion System

Priority order for external completions:
1. Carapace (default) for most tools
2. Fish completer for: git, nu, asdf (better branch/commit/plugin name completion)
3. Configurable via external_completer in $env.config.completions

## Code Style

- Nushell scripts use functional patterns where possible
- Environment modifications done via load-env or env.PATH operations
- Helper functions prefixed appropriately (nvm-fast, parse vars, update-env)
- Error handling via early return with print statements

## Git Workflow

- User: Jarrod Overson (jsoverson@gmail.com)
- Uses conventional commits (lowercase, with bullet points)
- cm tool generates commits from staged changes automatically
