#!/usr/bin/python
# author: mtreece
# date: 2015-08-15
# purpose:
#   compute "New node ID format" from raw id
# notes:
#   see:
#     http://docs.syncthing.net/dev/device-ids.html
#     https://forum.syncthing.net/t/v0-9-0-new-node-id-format/478

import os
import sys
from stdnum import luhn

# base32 alphabet
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

# compute the check digit
def check_digit(chunk):
    return alphabet[-luhn.checksum(chunk, alphabet=alphabet)]

if __name__ == "__main__":
    # this is hacky, I know... patches welcome
    chunks = []
    chunks.append(sys.stdin.read(13))
    chunks.append(sys.stdin.read(13))
    chunks.append(sys.stdin.read(13))
    chunks.append(sys.stdin.read(13))
    for i, chunk in enumerate(chunks):
        sys.stdout.write(chunk[0:7] + "-" + chunk[7:] + check_digit(chunk))
        if i < len(chunks) - 1:
            sys.stdout.write("-")
    sys.stdout.write(os.linesep)

# vim: set et sw=4 ts=4 :
