$env.COLORTERM = "truecolor"

$env.DEV = $"($env.HOME)/development"
$env.STARSHIP_CONFIG = $"($env.HOME)/dotfiles/config/starship.toml"

$env.PATH ++= [
    '~/.local/bin'
    ~/dotfiles/bin
    ~/development/bin
]
