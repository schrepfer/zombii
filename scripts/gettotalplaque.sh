#!/bin/bash

_url="http://www.zombiemud.org/total-plaque.php"
_base=${1-$(dirname ${0})}
_file="$(date +%F).txt"

wget -qO - ${_url} | sed -n '/^|   1|/,$p' | grep '^|' > ${_base}/${_file}
