# manual: eval "$(/opt/homebrew/bin/brew shellenv)"
$env.HOMEBREW_PREFIX = "/opt/homebrew";
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
$env.HOMEBREW_REPOSITORY = "/opt/homebrew";

/opt/homebrew/bin/brew shellenv csh
| lines
| parse --regex 'setenv (\w+) "?(.+)"?;'
| transpose -r
| into record | load-env
