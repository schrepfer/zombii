#!/bin/bash
#
# Use this script in order upgrade from a previous release.
#

source install.sh

function main {

  echo "Welcome to Conglomo's Trigs Setup"
  echo " http://www.zombii.org"
  echo

  myread _username "What's your username? " || exit 1

  _username=$(echo ${_username} | tr [A-Z] [a-z])

  local _world="${_mud}-${_username}"

  myread _old_zombii "Where is your old zombii directory? " || exit 1

  if [[ ! -d "${_old_zombii}" ]]; then
    echo
    echo "Could not find zombii/ in that path."
    exit 1
  fi

  local _world_out="${_zombii}/trigs/${_world}.tf"
  local _old_world_out="${_old_zombii}/trigs/${_world}.tf"

  if [[ ! -f "${_old_world_out}" ]]; then
    echo
    echo "Could not find your old world file. Perhaps run install.sh instead?"
    exit 1
  fi

  if [[ ! -f "${_world_out}" ]] || myyn "Did you want to replace your ${_world_out}? "; then
    cp -f ${_old_world_out} ${_world_out}
    chmod 600 ${_world_out}
  else
    echo "Not restoring ${_world_out}.."
  fi

  echo

  for _dir in "save" "logs"; do
    _old_dir="${_old_zombii}/${_dir}/${_world}"
    _dir="${_zombii}/${_dir}/${_world}"
    if [[ ! -d "${_old_dir}" ]]; then
      echo "Creating directory ${_dir}."
      mkdir -p --mode=700 ${_dir}
    else
      echo "Restoring directory ${_dir} from ${_old_dir}."
      rm -rf ${_dir}
      cp -a ${_old_dir} ${_dir}
    fi
  done

  echo

  if myyn "Did you want to create a symbolic link to tf? "; then
    echo "Creating symbolic link for ${_world} in ${_bindir}."
    mkdir -p ${_bindir}
    ln -sf ${_zombii}/scripts/screentf.sh ${_bindir}/${_world}
  else
    echo "Not creating ${_bindir}/${_world}.."
  fi

  echo
  echo "To run type: tf ${_world} (or ${_world})"

}

if [[ "$(basename $0)" == "upgrade.sh" ]]; then
  main
fi
