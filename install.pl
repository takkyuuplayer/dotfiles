use utf8;
use strict;
use FindBin qw($Bin);

my @ignore = qw (
    .
    ..
    .git
    .gitignore
    .gitmodules
);

my @files = grep {
    my $file = $_;
    not grep { $_  eq $file } @ignore
    } glob ".*";


for (@files) {
    if($_ eq '.gitconfig') {
    }
    else {
        `ln -Fis $Bin/$_ $ENV{'HOME'}`
            if (readlink("$ENV{'HOME'}/$_") ne "$Bin/$_");
    }
}
