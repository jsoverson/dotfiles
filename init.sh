#!/bin/bash

set -e

DOTFILES_DIR="$(readlink -f $(dirname $0))"
export DOTFILES_DIR
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"

$DOTFILES_DIR/init/directories

$DOTFILES_DIR/install-$PLATFORM.sh

$DOTFILES_DIR/init/theme
$DOTFILES_DIR/init/git
