HOMEBREW=$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)
all: install

install:
	git submodule init
	git submodule update
	perl ./copies.pl

anyenv:
	git clone https://github.com/takkyuuplayer/anyenv ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

mac:
	which brew || ruby -e ${HOMEBREW}
	brew tap Homebrew/brewdler
	brew bundle

brew_dump:
	rm Brewfile
	brew brewdler dump
