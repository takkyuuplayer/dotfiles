# ~/.bash_logout

if [ $? -eq 9 ]; then
    eval `ssh-agent -k`
fi
