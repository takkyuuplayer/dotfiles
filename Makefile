.PHONY: link gh git/ignore mise skills skills/update vscode vscode/dump vscode/extensions brew brew/dump

DIR=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))

AGENT_SKILLS=$(wildcard $(DIR)dot_config/agents/skills/*)
# Claude Code reads only ~/.claude/skills; Codex reads ~/.agents/skills.
AGENT_SKILL_DIRS=$(HOME)/.claude/skills $(HOME)/.agents/skills

link:
	chezmoi apply --mode symlink
	@for dir in $(AGENT_SKILL_DIRS); do \
		mkdir -p $$dir; \
		ln -sfn $(AGENT_SKILLS) $$dir/; \
	done

GH_EXTENSIONS=$(wildcard $(DIR)gh-extensions/gh-*)

gh:
	@for ext in $(GH_EXTENSIONS); do \
		gh extension remove $${ext##*/} >/dev/null 2>&1 || true; \
		(cd $$ext && gh extension install .) || exit 1; \
	done

git/ignore:
	@$(DIR)gitignore/generate

mise:
	mise up -y
	mise prune -y
	mise reshim

skills:
	npx --yes skills add helpfeel/cosense-cli --skill '*' --global --yes --agent codex
	npx --yes skills add mattpocock/skills --skill grilling --global --yes --agent claude-code --agent codex

skills/update:
	npx --yes skills update --global --yes

VSCODE_CONFIG_DIR=${HOME}/Library/Application\ Support/Code/User
VSCODE_CONFIG_FILES=settings.json keybindings.json snippets

vscode: vscode/extensions
	$(foreach config,$(VSCODE_CONFIG_FILES),ln -nis $(DIR)vscode/$(config) $(VSCODE_CONFIG_DIR)/$(config);)

vscode/dump:
	code --list-extensions > $(DIR)vscode/extensions.txt

vscode/extensions:
	@while read -r line; do \
		code --install-extension $$line; \
	done < $(DIR)vscode/extensions.txt

brew:
	which brew || bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew update
	brew bundle install

brew/dump:
	brew bundle dump --force --brews --casks --taps
