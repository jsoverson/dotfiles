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
    newPath=$1:$PATH
    typeset -U parts
    parts=("${(@s/:/)newPath}")
    PATH=${(j|:|)parts}
}

kickstart () {
  mkdir $1 && cd $1 && git init && npm init -y && code .
  echo "Node $(node -v)"
  echo "You're awesome 🤘"
}