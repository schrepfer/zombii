#!/bin/bash
#
# Use this script in order to create your basic .tfrc.
#

function myread {

  local _var=${1}
  local _msg=${2}
  local _opts=${3}
  local _try=0

  while [[ -z "${!_var}" && "${_try}" -lt ${_tries} ]]; do
    echo -n "${_msg}"
    read ${_opts} ${_var}
    _try=$((_try + 1))
  done

  if [[ -z ${!_var} ]]; then
    echo
    echo "Giving up after ${_try} tries."
    return 1
  fi

  return 0

}

function myyn {

  local _msg=${1}
  local _answer=""

  echo -n "${_msg}"
  read _answer
  echo

  if [[ "${_answer}" != "yes" && "${_answer}" != "y" ]]; then
    return 1
  fi

  return 0

}

function main {

  if [[ ! -f "${_tfrc_example}" ]]; then
    echo "Could not find ${_tfrc_example}."
    exit 1
  fi

  if [[ ! -f "${_world_example}" ]]; then
    echo "Could not find ${_world_example}."
    exit 1
  fi

  echo "Welcome to Conglomo's Trigs Setup"
  echo " http://www.zombii.org"
  echo

  myread _username "What's your username? " || exit 1

  _username=$(echo ${_username} | tr [A-Z] [a-z])

  if ! myread _password "What's your password? " -s; then
    echo "Skipping password."
  fi

  echo

  local _world="${_mud}-${_username}"

  if [[ ! -f "${_tfrc_out}" ]] || myyn "Did you want to replace your ${_tfrc_out}? "; then
    echo "Creating ${_tfrc_out} from ${_tfrc_example}."
    if [[ -z "${_password}" ]]; then
      sed -e "s#_USERNAME_##g" \
          -e "s#_PASSWORD_##g" \
          -e "s#_WORLD_#${_world}#g" \
          -e "s#_ZOMBII_#${_zombii}#g" < ${_tfrc_example} > ${_tfrc_out}
    else
      sed -e "s#_USERNAME_#${_username}#g" \
          -e "s#_PASSWORD_#${_password}#g" \
          -e "s#_WORLD_#${_world}#g" \
          -e "s#_ZOMBII_#${_zombii}#g" < ${_tfrc_example} > ${_tfrc_out}
    fi
    chmod 600 ${_tfrc_out}
    echo "Creating symbolic link to ${_tfrc_out} at ${_tfrc_real}."
    ln -sf ${_tfrc_out} ${_tfrc_real}
  else
    echo "Not creating ${_tfrc_out}.."
  fi

  for _dir in "save" "logs"; do
    _dir="${_zombii}/${_dir}/${_world}"
    echo "Creating directory ${_dir}."
    mkdir -p -m 700 ${_dir}
  done

  echo

  local _world_out="${_zombii}/trigs/${_world}.tf"

  if [[ ! -f "${_world_out}" ]] || myyn "Did you want to replace your ${_world_out}? "; then
    echo "Creating ${_world_out} from ${_world_example}."
    sed -e "s#_USERNAME_#${_username}#g" \
        -e "s#_WORLD_#${_world}#g" < ${_world_example} > ${_world_out}
    chmod 600 ${_world_out}
  else
    echo "Not creating ${_world_out}.."
  fi

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
  echo

}

cd $(dirname $0)

_mud="zombie"
_zombii="$(pwd)"
_bindir="${HOME}/bin"
_tfrc_example="${_zombii}/tfrc_example"
_tfrc_out="${_zombii}/tfrc"
_tfrc_real="${HOME}/.tfrc"
_world_example="${_zombii}/trigs/example.tf"
_tries="3"

if [[ "$(basename $0)" == "install.sh" ]]; then
  main
fi
