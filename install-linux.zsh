#!/bin/zsh

sudo apt update && sudo apt upgrade -y

sudo apt install zsh snapd gnome-tweaks xclip vim autokey-gtk openssh-server libssl-dev jq -y

snap install --edge 1password

# oh my zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3 finger drag
sudo apt-get install meson libudev-dev libevdev-dev libwacom-dev libgtk-3-dev check -y
git clone git@github.com:aakside/libinput.git
cd libinput/
meson --prefix=/usr builddir/ -Ddocumentation=false
meson --prefix=/usr builddir/ -Ddocumentation=false
sudo ninja -C builddir/ install
sudo systemctl restart gdm3

# LLVM
# try this first
sudo apt-get install llvm -y
# sudo apt-get install libllvm-11-ocaml-dev libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime

# clang

sudo apt-get install clang -y

# docker
apt remove docker docker-engine docker.io containerd runc
sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# docker machine

curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  chmod +x /tmp/docker-machine &&
  sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

# docker-compose

curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o ~/development/bin/docker-compose
chmod a+x ~/development/bin/docker-compose

# rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-generate
rustup target add wasm32-unknown-unknown

# docker-sync

sudo apt install ruby2.7-dev
gem install --user-install docker-sync

# unison (for docker-sync)
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
