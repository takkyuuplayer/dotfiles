# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# User specific environment and startup programs

if type screen >/dev/null 2>&1; then
    screen -ls
fi
alias tmux='tmux -u'


xenv=$HOME/.plenv/bin:$HOME/.rbenv/bin:$HOME/.pyenv/bin
export PATH=$xenv:$HOME/local/bin:$PATH

if [ -d $HOME/.rbenv/bin ]; then
    eval "$(rbenv init -)"
fi
if [ -d $HOME/.plenv/bin ]; then
    eval "$(plenv init -)"
fi
if [ -d $HOME/.pyenv/bin ]; then
    eval "$(pyenv init -)"
fi
# DO NOT EDIT THE FOLLOWING TWO LINES
#### LPM(/home/takkyuuplayer/lcl)
source /home/takkyuuplayer/lcl/.bash_profile
