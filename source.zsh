export DOTFILES_DIR=$0:A:h

source $DOTFILES_DIR/helpers.zsh

prepend_to_path $DOTFILES_DIR/bin

source $DOTFILES_DIR/environment.zsh
source $DOTFILES_DIR/alias.zsh

# Add Visual Studio Code (code)
append_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

