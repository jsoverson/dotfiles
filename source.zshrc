export DOTFILES_DIR=$0:A:h

source $DOTFILES_DIR/source/helpers.zshrc

prepend_to_path $DOTFILES_DIR/bin
prepend_to_path $HOME/development/bin

source $DOTFILES_DIR/source/environment.zshrc
source $DOTFILES_DIR/source/alias.zshrc

source $DOTFILES_DIR/source/source-$(platform).zshrc
source $DOTFILES_DIR/source/local.zshrc
source $DOTFILES_DIR/source/development.zshrc

bindkey \^U backward-kill-line

unsetopt share_history
setopt inc_append_history

dev
