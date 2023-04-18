. "$HOME/.cargo/env"

# Set path for docker-sync
if which ruby >/dev/null && which gem >/dev/null; then
  append_to_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

kickstart_node() {
  mkdir $1 && cd $1 && git init && npm init -y && code .
  echo "Node $(node -v)"
  echo "You're awesome 🤘"
}

function cc() {
  cd $1 && code .
}

function mm() {
  mkdir -p $1 && cd $1
}

export GOPATH=$HOME/go
append_to_path /usr/local/go/bin:$HOME/go/bin

alias docker-shell="docker run --rm -it --entrypoint /bin/bash"
alias docker-run="docker run --rm"
alias vsdiff="code --diff"

function new-scratch() {
  dir1=$1
  cargo new $1 && cd $1 && code .
}

function project-diff() {
  dir1=$1
  dir2=$2
  file=$3

  ydiff $dir1/$file $dir2/$file
}

source ~/.nvm/nvm.sh