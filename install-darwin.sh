#!/bin/bash

set -e

function exists {
  type "$1" 2>/dev/null >/dev/null
}

function brew_install {
  if $(brew list --formula "$1" &> /dev/null); then
    echo "$1 already installed..."
  else
    echo "installing $1..."
    HOMEBREW_NO_INSTALL_UPGRADE=1 HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1 brew install "$1"
  fi
}

function app_store_install {
  if ! exists "$1"; then
    echo "$1 not installed, installing..."
    mas install $2
  else
    echo "$1 installed, skipping..."
  fi
}

# Homebrew
if ! exists "brew"; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew_install jq
brew_install mas
brew_install coreutils || true
brew_install starship
brew_install carapace
brew_install mise

# /End homebrew

# /Begin app store
# app_store_install "/Applications/Slack.app/Contents/MacOS/Slack" 803453959
# app_store_install "/Applications/Keynote.app/Contents/MacOS/Keynote" 409183694
# app_store_install "/Applications/Pixelmator Pro.app/Contents/MacOS/Pixelmator Pro" 1289583905
# /End app store

# #1password
# if ! exists "/Applications/1Password.app/Contents/MacOS/1Password"; then
#   curl -L https://downloads.1password.com/mac/1Password.zip -o /tmp/1password.zip
#   unzip /tmp/1password.zip -d /tmp/1password
#   open /tmp/1password/1Password\ Installer.app/
# fi

# #vscode
# if ! exists "/Applications/Visual Studio Code.app/Contents/MacOS/Electron"; then
#   curl -L "https://code.visualstudio.com/sha/download?build=stable&os=darwin-arm64" -o /tmp/vscode.zip
#   unzip /tmp/vscode.zip -d /Applications
# fi

# if ! exists "/Applications/Alfred.app/Contents/MacOS/Alfred"; then
#   curl -L "https://cachefly.alfredapp.com/Alfred_5.1.4_2195.dmg" -o /tmp/alfred.dmg
#   hdiutil mount /tmp/alfred.dmg
#   cp -r /Volumes/Alfred/Alfred\ 5.app /Applications
# fi

# if ! exists "rustup"; then
#   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# fi

# if ! exists "nvm"; then
#   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
#   source $HOME/.nvm/nvm.sh
#   nvm install node
#   nvm alias default node
# fi

# $DOTFILES_DIR/osx-preferences.sh
