###################################################
# [BASIC SETTING] http://news.mynavi.jp/column/zsh/index.html
###################################################

## auto complete functions
# http://shigeya.org/blog/archives/2008/06/subversion-15-zsh-fix.html
fpath=(${ZDOTDIR}/function $HOME/.zsh/functions $fpath)

## auto complete smartly
autoload -U compinit
compinit -u

##################################################
# Version Controll System setting
#
# http://d.hatena.ne.jp/mollifier/20100906/p1
# http://d.hatena.ne.jp/yonchu/20120506/1336335973
##################################################
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '%s,%u%c,%b'
zstyle ':vcs_info:*' actionformats '%s,%u%c,%b|%a'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

## Display git status
autoload -Uz is-at-least
if is-at-least 4.3.10; then
  # status formats
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:(git|git-svn):*' stagedstr "+"    # not commited
  zstyle ':vcs_info:(git|git-svn):*' unstagedstr "-"  # updated
  zstyle ':vcs_info:git:*' formats '%s,%u%c,%b'
  zstyle ':vcs_info:git:*' actionformats '%s,%u%c,%b|%a'
fi
## How to display on Prompt 
function _update_vcs_info_msg() {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    local _vcs_name _status  _branch_action
    if [ -n "$vcs_info_msg_0_" ]; then
        _vcs_name=$(echo "$vcs_info_msg_0_" | cut -d , -f 1)
        _status=$(_git_untracked_or_not_pushed $(echo "$vcs_info_msg_0_" | cut -d , -f 2))
        _branch_action=$(echo "$vcs_info_msg_0_" | cut -d , -f 3)
        psvar[1]="(${_vcs_name})-[${_status}${_branch_action}]"
    fi
}
add-zsh-hook precmd _update_vcs_info_msg

# git status info function
#   Untracked: ?
#   not PUSHed: *
function _git_untracked_or_not_pushed() {
    local git_status head remotes stagedstr
    local  staged_unstaged=$1 not_pushed="*" untracked="?"
    # whether in git repository or not
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
        # git status on simple formats
        git_status=$(git status -s 2> /dev/null)
        # ^?? line means the exist of untracked file(s)
        if ! echo "$git_status" | grep "^??" > /dev/null 2>&1; then
            untracked=""
        fi

        # get stagedstr
        zstyle -s ":vcs_info:git:*" stagedstr stagedstr
        # ^A line means the exists of staged files(s)
        if [ -n "$stagedstr" ] && ! printf "$staged_unstaged" | grep "$stagedstr" > /dev/null 2>&1 \
            && echo "$git_status" | grep "^A" > /dev/null 2>&1; then
            staged_unstaged=${staged_unstaged}${stagedstr}
        fi

        # get local HEAD hash
        head=$(git rev-parse --verify -q HEAD 2> /dev/null)
        if [ $? -eq 0 ]; then
            # get array of remote HEAD hashes
            remotes=($(git rev-parse --remotes 2> /dev/null))
            if [ "$remotes[*]" ]; then
                for x in ${remotes[@]}; do
                    # Remote hash array contains local hash
                    if [ "$head" = "$x" ]; then
                        # already pushed
                        not_pushed=""
                        break
                    fi
                done
            else
                # Remote not exist
                not_pushed=""
            fi
        else
            # HEAD not exist (like just after git init)
            not_pushed=""
        fi

        # output symbol(s) when untracked or unpushed file(s)
        if [ -n "$staged_unstaged" -o -n "$untracked" -o -n "$not_pushed" ]; then
            printf "${staged_unstaged}${untracked}${not_pushed}"
        fi
    fi
    return 0
}
# Display VCS info on the right
RPROMPT="%1(v|%F{green}%1v%2v%f|)"

###################################################
# Prompt
###################################################
case ${UID} in
0)
    PROMPT="%B%F{red}%/D#%f%b "
    PROMPT2="%B%F{red}%_#%f%b "
    SPROMPT="%B%F{red}%r is correct? [n,y,a,e]:%f%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{white}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%F{yellow}%/$%f "
    PROMPT2="%F{yellow}%_$%f "
    SPROMPT="%F{yellow}%r is correct? [n,y,a,e]:%f "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{white}${HOST%%.*} ${PROMPT}"
    ;;
esac
###################################################
# Terminal
###################################################
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac


###################################################
# History
###################################################
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
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
# OTHER SETTINGS
###################################################

## vi like
#bindkey -v

## options
setopt auto_cd          # auto cd
setopt auto_pushd       # $ cd -[TAB]
setopt correct          # command correction
setopt list_packed      # compact ls
setopt nolistbeep       # no beep sound
setopt noautoremoveslash        # no omit directory/

## prediction
autoload predict-off

###################################################
# Aliases
###################################################

## enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
plugins=(git osx ruby)

## some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

###################################################
# own setting
###################################################
[ -f $HOME/.zshrc_mine ] && source $HOME/.zshrc_mine

alias screen='screen -U'
zstyle ':completion:*:sudo:*' command-path $PATH
umask 0002
