# Set path for docker-sync
if which ruby >/dev/null && which gem >/dev/null; then
  append_to_path "$(ruby -r rubygems -e 'puts Gem.user_dir')/bin"
fi

kickstart_node() {
  mkdir $1 && cd $1 && git init && npm init -y && code .
  echo "Node $(node -v)"
  echo "You're awesome 🤘"
}

export GOPATH=$HOME/go
append_to_path /usr/local/go/bin:$HOME/go/bin
