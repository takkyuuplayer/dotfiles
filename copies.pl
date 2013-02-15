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
    if($_ eq '.gitconfig' && -e "$ENV{'HOME'}/$_") {
        open(FH, "<$ENV{'HOME'}/$_");
        my @userline = ();
        my $flag = 0;
        while (my $line = <FH>) {
            chomp($line);
            if( $line eq '[user]') {
                $flag = 1;
            } elsif ( $line =~ m/^\[.+\]$/ ) {
                $flag = 0;
            }
            push(@userline, $line) if $flag;
        }
        close(FH);

        `cp $_ $ENV{'HOME'}`;
        open (FH, ">> $ENV{'HOME'}/$_");
        print FH join("\n", @userline);
        close(FH);
    }
    else {
        `ln -is $Bin/$_ $ENV{'HOME'}`
            if (readlink("$ENV{'HOME'}/$_") ne "$Bin/$_");
    }
}
