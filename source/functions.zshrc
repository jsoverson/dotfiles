function find_text () {
    grep $1 $2
}

function dedupe_pathlike() {
  readonly pathlike=$1
  # split on :
  readonly splitstring=(${(s/:/)pathlike})
  # split on space (" "), typeset -U dedupes list items
  typeset -U parts=(${(@)splitstring})
  # join parts with :
  echo ${(j|:|)parts}
}

function prepend_to_pathlike() {
    echo $(dedupe_pathlike "$2:$1")
}

function append_to_pathlike() {
    echo $(dedupe_pathlike "$1:$2")
}

function prepend_to_path () {
    PATH=$(prepend_to_pathlike "$PATH" "$1")
}

function append_to_path () {
    PATH=$(append_to_pathlike "$PATH" "$1")
}

function platform() {
  echo "$(uname | tr '[:upper:]' '[:lower:]')"
}

function findparentdir() {
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
  mkdir -p $1 && cd $1
}
