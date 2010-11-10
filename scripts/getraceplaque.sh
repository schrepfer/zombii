#!/bin/bash

_url="http://www.zombiemud.org/race-plaque.php"
_base=${@-$(dirname ${0})}
_file="$(date +%F)-r.txt"

wget -qO - ${_url} | sed -n '/^|   1|/,$p' | grep '^|' > ${_base}/${_file}
