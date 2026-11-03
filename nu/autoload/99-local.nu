# Untracked per-machine overrides and secrets: <config dir>/local.nu
const local_file = $nu.default-config-dir | path join local.nu
const local = if ($local_file | path exists) { $local_file } else { null }
source $local
