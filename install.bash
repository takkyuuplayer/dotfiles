#! /bin/bash

cd $(dirname $0)

# install vundle.git
git submodule init
git submodule update

# copying .files
perl ./copies.pl

# xenv
git clone git://github.com/tokuhirom/plenv.git ~/.plenv/
git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv/
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build/
git clone git://github.com/yyuu/pyenv.git ~/.pyenv/
git clone git://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/virtualenv/
