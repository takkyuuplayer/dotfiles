export GREP_OPTIONS="--exclude=\*.svn\* "
export FIND_OPTIONS="-I --color --exclude=\*.svn\* "
export EDITOR="vim"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -d $LPM_LIB/slib ]; then
    export SCHEME_LIBRARY_PATH=$LPM_LIB/slib/
fi

if [ -d $HOME/.composer ]; then
    export PATH=$HOME/.composer/vendor/bin:$PATH
fi

alias perltidy-all="git diff --name-status origin/master... | awk '{print \$2}' | grep -v 'perl5' | grep \"\\\\.pm\$\" | xargs perltidy -b;
git diff --name-status origin/master... | awk '{print \$2}' | grep \"\\\\.t\$\" | xargs perltidy -b;
find ./ -name '*.bak'  | xargs rm;
"
