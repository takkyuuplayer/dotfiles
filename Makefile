.PHONY: vscode

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

AGENT_SKILLS=$(wildcard $(DIR)dot_config/agents/skills/*)

link:
	chezmoi apply --mode symlink
	mkdir -p ~/.claude/skills ~/.codex/skills
	ln -sfn $(AGENT_SKILLS) ~/.claude/skills/
	ln -sfn $(AGENT_SKILLS) ~/.codex/skills/

GH_EXTENSIONS=$(wildcard $(DIR)gh-extensions/gh-*)

gh:
	@for ext in $(GH_EXTENSIONS); do \
		gh extension remove $${ext##*/} >/dev/null 2>&1 || true; \
		(cd $$ext && gh extension install .) || exit 1; \
	done

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
