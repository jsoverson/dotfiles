# Equivalent of `brew shellenv`; terminals launch nu directly, so nothing upstream sets these.
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
$env.PATH = ["/opt/homebrew/bin" "/opt/homebrew/sbin" ...$env.PATH] | uniq
