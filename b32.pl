#!/usr/bin/perl
# b32.pl - convert to base32
# author: cjc
# from: http://serverfault.com/a/386205
# notes:
#   Really, Linux, no native base32 converter...?

use MIME::Base32 qw( RFC );

undef $/;  # in case stdin has newlines
$string = <STDIN>;

$encoded = MIME::Base32::encode($string);

print "$encoded\n";
