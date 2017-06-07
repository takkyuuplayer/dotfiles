export FIND_OPTIONS="-I --color --exclude=\*.svn\* "
export EDITOR="vim"
export LESS="-giMRW -z-4"
export PAGER=less
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

if [ -d $LPM_LIB/slib ]; then
    export SCHEME_LIBRARY_PATH=$LPM_LIB/slib/
fi

if [ -d $HOME/.composer ]; then
    export PATH=$HOME/.composer/vendor/bin:$PATH
fi

alias perltidy-all="git diff origin/master... --name-only --diff-filter=AMCRTU | perl -wnle '/\.(pl|pm|t|psgi)$/ and print' | xargs perltidy -b -bext='/'"
alias mocha='mocha --require intelli-espower-loader'
alias vimtutor="vimtutor ja"
alias docker-image-versions='(){ curl -s https://registry.hub.docker.com/v2/repositories/$1/tags/ | jq '.' | grep name | sort }'
alias mkdir="mkdir -p"
alias exit-code="echo $?"
