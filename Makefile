.PHONY: vscode

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

BREW=$(shell which brew)
VSCODE=$(shell which code)

all:
	git submodule init
	git submodule update
	perl ./copies.pl

help:
	cat Makefile

anyenv:
	git clone https://github.com/riywo/anyenv.git ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

ssh_authorized_keys:
	touch ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
	curl -L http://github.com/takkyuuplayer.keys >>~/.ssh/authorized_keys

vscode: $(VSCODE) vscode/extensions
	rm -rf ${HOME}/Library/Application\ Support/Code/User/{settings.json,snippets}
	ln -nfs ${DIR}/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	ln -nfs ${DIR}/vscode/snippets ~/Library/Application\ Support/Code/User/snippets

vscode/dump: $(VSCODE)
	$(VSCODE) --list-extensions > ./vscode/extensions.txt

vscode/extensions: $(VSCODE)
	@cat ./vscode/extensions.txt | while read line; \
	do \
		$(VSCODE) --install-extension $$line; \
	done

$(BREW):
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew/install: $(BREW)
	$(BREW) bundle
	$(BREW) update

brew/dump: $(BREW)
	rm -rf Brewfile
	$(BREW) bundle dump
