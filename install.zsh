#!/bin/zsh

#nvm
if [[ ! -a ~/.nvm/nvm.sh ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install --lts
fi

