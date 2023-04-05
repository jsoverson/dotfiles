#!/bin/zsh

set -e

export DOTFILES_DIR=$0:A:h

PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"

$DOTFILES_DIR/init/directories

$DOTFILES_DIR/install-$PLATFORM.sh

$DOTFILES_DIR/init/theme
$DOTFILES_DIR/init/git
