export GREP_OPTIONS="--exclude=\*.svn\* "
export FIND_OPTIONS="-I --color --exclude=\*.svn\* "
export EDITOR="vim"

if [ -d $LPM_LIB/slib ]; then
    export SCHEME_LIBRARY_PATH=$LPM_LIB/slib/
fi

alias perltidy-all="git diff --name-status origin/master... | awk '{print \$2}' | grep -v 'perl5' | grep \"\\\\.pm\$\" | xargs perltidy -b;
git diff --name-status origin/master... | awk '{print \$2}' | grep \"\\\\.t\$\" | xargs perltidy -b;
find ./ -name '*.bak'  | xargs rm;
"
