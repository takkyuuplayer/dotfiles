#! /bin/sh


cd $(dirname $0)

# install vundle.git
git submodule init
git submodule update

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile = '.gitconfig' ]
    then
        cp $dotfile $HOME
    elif [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ] && [ $dotfile != '.gitmodules' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

# zsh
echo "you should install zsh"
