
set -Ux --path fish_function_path $fish_function_path "$DOTFILES_DIR/source/functions"

# md = mkdir && cd
function md -a dir
  mkdir -p $dir && cd $dir
end
