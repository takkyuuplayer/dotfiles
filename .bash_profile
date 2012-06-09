# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/local/bin:$HOME/bin:$PATH

export PATH


#######################################
# SSH-agent
# http://d.hatena.ne.jp/elwoodblues/20070619/1182240574
#######################################
echo -n "ssh-agent: "

source ~/.ssh-agent-info

ssh-add -l >&/dev/null

if [ $? == 2 ] ; then

echo -n "ssh-agent: restart...."

ssh-agent >~/.ssh-agent-info

source ~/.ssh-agent-info

fi

if ssh-add -l >&/dev/null ; then

echo "ssh-agent: Identity is already stored."

else

ssh-add

fi
