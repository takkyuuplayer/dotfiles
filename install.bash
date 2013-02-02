#! /bin/bash

cd $(dirname $0)

# install vundle.git
git submodule init
git submodule update

# copying .files
perl ./copies.pl
