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

print join("\n", @files);
