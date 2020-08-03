#!/usr/bin/perl
# b32.pl - convert to base32
# author: cjc
# from: http://serverfault.com/a/386205
# notes:
#   Really, Linux, no native base32 converter...?
#   dependencies:
#     $ sudo apt-get install libmime-base32-perl

use MIME::Base32;

undef $/;  # in case stdin has newlines
$string = <STDIN>;

$encoded = encode_base32($string);

print "$encoded\n";
