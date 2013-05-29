# Source: https://github.com/kooothor/.dotfiles/blob/master/.zshrc

function extract () {
    if [ -f $1 ] ; then
        case $1 in
        *.tar.bz2) tar xvjf $1 ;;
        *.tar.gz) tar xvzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) rar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xvf $1 ;;
        *.tbz2) tar xvjf $1 ;;
        *.tgz) tar xvzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *.tar.xz) tar xvJf $1 ;;
        *.xz) unlzma $1 ;;
        *) echo "I don't know what '$1' is ..."
           #exit 1 ;;
           ;;

        esac
    else
        echo "'$1': Not a file. WTF?"
#        exit 1
    fi
}
