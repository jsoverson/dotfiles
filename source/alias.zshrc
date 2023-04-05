alias ll="ls -alFh"

alias dev="cd $DEV/src"

alias np='np --no-yarn --no-cleanup'

git config --global alias.co checkout

# command to reload this file
function reload_dotfiles() {
  source "$DOTFILES_DIR/source.zshrc"
  cd -
}

alias cplast="fc -ln -1 -1 | pbcopy"

alias reload-local="source ~/local.zshrc"
