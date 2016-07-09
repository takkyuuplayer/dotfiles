use utf8;
use strict;
use FindBin qw($Bin);

my @ignore = qw (
    .
    ..
    .git
    .gitignore
    .gitmodules
    .DS_Store
);

my @files = grep {
    my $file = $_;
    not grep { $_ eq $file } @ignore
} glob ".*";

for (@files) {
    if (-e "$ENV{'HOME'}/$_" && readlink("$ENV{'HOME'}/$_") ne "$Bin/$_") {
        `mkdir -p $Bin/backup && cp -rp $ENV{'HOME'}/$_ $Bin/backup/`;
    }

    if ($_ eq '.gitconfig') {
        my @userline = split "\n", `git config --list --global | grep user | sed 's/=/ /g'`;
        `cp $_ $ENV{'HOME'}`;
        map { `git config --global $_`; } @userline;
    }
    elsif ($_ eq '.config') {
        `mkdir -p $ENV{'HOME'}/.config`;
        map { symbolic_link("$Bin/$_", "$ENV{'HOME'}/$_"); }
            grep {
            my $file = $_;
            not grep { $_ eq $file } @ignore
            } glob ".config/*";
    }
    else {
        symbolic_link("$Bin/$_", "$ENV{'HOME'}/$_");
    }
}

symbolic_link("$Bin/.config/nvim/init.vim", "$ENV{'HOME'}/.vimrc");
symbolic_link("$Bin/.config/nvim",          "$ENV{'HOME'}/.vim");

sub symbolic_link {
    my ($src, $dest) = @_;
    `ln -is $src $dest` if readlink($dest) ne $src;
}
