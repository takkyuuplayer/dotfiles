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
        `cp $_ $ENV{'HOME'}` and next if not -f "$ENV{'HOME'}/.gitconfig";

        my @userline = split "\n", `git config --list --global | grep user | sed 's/=/ /g'`;
        `cp $_ $ENV{'HOME'}`;
        map { `git config --global $_`; } @userline;
    }
    else {
        symbolic_link("$Bin/$_", "$ENV{'HOME'}/$_");
    }
}

sub symbolic_link {
    my ($src, $dest) = @_;
    `ln -ins $src $dest` if readlink($dest) ne $src;
}
