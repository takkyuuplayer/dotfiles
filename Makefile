.PHONY: vscode git/ignore

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

link:
	chezmoi apply --mode symlink
	rm -rf ~/.claude/skills
	ln -s $(realpath dot_claude/skills) ~/.claude/skills

GH_EXTENSIONS=$(wildcard $(DIR)gh-extensions/gh-*)

gh:
	@for ext in $(GH_EXTENSIONS); do \
		gh extension remove $${ext##*/} >/dev/null 2>&1 || true; \
		(cd $$ext && gh extension install .) || exit 1; \
	done

GITIGNORE_SRC=$(DIR)gitignore
GITIGNORE_OUT=$(DIR)dot_config/git/ignore
GITIGNORE_RAW=https://raw.githubusercontent.com/github/gitignore/HEAD
GITIGNORE_IO=https://www.toptal.com/developers/gitignore/api

git/ignore:
	@set -eu; \
	trap 'rm -f $(GITIGNORE_OUT).tmp' EXIT; \
	{ \
		cat $(GITIGNORE_SRC)/local; \
		for path in $$(grep -vE '^[[:space:]]*(#|$$)' $(GITIGNORE_SRC)/github); do \
			echo; echo "### $$path"; \
			curl -fsSL "$(GITIGNORE_RAW)/$$path.gitignore"; \
		done; \
		names=$$(grep -vE '^[[:space:]]*(#|$$)' $(GITIGNORE_SRC)/gitignore.io | paste -sd, - || true); \
		[ -z "$$names" ] || { \
			echo; \
			curl -fsSL "$(GITIGNORE_IO)/$$names" | sed -e '/^# Created by /d' -e '/^# Edit at /d' -e '/^# End of /d'; \
		}; \
	} > $(GITIGNORE_OUT).tmp; \
	mv $(GITIGNORE_OUT).tmp $(GITIGNORE_OUT)

mise:
	mise up -y
	mise prune -y
	mise reshim

fish:
	fish -c "fisher update"

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
	brew bundle install

brew/dump:
	brew bundle dump --force --brews --casks --taps
