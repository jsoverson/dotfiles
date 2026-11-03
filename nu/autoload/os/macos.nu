# Equivalent of `brew shellenv`; terminals launch nu directly, so nothing upstream sets these.
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"
# rustup is keg-only in Homebrew; its bin holds the cargo/rustc proxies.
$env.PATH = ["/opt/homebrew/bin" "/opt/homebrew/sbin" "/opt/homebrew/opt/rustup/bin" ...$env.PATH] | uniq
