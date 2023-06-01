export DOTFILES_DIR=$0:A:h

export SHELL_EXT="zshrc"

# rebind ^U to delete to the start of the line, not erase the entire line
bindkey \^U backward-kill-line

# helper functions
source $DOTFILES_DIR/source/functions.zshrc

# add dotfiles bin to path
prepend_to_path $DOTFILES_DIR/bin


# add development bin to path
prepend_to_path $HOME/development/bin

#
source $DOTFILES_DIR/source/environment.env
source $DOTFILES_DIR/source/alias.zshrc

source $DOTFILES_DIR/source/source-$(platform).zshrc
source $DOTFILES_DIR/source/development.zshrc

if [[ -f $HOME/local.zshrc ]]; then
  source $HOME/local.zshrc
fi

setopt INC_APPEND_HISTORY
unsetopt SHARE_HISTORY
unset RPROMPT
