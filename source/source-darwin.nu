# Custom nushell nvm integration
source ./nvm.nu

# Set default node version on startup
nvm use default

# Homebrew bin
$env.Path = ($env.Path | prepend "/opt/homebrew/bin/")
# Add Visual Studio Code (code)
$env.Path = ($env.Path | prepend "/Applications/Visual Studio Code.app/Contents/Resources/app/bin")
# Add cargo bin
$env.Path = ($env.Path | prepend "/Users/jsoverson/.cargo/bin/")

# Add paths that retain most zsh compatibility
$env.Path = ($env.Path | prepend "/usr/local/bin")
$env.Path = ($env.Path | prepend "~/development/vendor/google-cloud-sdk/bin/")

# manual: eval "$(/opt/homebrew/bin/brew shellenv)"
$env.HOMEBREW_PREFIX = "/opt/homebrew";
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
$env.HOMEBREW_REPOSITORY = "/opt/homebrew";

# $env.NU_LIB_DIRS ++= "~/dotfiles/lib/nu"

/opt/homebrew/bin/brew shellenv csh
| lines
| parse --regex 'setenv (\w+) "?(.+)"?;'
| transpose -r
| into record | load-env

$env.PATH ++= [
    $"($env.HOMEBREW_PREFIX)/bin"
    '~/.local/bin'
    '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'
    ~/dotfiles/bin
    ~/development/bin
]

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

use ~/dotfiles/lib/nu/mise.nu
