all: install

help:
	cat Makefile

install:
	git submodule init
	git submodule update
	perl ./copies.pl

anyenv:
	git clone https://github.com/riywo/anyenv.git ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

mac: brew_install

brew_install:
	which brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew bundle
	brew update

brew_dump:
	rm -rf Brewfile
	brew bundle dump

ssh_authorized_keys:
	touch ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
	curl -L http://github.com/takkyuuplayer.keys >>~/.ssh/authorized_keys
