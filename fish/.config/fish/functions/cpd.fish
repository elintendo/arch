function cpd --description "cp with directories"
    if test -d $argv[2]
        cp -r $argv[1] $argv[2]
    else
        mkdir -p $argv[2]
        cp -r $argv[1] $argv[2]
    end
end
