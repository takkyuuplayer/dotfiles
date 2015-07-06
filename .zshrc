# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="candy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git svn)
source $ZSH/oh-my-zsh.sh

[ -f $HOME/.zshrc_mine ] && source $HOME/.zshrc_mine

if [ -d $HOME/.anyenv/bin ]; then
    eval "$(anyenv init -)"
    for D in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

alias screen='screen -U'
zstyle ':completion:*:sudo:*' command-path $PATH
umask 0002
