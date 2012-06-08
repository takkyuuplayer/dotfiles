# auto complete functions
fpath=(${ZDOTDIR}/function $HOME/.zsh/functions $fpath)

# auto complete smartly
autoload -U compinit
compinit -u

# LANG
export LANG=ja_JP.UTF-8

# Version Systems
## gitのブランチ名と変更状況をプロンプトに表示する 
autoload -Uz add-zsh-hook
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '%s,%u%c,%b'
zstyle ':vcs_info:*' actionformats '%s,%u%c,%b|%a'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

autoload -Uz is-at-least
if is-at-least 4.3.10; then
  # この check-for-changes が今回の設定するところ
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:(git|git-svn):*' stagedstr "+"    # 適当な文字列に変更する
  zstyle ':vcs_info:(git|git-svn):*' unstagedstr "-"  # 適当の文字列に変更する
  zstyle ':vcs_info:git:*' formats '%s,%u%c,%b'
  zstyle ':vcs_info:git:*' actionformats '%s,%u%c,%b|%a'
fi

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
#    psvar=()
#    LANG=en_US.UTF-8 vcs_info
#    psvar[2]=$(_git_untracked_or_not_pushed)
#    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

#
# Untrackedなファイルが存在するか未PUSHなら記号を出力
#   Untracked: ?
#   未PUSH: *
#
function _git_untracked_or_not_pushed() {
    local git_status head remotes stagedstr
    local  staged_unstaged=$1 not_pushed="*" untracked="?"
    # カレントがgitレポジトリ下かどうか判定
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
        # statusをシンプル表示で取得
        git_status=$(git status -s 2> /dev/null)
        # git status -s の先頭が??で始まる行がない場合、Untrackedなファイルは存在しない
        if ! echo "$git_status" | grep "^??" > /dev/null 2>&1; then
            untracked=""
        fi

        # stagedstrを取得
        zstyle -s ":vcs_info:git:*" stagedstr stagedstr
        # git status -s の先頭がAで始まる行があればstagedと判断
        if [ -n "$stagedstr" ] && ! printf "$staged_unstaged" | grep "$stagedstr" > /dev/null 2>&1 \
            && echo "$git_status" | grep "^A" > /dev/null 2>&1; then
            staged_unstaged=${staged_unstaged}${stagedstr}
        fi

        # HEADのハッシュ値を取得
        #  --verify 有効なオブジェクト名として使用できるかを検証
        #  --quiet  --verifyと共に使用し、無効なオブジェクトが指定された場合でもエラーメッセージを出さない
        #           そのかわり終了ステータスを0以外にする
        head=$(git rev-parse --verify -q HEAD 2> /dev/null)
        if [ $? -eq 0 ]; then
            # HEADのハッシュ値取得に成功
            # リモートのハッシュ値を配列で取得
            remotes=($(git rev-parse --remotes 2> /dev/null))
            if [ "$remotes[*]" ]; then
                # リモートのハッシュ値取得に成功(リモートが存在する)
                for x in ${remotes[@]}; do
                    # リモートとHEADのハッシュ値が一致するか判定
                    if [ "$head" = "$x" ]; then
                        # 一致した場合はPUSH済み
                        not_pushed=""
                        break
                    fi
                done
            else
                # リモートが存在しない場合
                not_pushed=""
            fi
        else
            # HEADが存在しない場合(init直後など)
            not_pushed=""
        fi

        # Untrackedなファイルが存在するか未PUSHなら記号を出力
        if [ -n "$staged_unstaged" -o -n "$untracked" -o -n "$not_pushed" ]; then
            printf "${staged_unstaged}${untracked}${not_pushed}"
        fi
    fi
    return 0
}
RPROMPT="%1(v|%F{green}%1v%2v%f|)"
# RPROMPT="${RESET}%1(v|${RED}%1v|)${RESET}${BOLD_YELLOW}${VIRTUAL_ENV:+($(basename "$VIRTUAL_ENV"))}${RESET}[${MAGENTA}%D{%Y/%m/%d %H:%M:%S}${RESET}]${RESET}"
# Prompt
case ${UID} in
0)
    PROMPT="%B%F{red}$PWD#%f%b "
    PROMPT2="%B%F{red}%_#%f%b "
    SPROMPT="%B%F{red}%r is correct? [n,y,a,e]:%f%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{white}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%F{blue}$PWD$%f "
    PROMPT2="%F{blue}%_$%f "
    SPROMPT="%F{blue}%r is correct? [n,y,a,e]:%f "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%F{white}${HOST%%.*} ${PROMPT}"
    ;;
esac
# Terminal
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac


# History
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
# vi like
#bindkey -v

# options
setopt auto_cd          # auto cd
setopt auto_pushd       # $ cd -[TAB]
setopt correct          # command correction
setopt list_packed      # compact ls
setopt nolistbeep       # no beep sound
setopt noautoremoveslash        # no omit directory/
# prediction
autoload predict-off

# enable color support of ls and also add handy aliases
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


# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
#-------------------------------------
# own setting
#-------------------------------------
[ -f ~/.zshrc.mine ] && source ~/.zshrc_mine

alias vi='vim'
alias screen='screen -U'

umask 0002
