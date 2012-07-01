#! /bin/sh


cd $(dirname $0)

# install vundle.git
git submodule init
git submodule update

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

# git config ignore
git update-index --assume-unchanged .gitconfig

# zsh
echo "you should install zsh"
