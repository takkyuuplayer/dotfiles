# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

export PATH="$HOME/.linuxbrew/bin:$HOME/.anyenv/bin:$HOME/.composer/vendor/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
export LD_LIBRARY_PATH="$HOME/.linuxbrew/lib:$LD_LIBRARY_PATH"

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
