umask 0002

export ZSH=$HOME/.config/zsh/oh-my-zsh

if [ ! -d $ZSH ] ; then
    echo "==> oh-my-zsh not found. Installing."
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH
fi

###################################################
# https://github.com/robbyrussell/oh-my-zsh/blob/master/templates/zshrc.zsh-template
###################################################
DISABLE_AUTO_UPDATE="true"
ZSH_THEME="candy"
CASE_SENSITIVE="true"
plugins=(git svn vi-mode)
source $ZSH/oh-my-zsh.sh

PROMPT=$'%{$fg_bold[green]%}%n@%m %{$fg[blue]%}%D{[%F %T]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} $(git_prompt_info)\
%{$fg[blue]%}%{$fg_bold[blue]%}$%{$reset_color%} '

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
# etc
###################################################
[ -f $HOME/.zshrc_mine ] && source $HOME/.zshrc_mine

if [[ -x `which direnv` ]]; then
    eval "$(direnv hook zsh)"
fi

if [ -d $HOME/.anyenv/bin ]; then
    eval "$(anyenv init -)"
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

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/Users/takafumi.sekiguchi/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;