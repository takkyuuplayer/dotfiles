#! /bin/bash

# Check if a value exists in an array
# @param $1 mixed  Needle  
# @param $2 array  Haystack
# @return  Success (0) if value exists, Failure (1) otherwise
# Usage: in_array "$needle" "${haystack[@]}"
# See: http://fvue.nl/wiki/Bash:_Check_if_array_element_exists
in_array() {
    local hay needle=$1
    shift
    for hay; do
        [[ $hay == $needle ]] && return 0
    done
    return 1
}

ignore=('..' '.git' '.gitignore' '.gitmodules')

cd $(dirname $0)

# install vundle.git
git submodule init
git submodule update

in_array '..' "${ignore[@]}"
#create symbolic link
for dotfile in .?*
do
    if [ $dotfile == '.gitconfig' ]
    then
        cp -u $dotfile $HOME
    elif ! in_array $dotfile "${ignore[@]}" && [ "`readlink $HOME/$dotfile`" != "$PWD/$dotfile" ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

# zsh
if [ "`which zsh`" = "zsh not found" ]
then
    echo"you should install zsh"
fi
