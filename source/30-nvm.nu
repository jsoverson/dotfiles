def --env nvm-fast [...args: string] {
    let nvm_dir = if ($env | get -o NVM_DIR | is-not-empty) { $env.NVM_DIR } else { $"($env.HOME)/.nvm" }
    let nvm_node_path = $"($nvm_dir)/versions/node"

    if ($args | is-empty) {
        print "nvm-fast: at least one argument is required"
        return
    }

    let command = $args.0

    if $command == "use" {
        let target_version = if ($args | length) == 1 {
            if (".nvmrc" | path exists) {
                open .nvmrc | str trim
            } else {
                print "Error: No version provided and no .nvmrc found"
                return
            }
        } else {
            $args.1
        }

        let matched_version = (bash -c $"source ($nvm_dir)/nvm.sh --no-use; nvm_version ($target_version)" | str trim)

        if ($matched_version | is-empty) or $matched_version == "N/A" {
            print $"No version installed for ($target_version), run nvm install ($target_version)"
            print "Installed versions:"
            ls $"($nvm_node_path)/v*" | get name | each {|v| print $" - ($v)" }
        } else {
            let new_path = ($env.PATH | where {|p| not ($p | str starts-with $nvm_node_path) })
            let new_path = if $matched_version != "system" {
                [$"($nvm_node_path)/($matched_version)/bin" ...$new_path]
            } else {
                $new_path
            }
            $env.PATH = $new_path
            $env.NVM_BIN = (which node | get path.0)
        }
    } else {
        bash -c $"source ($nvm_dir)/nvm.sh --no-use; nvm ($args | str join ' ')"
        $env.NVM_BIN = (which node | get -o path.0 | default '')
    }
}

def --env nvm [...args: string] {
    nvm-fast ...$args
}

# Set default node version on startup
nvm use default
