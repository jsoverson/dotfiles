#!/bin/sh
# Fresh-machine entry point. Installs Homebrew (which brings the Command Line Tools and git),
# installs nushell, clones this repo to ~/dotfiles, then hands off to install.nu.
#
#   curl -fsSL https://raw.githubusercontent.com/jsoverson/dotfiles/main/bootstrap.sh | sh -s -- --profile work
#
# Arguments after `--` are passed to install.nu.
set -eu

DOTFILES_DIR="$HOME/dotfiles"
REPO="https://github.com/jsoverson/dotfiles.git"

case "$(uname -s)" in
  Darwin) ;;
  *) echo "bootstrap.sh: only macOS is implemented" >&2; exit 1 ;;
esac

# Ask for sudo once; keep the timestamp fresh until this process (and the exec'd nu) exits.
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ ! -x /opt/homebrew/bin/brew ]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

brew list --formula nushell >/dev/null 2>&1 || brew install nushell
[ -d "$DOTFILES_DIR/.git" ] || git clone "$REPO" "$DOTFILES_DIR"

# Under `curl | sh`, stdin is the script; give install.nu the terminal for its prompts when there is one.
if (exec </dev/tty) 2>/dev/null; then
  exec nu "$DOTFILES_DIR/install.nu" "$@" </dev/tty
else
  exec nu "$DOTFILES_DIR/install.nu" "$@"
fi
