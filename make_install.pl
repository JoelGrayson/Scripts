#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say);

open(FH, '<', './install-parts/install.sh') or die "Can't open install.sh";
open(OUT_FH, '>', './dist/install.sh') or die "Can't open the output FH install.sh";

while (<FH>) {
    my $line=$_;
    
    # Import file by pasting in contents
    if ($line =~ /^###import-file: (.*)$/) {
        my $file_path="./install-parts/$1";
        # say "importing file $file_path";
        open(importing_file_handler, '<', $file_path);
        while (<importing_file_handler>) {
            print OUT_FH $_;
        }
        close(importing_file_handler);
    }
    # Insert templates
    elsif ($line eq "###insert-templates\n") {
        print OUT_FH '{{templates}}';
    }
    # Print line like normal
    else {
        print OUT_FH $line;
    }
}

close(FH);
close(OUT_FH);

# Format:
# ###insert-templates
# ###import-file: scripts

