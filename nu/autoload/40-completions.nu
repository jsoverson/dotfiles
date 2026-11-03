let carapace_completer = {|spans: list<string>|
    # carapace prints nothing for commands it has no spec for, so `from json`
    # yields null; a real "no matches" answer is an empty list.
    CARAPACE_LENIENT=1 carapace $spans.0 nushell ...$spans | from json
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    let completions = try { do $carapace_completer $spans } catch { null }

    # Returning null (not []) tells nushell to fall back to its built-in
    # file/path completion. [] means "no completions" and shows nothing.
    if ($completions | is-empty) { null } else { $completions }
}

$env.config.completions.external = {
    enable: true
    completer: $external_completer
}

$env.config.completions.algorithm = "substring"
$env.config.completions.quick = true
$env.config.completions.partial = true
$env.config.completions.case_sensitive = true
