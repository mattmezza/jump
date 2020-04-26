j() {
    local JUMP_VERSION="1.0.0"
    local DB=${JUMP_DB:-"$HOME/.jump"}
    if [ $# -eq 0 ]
    then
        cd $HOME
        return
    elif [ $# -eq 1 ]
    then
        if [[ $1 == -* ]]
        then
            case "$1" in
                "-l"|"--list")
                    cat $DB | sed -E 's/^(.+)\:(.+)$/\1 -> \2/'
                    return
                    ;;
                "-v"|"--version")
                    echo $JUMP_VERSION
                    return
                    ;;
                "-p"|"--db")
                    echo $DB
                    return
                    ;;
                *)
                    # goto help
            esac
        else
            cd $(cat $DB | grep -Em1 "^$1" | sed -E 's/^.*\:(.*)$/\1/')
            return
        fi
    else
        case "$1" in
            "-a"|"--add")
                if [ $# -eq 3 ]
                then
                    echo "$2:$3" >> $DB
                    return
                fi
                ;;
            "-d"|"--delete")
                if [ $# -eq 2 ]
                then
                    sed -Ei '' "/^$2\:.*$/d" $DB
                    return
                fi
                ;;
            "-r"|"--resolve")
                if [ $# -eq 2 ]
                then
                    cat $DB | grep -Em1 "^$2" | sed -E 's/^.*\:(.*)$/\1/'
                    return
                fi
                ;;
            *)
                ;;
        esac
    fi

    cat <<- EOF
Usage:
    j [OPT] ARGS

OPT:
    -r|--resolve
    -a|--add
    -l|--list
    -d|--delete
    -p|--db
    -h|--help
    -v|--version

Examples:
    $ $0 name         # to cd directly into 'name'
    $ $0 -r name      # to resolve 'name'
    $ $0 -a name path # to add 'name' as 'path'
    $ $0 -d name      # to delete 'name'
    $ $0 -l           # to list all entries
    $ $0 -h           # to print this message
    $ $0 -v           # to print the jump version
    $ $0 -p           # to print the path of the DB file

EOF
}
