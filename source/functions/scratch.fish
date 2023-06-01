
function scratch -a lang dir
    if test -z $lang
        set lang rust
    end
    if test -z $dir
        set dir scratch(random)
    end

    if test "$lang" = rust
        cd $SCRATCH_DIR
        cargo new $dir && cd $dir && code .
    else if test "$lang" = node
        echo "Not supported yet"
    end

end
