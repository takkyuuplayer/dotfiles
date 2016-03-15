HOMEBREW=$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)
all: install

help:
	cat Makefile


install: install-dein
	git submodule init
	git submodule update
	perl ./copies.pl

install-dein:
	curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
	sh ./installer.sh ~/.dein/
	rm installer.sh

anyenv:
	git clone https://github.com/riywo/anyenv.git ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
ndenv:
	ndenv install v5.4.1
	ndenv global v5.4.1

phpenv:
	phpenv install 7.0.2
	phpenv global 7.0.2

plenv:
	plenv install 5.22.0
	plenv global 5.22.0
	plenv install-cpanm
	plenv rehash
	cpanm install Perl::Tidy
	cpanm install Carton

rbenv:
	rbenv install 2.3.0
	rbenv global 2.3.0
	rbenv rehash
	gem install bundler

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
