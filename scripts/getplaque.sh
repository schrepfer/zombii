#!/bin/bash

_url="http://zombiemud.org/top-plaque.php"
_base=${1-$(dirname ${0})}
_file="$(date +%F).txt"

wget -qO - ${_url} | sed -n '/^  1\./,/^1001\./p' > ${_base}/${_file}
