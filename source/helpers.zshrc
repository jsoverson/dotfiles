find_text () {
    grep $1 $2
}

prepend_to_path () {
    newPath=$1:$PATH
    typeset -U parts
    parts=("${(@s/:/)newPath}")
    PATH=${(j|:|)parts}
}

append_to_path () {
    newPath=$PATH:$1
    typeset -U parts
    parts=("${(@s/:/)newPath}")
    PATH=${(j|:|)parts}
}

platform() {
  echo "$(uname | tr '[:upper:]' '[:lower:]')"
}

findparentdir() {
  platform="$(getplatform)"
  rl=$(which readlink)
  if [ "$platform" == "" ]; then
    rl=$(which greadlink)
  fi
  rl="$rl -f"

  # if path is not a symlink
  if [ ! -L $0 ]; then
    VAR="$(dirname $0)/.."
  else
    if env readlink >/dev/null; then
      VAR="$(dirname $(rl $0))/.."
    else
      VAR="~/.dotfiles"
    fi
  fi

  VAR="$($rl $VAR)"
  echo $VAR
}

# md = mkdir && cd
function md() {
  mkdir -p $1
  cd $1
}
