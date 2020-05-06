brew:
	which brew || bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew bundle
	brew update

brew/dump:
	rm -rf Brewfile
	brew bundle dump
