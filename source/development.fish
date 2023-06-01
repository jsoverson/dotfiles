
function kickstart_node
    mkdir $1 && cd $1 && git init && npm init -y && code .
    echo "Node $(node -v)"
    echo "You're awesome 🤘"
end

set SCRATCH_DIR $DEV/src/scratch

append_to_path $HOME/.cargo/bin
set GOPATH $HOME/go
append_to_path /usr/local/go/bin:$HOME/go/bin
# append_to_path (gem environment | grep "USER INSTALLATION DIRECTORY" | awk  '{ print $5 }')/bin

alias dotenv="dotenv -e '.env.local' -e '.env'"

alias docker-shell="docker run --rm -it --entrypoint /bin/bash"
alias docker-run="docker run --rm"
alias vsdiff="code --diff"


function project-diff -a from to relative_file
    ydiff $from/$relative_file $to/$relative_file
end
