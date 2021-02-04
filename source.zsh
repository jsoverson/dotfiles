
export DOTFILES_DIR=$0:A:h

source $DOTFILES_DIR/helpers.zsh

prepend_to_path $DOTFILES_DIR/bin
prepend_to_path $HOME/development/bin

source $DOTFILES_DIR/environment.zsh
source $DOTFILES_DIR/alias.zsh

# Add Visual Studio Code (code)
append_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH

alias rancher="ssh -t rancher@rancher.lan \"tmux -CC new -A -s default\""
alias wasmdev="ssh -t rancher@rancher.lan \"docker exec -it wasmcloud-dev tmux -u -CC new -A -s default\""

# command to reload this file
alias reload_dotfiles="source $DOTFILES_DIR/source.zsh"

# md = mkdir && cd
function md() {
  mkdir -p $1
  cd $1
}

# Set up default docker environment
eval $(docker-machine env workhorse)

# Set path for docker-sync
if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
