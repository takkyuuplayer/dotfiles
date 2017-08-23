###################################################
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
###################################################
export ZSH=$HOME/.oh-my-zsh
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="candy"
CASE_SENSITIVE="true"
plugins=(git svn vi-mode)
source $ZSH/oh-my-zsh.sh

PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%F %T]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)\
    %{$fg[blue]%}->%{$fg_bold[blue]%} $%{$reset_color%} '

###################################################
# history
###################################################
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt hist_ignore_space    # start [space], no history
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^R' history-incremental-search-backward

###################################################
# zsh setting
###################################################

setopt auto_pushd       # $ cd -[TAB]
setopt correct          # command correction
setopt list_packed      # compact ls
setopt nolistbeep       # no beep sound
setopt noautoremoveslash        # no omit directory/

autoload predict-off    # prediction

###################################################
# Aliases
###################################################

alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alFh'
alias screen='screen -U'
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

###################################################
# own setting
###################################################
[ -f $HOME/.zshrc_mine ] && source $HOME/.zshrc_mine

if [ -d ${HOME}/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    for D in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done

fi

umask 0002

if [[ -x `which direnv` ]]; then
    eval "$(direnv hook zsh)"
fi

function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi

  zle reset-prompt
}

zle -N ghq-fzf
bindkey "" ghq-fzf

# http://www.kasahara.ws/lpm/introduction.html
if [ -d $HOME/lcl ]; then
    source $HOME/lcl/.zshrc
fi
