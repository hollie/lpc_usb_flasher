#! /usr/bin/env perl

# Flasher tool for programming an LPC ARM controller over USB
#
# On Windows you can use file drag/drop, but on another OS you need to
# ensure no other files get written to the drive (I'm looking at you OS X)
#
# This tool finds the latest binfile in your Downloads folder and flashes it to the
# controller using dd
# Admin rights will be required to run the dd command so you might want to run
# this script using 'sudo' !
#
# Written by Lieven Hollevoet (likatronix.be)
#
# Credits: http://jenswilly.dk/2012/07/flashing-lpc11u24-or-lpc1343-from-mac-os-x/


use strict;
use warnings;
use 5.012;

use Time::localtime;
use File::stat;

# Find latest binfile to flash

my @files = <~/Downloads/*.bin>;

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

# to what device?
my $drive = `df -h | grep "RDB1768"`;

if ($drive =~ /(\/dev\/disk\d+)\s/) {
	$to_flash->{'drive'} = $1;
} else {
	die "No LPC in USB bootloader mode detected! Ensure the device is connected and shows up as /dev/diskx";
}

say "Going to flash $to_flash->{'file'}\n\tcreated " . ctime($to_flash->{'created'}) . "\n\tto device $to_flash->{'drive'}";

# Unmount
my $unmount = `diskutil unmount $to_flash->{'drive'}`;
if ($unmount =~ /Volume.+unmounted/) {
	say $unmount;
} else {
	die "Could not unmount $to_flash->{'drive'}";
}

# dd
my $dd = `dd if=\"$to_flash->{'file'}\" of=$to_flash->{'drive'} seek=4`;

say "Target flashed, reset it to run the code";


