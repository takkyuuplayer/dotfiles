# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

if [ $? -eq 9 ]; then
        screen
else
        screen -ls
fi


xenv=$HOME/.plenv/bin:$HOME/.rbenv/bin:$HOME/.pyenv/bin:$HOME/.ndenv/bin
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
if [ -d $HOME/.ndenv/bin ]; then
    eval "$(ndenv init -)"
fi
