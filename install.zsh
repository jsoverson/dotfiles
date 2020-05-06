#!/bin/zsh

brew install jq mas

# /Begin app store

#slack 
if ! type "/Applications/Slack.app/Contents/MacOS/Slack" > /dev/null; then
    mas install 803453959
fi

#keynote
if ! type "/Applications/Keynote.app/Contents/MacOS/Keynote" > /dev/null; then
    mas install 409183694
fi


#nordvpn
if ! type "/Applications/NordVPN IKE.app/Contents/MacOS/NordVPN IKE" > /dev/null; then
    mas install 1116599239
fi

# /End app store

#nvm
if [[ ! -a ~/.nvm/nvm.sh ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install --lts
fi

#1password
if ! type "/Applications/iTerm.app/Contents/MacOS/iTerm2" > /dev/null; then
    curl -L https://app-updates.agilebits.com/download/OPM7 -o /tmp/1password.pkg
    open /tmp/1password.pkg
fi

#iterm2
if ! type "/Applications/iTerm.app/Contents/MacOS/iTerm2" > /dev/null; then
    curl -L "https://iterm2.com/downloads/stable/latest" -o /tmp/iterm.zip
    unzip /tmp/iterm.zip -d /Applications
fi

#vscode
if ! type "/Applications/Visual Studio Code.app/Contents/MacOS/Electron" > /dev/null; then
    curl -L "https://go.microsoft.com/fwlink/?LinkID=620882" -o /tmp/vscode.zip
    unzip /tmp/vscode.zip -d /Applications
fi

if ! type "/Applications/Firefox.app/Contents/MacOS/firefox" > /dev/null; then
    curl -L "https://download.mozilla.org/?product=firefox-latest-ssl&os=osx&lang=en-US" -o /tmp/firefox.dmg
    hdiutil mount /tmp/firefox.dmg 
    sudo cp -R "/Volumes/Firefox/Firefox.app" /Applications
    hdiutil unmount "/Volumes/Firefox/"
fi

if ! type "/Applications/Alfred.app/Contents/MacOS/Alfred" > /dev/null; then
    curl -L "https://cachefly.alfredapp.com/Alfred_4.0.9_1144.dmg" -o /tmp/alfred.dmg
    hdiutil mount /tmp/alfred.dmg 
    # sudo cp -R "/Volumes/Firefox/Firefox.app" /Applications
    # hdiutil unmount "/Volumes/Firefox/"
fi



