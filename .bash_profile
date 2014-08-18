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

export PATH=$HOME/.anyenv/bin:$HOME/local/bin:$PATH

if [ -d $HOME/.anyenv/bin ]; then
    eval "$(anyenv init -)"
fi
