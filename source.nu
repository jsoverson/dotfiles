const dotfiles_dir = path self | path dirname

$env.DOTFILES_DIR = $dotfiles_dir

$env.SHELL_EXT = "fish"

# # helper functions
# source $"($env.DOTFILES_DIR)/source/functions.fish"

$env.PATH = ($env.PATH | prepend $"($env.DOTFILES_DIR)/bin")

# add development bin to path
$env.PATH = ($env.PATH | prepend $"($env.HOME)/development/bin")

source $"($dotfiles_dir)/source/environment.nu"
source $"($dotfiles_dir)/source/alias.nu"
source $"($dotfiles_dir)/source/source-darwin.nu"

$env.config.history = {
    "max_size": 100000
    "sync_on_enter": true
    "file_format": SQLite
    "isolation": true
    "path": ""
    "ignore_space_prefixed": true
}

$env.config.show_banner = false

# source local file if it exists
if ("~/local.nu" | path exists) {
    source "~/local.nu"
}
