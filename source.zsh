export DOTFILES_DIR=$0:A:h

source $DOTFILES_DIR/helpers.zsh

prepend_to_path $DOTFILES_DIR/bin
prepend_to_path $HOME/development/bin

source $DOTFILES_DIR/environment.zsh
source $DOTFILES_DIR/alias.zsh

export PATH

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

source "$DOTFILES_DIR/source-$(uname | tr '[:upper:]' '[:lower:]').zsh"
function gitlab() {
  git clone ssh://git@gitlab.lan:30001/$1/$2.git
}
bindkey \^U backward-kill-line

unsetopt share_history
setopt inc_append_history

function wc-actorid() {
  wash claims inspect -o json $1 $2 | jq -r '.module'
}

function wc-providerkey() {
  wash par inspect -o json $1 $2 | jq -r '.public_key'
}

dev
