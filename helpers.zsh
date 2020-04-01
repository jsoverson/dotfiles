find_text () {
    grep $1 $2
}

add_to_path_first () {
    newPath=$1:$PATH
    typeset -U parts
    parts=("${(@s/:/)newPath}")
    PATH=${(j|:|)parts}
}

add_to_path () {
    newPath=$1:$PATH
    typeset -U parts
    parts=("${(@s/:/)newPath}")
    PATH=${(j|:|)parts}
}
