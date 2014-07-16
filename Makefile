all: install

install:
	git submodule init
	git submodule update
	perl ./copies.pl

plenv:
	git clone git://github.com/tokuhirom/plenv.git ~/.plenv/
	git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/
pyenv:
	git clone git://github.com/yyuu/pyenv.git ~/.pyenv/
	git clone git://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/virtualenv/
rbenv:
	git clone git://github.com/sstephenson/rbenv.git ~/.rbenv/
	git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build/
ndenv:
	git clone git://github.com/riywo/ndenv.git ~/.ndenv/
	git clone git://github.com/riywo/node-build.git ~/.ndenv/plugins/node-build/

