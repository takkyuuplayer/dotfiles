# .bash_profile
umask 0002

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

if [ -d /home/linuxbrew/.linuxbrew ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
elif [ -d ~/.linuxbrew ]; then
    eval $(~/.linuxbrew/bin/brew shellenv)
fi
