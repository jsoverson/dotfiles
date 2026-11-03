# Symlink manager: plan what to do for each {src, dest}, then apply it.

# Classify one link: ok (already points at src), create (nothing there), replace (something else there).
export def action [src: string, dest: string]: nothing -> string {
  match ($dest | path type) {
    null => "create"
    "symlink" => (if (ls -l $dest | get 0.target) == $src { "ok" } else { "replace" })
    _ => "replace"
  }
}

export def plan [links: list<record<src: string, dest: string>>]: nothing -> table {
  $links | each {|l| $l | insert action (action $l.src $l.dest) }
}

# Apply a plan. Replaced files move under $backup_dir, keeping their path relative to $home.
export def apply [plan: table, backup_dir: string, home: string]: nothing -> table {
  $plan | where action != "ok" | each {|l|
    mkdir ($l.dest | path dirname)
    if $l.action == "replace" {
      let saved = $backup_dir | path join ($l.dest | path relative-to $home)
      mkdir ($saved | path dirname)
      mv $l.dest $saved
    }
    ^ln -s $l.src $l.dest
    $l
  }
}
