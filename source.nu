const dotfiles_dir = path self | path dirname

$env.NUSHELL_CMD = "/opt/homebrew/bin/nu --login --interactive"

$env.DOTFILES_DIR = $dotfiles_dir

$env.PATH ++= [
    ($env.DOTFILES_DIR)/bin
    ($env.HOME)/development/bin
]

^$nu.current-exe ./gen-source.nu source | save -f source-each-generic.nu
^$nu.current-exe ./gen-source.nu source/($nu.os-info.name) | save -f  source-each-platform.nu
source ./source-each.nu

# source local file if it exists
if ("~/local.nu" | path exists) {
    source "~/local.nu"
}
