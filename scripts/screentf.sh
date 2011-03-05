#!/bin/bash
#
# This script is used to load tf clients through screen. Just create a symbolic
# link to this script such that it's name is MUD-USER and it will load your tf
# file.
#
# $LastChangedBy$
# $LastChangedDate$
# $HeadURL$
#

_world=$(basename $0)

screen -q -wipe < /dev/null > /dev/null 2>&1

screen -qdr ${_world}

if [ $? -ne 0 ]; then
  screen -S ${_world} tf ${_world}
fi
