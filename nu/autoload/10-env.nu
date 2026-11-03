$env.COLORTERM = "truecolor"
$env.DOTFILES_DIR = $"($env.HOME)/dotfiles"
$env.DEV = $"($env.HOME)/development"

# config/paths is shared with zsh; first line ends up first in PATH.
$env.PATH = open ($env.DOTFILES_DIR | path join config paths)
  | lines
  | where $it != ""
  | path expand --no-symlink
  | append $env.PATH
  | uniq
