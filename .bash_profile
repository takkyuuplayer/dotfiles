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

export PATH=$HOME/.anyenv/bin:$HOME/local/bin:$PATH:$HOME/.composer/vendor/bin

if [ -d $HOME/.anyenv/bin ]; then
    eval "$(anyenv init -)"
    for D in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

# http://www.kasahara.ws/lpm/introduction.html
if [ -d $HOME/lcl ]; then
    source $HOME/lcl/.bash_profile
fi
