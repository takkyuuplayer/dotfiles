.PHONY: vscode

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

all: link

help:
	cat Makefile

link:
	perl ./copies.pl

anyenv: ${HOME}/.anyenv ${HOME}/.anyenv/plugins ${HOME}/.anyenv/plugins/anyenv-update ${HOME}/.anyenv/plugins/anyenv-git
${HOME}/.anyenv:
	git clone https://github.com/anyenv/anyenv ~/.anyenv
	-~/.anyenv/bin/anyenv install --force-init

${HOME}/.anyenv/plugins:
	mkdir -p ~/.anyenv/plugins
${HOME}/.anyenv/plugins/anyenv-update:
	git clone https://github.com/znz/anyenv-update.git ~/.anyenv/plugins/anyenv-update
${HOME}/.anyenv/plugins/anyenv-git:
	git clone https://github.com/znz/anyenv-git.git ~/.anyenv/plugins/anyenv-git

ssh_authorized_keys:
	touch ~/.ssh/authorized_keys
	chmod 600 ~/.ssh/authorized_keys
	curl -L http://github.com/takkyuuplayer.keys >>~/.ssh/authorized_keys

fish:
	fish -c "fisher"

fish/dump:
	fish -c "fisher ls > .config/fish/fishfile"

VSCODE_CONFIG_DIR=${HOME}/Library/Application\ Support/Code/User
VSCODE_CONFIG_FILES=settings.json keybindings.json snippets

vscode: vscode/extensions
	$(foreach config,$(VSCODE_CONFIG_FILES),ln -nis ${DIR}/vscode/${config} ${VSCODE_CONFIG_DIR}/${config};)

vscode/dump:
	code --list-extensions > ./vscode/extensions.txt

vscode/extensions:
	@cat ./vscode/extensions.txt | while read line; \
	do \
		code --install-extension $$line; \
	done

brew:
	which brew || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew update
	brew bundle install --no-lock

brew/dump:
	brew bundle dump --force
