export DOTFILES_DIR=$0:A:h

source $DOTFILES_DIR/helpers.zsh

add_to_path_first $DOTFILES_DIR/bin

source $DOTFILES_DIR/environment.zsh
source $DOTFILES_DIR/alias.zsh
source $DOTFILES_DIR/prompt.zsh

