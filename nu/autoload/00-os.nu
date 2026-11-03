# Per-OS config. Files in os/ are not autoloaded; only the current OS's file is sourced.
const os_file = path self | path dirname | path join os ($nu.os-info.name + ".nu")
source $os_file
