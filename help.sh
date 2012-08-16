#!/bin/bash
#
# Use this script in order to create the help files.
#

cd $(dirname $0)

find ./trigs -type f -name '*.tf' -print0 | xargs -0r scripts/doc.py -o help
