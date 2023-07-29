export DOCKER_BUILDKIT=1
export FIND_OPTIONS="-I --color --exclude=\*.svn\* "
export EDITOR="nvim"
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

if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

if [[ -x `which anyenv` ]]; then
  eval "$(anyenv init -)"
fi

if [[ -x `which go` ]]; then
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
fi

if [ -d ${HOME}/.deno ]; then
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
fi

if [ -d ${HOME}/.cargo ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

alias awslocal="aws --endpoint-url=http://localhost:4566 --cli-auto-prompt"
alias docker-balus="docker system prune -fa && docker volume ls -q | xargs docker volume rm"
alias docker-image-versions='(){ curl -s https://registry.hub.docker.com/v2/repositories/$1/tags/ | jq '.' | grep name | sort }'
alias docker-run-here="docker run --volume=\$PWD:/srv:cached -w=/srv"
alias mkdir="mkdir -p"
if [[ -x `which nvim` ]]; then
    alias vim="nvim"
fi
alias vimtutor="vimtutor ja"
alias git-clone-many="(){gh repo list \$1 --limit \${2:-30} --no-archived --json url --jq '.[].url' | ghq get -p -P}"
