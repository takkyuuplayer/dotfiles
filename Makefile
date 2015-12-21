HOMEBREW=$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)

all: install

install:
	git submodule init
	git submodule update
	perl ./copies.pl

anyenv:
	git clone https://github.com/riywo/anyenv.git ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

help:
	cat Makefile

mac:
	which brew || ruby -e ${HOMEBREW}
	brew tap Homebrew/brewdler
	brew bundle

brew_dump:
	rm Brewfile
	brew brewdler dump

ssh_authorized_keys:
	touch ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
	curl -L http://github.com/takkyuuplayer.keys >>~/.ssh/authorized_keys
