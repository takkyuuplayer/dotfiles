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
        my @userline = ();
        if (-e "$ENV{'HOME'}/.gitconfig") {
            open(FH, "<$ENV{'HOME'}/$_");
            my $flag = 0;
            while (my $line = <FH>) {
                chomp($line);
                if ($line eq '[user]') {
                    $flag = 1;
                }
                elsif ($line =~ m/^\[.+\]$/) {
                    $flag = 0;
                }
                push(@userline, $line) if $flag;
            }
            close(FH);
        }

        `cp $_ $ENV{'HOME'}`;
        open(FH, ">> $ENV{'HOME'}/$_");
        print FH join("\n", @userline);
        close(FH);
    }
    else {
        `ln -is $Bin/$_ $ENV{'HOME'}` if (readlink("$ENV{'HOME'}/$_") ne "$Bin/$_");
    }
}
