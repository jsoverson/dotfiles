#!/bin/bash

set -e

# oh-my-zsh

if [[ ! -d ~/.oh-my-zsh ]]; then
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Homebrew
if ! type "brew" >/dev/null; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew install jq mas coreutils
fi

# /Begin app store

#slack
if ! type "/Applications/Slack.app/Contents/MacOS/Slack" >/dev/null; then
  mas install 803453959
fi

#keynote
if ! type "/Applications/Keynote.app/Contents/MacOS/Keynote" >/dev/null; then
  mas install 409183694
fi

# /End app store

#1password
if ! type "/Applications/1Password 7.app/Contents/MacOS/1Password 7" >/dev/null; then
  curl -L https://app-updates.agilebits.com/download/OPM7 -o /tmp/1password.pkg
  open /tmp/1password.pkg
fi

#iterm2
if ! type "/Applications/iTerm.app/Contents/MacOS/iTerm2" >/dev/null; then
  curl -L "https://iterm2.com/downloads/stable/latest" -o /tmp/iterm.zip
  unzip /tmp/iterm.zip -d /Applications
fi

#vscode
if ! type "/Applications/Visual Studio Code.app/Contents/MacOS/Electron" >/dev/null; then
  curl -L "https://go.microsoft.com/fwlink/?LinkID=620882" -o /tmp/vscode.zip
  unzip /tmp/vscode.zip -d /Applications
fi

if ! type "/Applications/Alfred.app/Contents/MacOS/Alfred" >/dev/null; then
  curl -L "https://cachefly.alfredapp.com/Alfred_4.0.9_1144.dmg" -o /tmp/alfred.dmg
  hdiutil mount /tmp/alfred.dmg
  # sudo cp -R "/Volumes/Firefox/Firefox.app" /Applications
  # hdiutil unmount "/Volumes/Firefox/"
fi

./osx-preferences.sh
