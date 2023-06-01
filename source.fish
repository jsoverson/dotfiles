set DOTFILES_DIR (status dirname)
set -U fish_greeting

set SHELL_EXT "fish"

# helper functions
source "$DOTFILES_DIR/source/functions.fish"

# add dotfiles bin to path
fish_add_path -p "$DOTFILES_DIR/bin"


# add development bin to path
fish_add_path -p "$HOME/development/bin"

# source environment variables
source "$DOTFILES_DIR/source/environment.env"

# source aliases
source "$DOTFILES_DIR/source/alias.fish"

# source platform-specific settings
source "$DOTFILES_DIR/source/source-$(platform).fish"

# source development settings
source "$DOTFILES_DIR/source/development.fish"

# source local file if it exists
if test -f "$HOME/local.fish"
  source "$HOME/local.fish"
end
