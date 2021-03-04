#!/bin/bash

set -e

sudo apt update && sudo apt upgrade -y

sudo apt install zsh snapd gnome-tweaks xclip vim autokey-gtk openssh-server libssl-dev jq autokey-qt nfs-common -y

sudo snap install --no-wait --edge 1password

sudo snap install code

# Autokey config for mac-like shortcuts
if [[ ! -L $HOME/.config/autokey/data/mac-shortcuts ]]; then
  ln -s $DOTFILES_DIR/config/autokey $HOME/.config/autokey/data/mac-shortcuts
fi

# Install hyper
curl -Lo /tmp/hyper.deb https://github.com/vercel/hyper/releases/download/3.0.2/hyper_3.0.2_amd64.deb
sudo apt-get install /tmp/hyper.deb -y

# Copy Hyper configuration
cp $DOTFILES_DIR/config/hyper/hyper.js $HOME/.hyper.js

# Merge dconf settings

dconf load / <$DOTFILES_DIR/config/dump.dconf

# Albert (linux Alfred)

echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_20.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg >/dev/null
sudo apt update
sudo apt install albert -y

# oh-my-zsh

sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- -p git -t dst -a "source $DOTFILES_DIR/source.zshrc"

# 3 finger drag for laptops
# sudo apt-get install meson libudev-dev libevdev-dev libwacom-dev libgtk-3-dev check -y
# git clone git@github.com:aakside/libinput.git
# cd libinput/
# meson --prefix=/usr builddir/ -Ddocumentation=false
# meson --prefix=/usr builddir/ -son=false
# sudo ninja -C builddir/ install
# sudo systemctl restart gdm3

# LLVM
# try this first
sudo apt-get install llvm -y
# sudo apt-get install libllvm-11-ocaml-dev libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime

# clang
sudo apt-get install clang -y

# docker
sudo apt remove --ignore-missing -y docker docker.io containerd runc
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# docker machine
if [[ ! -x $(which docker-machine) ]]; then
  curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

  # proxmox docker machine driver
  curl -Lo $HOME/development/bin/docker-machine-driver-proxmoxve https://github.com/lnxbil/docker-machine-driver-proxmox-ve/releases/download/v4/docker-machine-driver-proxmoxve.linux-amd64
  chmod a+x $HOME/development/bin/docker-machine-driver-proxmoxve
fi

# docker-compose
if [[ ! -x $(which docker-compose) ]]; then
  curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o ~/development/bin/docker-compose
  chmod a+x ~/development/bin/docker-compose
fi

# nvm & node LTS
if [[ ! -x $(which nvm) ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  source $HOME/.nvm/nvm.sh
fi

# node lts
if [[ ! -x $(which node) ]]; then
  nvm install --lts
fi

# rustup
if [[ ! -x $(which rustup) ]]; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

source $HOME/.cargo/env
cargo install cargo-generate cargo-make cargo-add
rustup target add wasm32-unknown-unknown

# docker-sync
sudo apt -y install ruby2.7-dev
gem install --user-install docker-sync

# unison (for docker-sync)
if [[ ! -x ~/development/bin/unison ]]; then
  LAST=$PWD
  cd /tmp
  sudo apt-get install build-essential ocaml -y
  wget https://github.com/bcpierce00/unison/archive/v2.51.3.tar.gz
  tar xvf v2.51.3.tar.gz
  cd unison-2.51.3
  make UISTYLE=text
  sudo cp src/unison ~/development/bin/unison
  sudo cp src/unison-fsmonitor ~/development/bin/unison-fsmonitor
  cd $LAST
fi