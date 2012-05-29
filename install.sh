#! /bin/sh

########################################
# Name:
#
# about: https://github.com/suzuken/dotfiles/blob/master/install.sh
#	dotfilesをそろそろgithubで管理しとこう | のぶろぐ http://nob-log.info/2012/01/20/dotfilesgithub/
# Usage:
#
# Author:
# Date:
########################################

cd $(dirname $0)

# install vundle.git
git submodule add http://github.com/gmarik/vundle.git ./.vim/bundle/vundle

# create symbolic link
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ] && [ $dotfile != '.gitignore' ]
    then
        ln -Fis "$PWD/$dotfile" $HOME
    fi
done

# git config 無視
git update-index --assume-unchanged .gitconfig

# zsh
echo "zshのインストールよろしく"
