
# Add Visual Studio Code (code)
append_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

alias rancher="ssh -t rancher@rancher.lan \"tmux -CC new -A -s default\""
alias wasmdev="ssh -t rancher@rancher.lan \"docker exec -it wasmcloud-dev tmux -u -CC new -A -s default\""
