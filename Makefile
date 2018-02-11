.PHONY: vscode

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

BREW=$(shell which brew)
VSCODE=$(shell which code)

all: link ${HOME}/.config/zsh/oh-my-zsh

help:
	cat Makefile

link:
	perl ./copies.pl

anyenv:
	git clone https://github.com/riywo/anyenv.git ~/.anyenv
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update

ssh_authorized_keys:
	touch ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
	curl -L http://github.com/takkyuuplayer.keys >>~/.ssh/authorized_keys

${HOME}/.config/zsh/oh-my-zsh:
	git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.config/zsh/oh-my-zsh

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
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew/install: $(BREW)
	$(BREW) bundle
	$(BREW) update

brew/dump: $(BREW)
	rm -rf Brewfile
	$(BREW) bundle dump
