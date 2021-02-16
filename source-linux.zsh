alias wasmdev="docker exec -it wasmcloud-dev tmux -u new -A -s default"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

alias devw="dev && cd wasmcloud-dev-environment/projects/"
