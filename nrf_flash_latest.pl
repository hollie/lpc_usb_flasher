#! /usr/bin/env perl

# Flasher tool for programming an nRF5x controller via the Segger J-Link programmer
# Relies on the Segger tools and the nrfjprog tool that can be installed with homebrew
#    brew cask install nrf5x-command-line-tools
#
# Written by Lieven Hollevoet
#


use strict;
use warnings;
use 5.012;

use Time::localtime;
use File::stat;

# Find latest binfile to flash

my @files = <~/Downloads/*.hex>;
my $file;
my $to_flash;
$to_flash->{'created'} = 0;
foreach $file (@files) {
#	print "\nFile: $file";
#    print "\n Last access   time: ", ctime( stat($file)->atime );
#    print "\n Last modify   time: ", ctime( stat($file)->mtime );
#    print "\n File creation time: ", ctime( stat($file)->ctime );
#    print "\n File creation time: ", stat($file)->ctime ;
    
    my $created = stat($file)->ctime;
    
    if ($to_flash->{'created'} < $created) {
    	$to_flash->{'created'} = $created;
    	$to_flash->{'file'} = $file;
    }
    
}

say "Going to flash $to_flash->{'file'}\n\tcreated " . ctime($to_flash->{'created'}) . "\n\tto device $to_flash->{'drive'}";

# Execute command
my $cmd = `nrfjprog -s 681684213 --program \"$to_flash->{'file'}\" --chiperase --verify`;

say "Target flashed, reset it to run the code";
