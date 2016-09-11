#!/usr/bin/env bash
cd `dirname $0` && DIR=$(pwd) && cd -

export ANSIBLE_CONFIG=./ansible.cfg 
export ANSIBLE_HOST_KEY_CHECKING=False

PLAYBBOK="";

function info {
  printf "\033[0;36m${1}\033[0m \n"
}
function note {
  printf "\033[0;33m${1}\033[0m \n"
}
function success {
  printf "\033[0;32m${1}\033[0m \n"
}
function warning {
  printf "\033[0;95m${1}\033[0m \n"
}
function error {
  printf "\033[0;31m${1}\033[0m \n"
  exit 1
}

note "Router ip address:"
read ROUTER_IP

EXTRA_VARS="router_ip=$ROUTER_IP"

function do_something {
  while [[ -z ${PLAYBOOK} ]] || [[ ${PLAYBOOK} -lt 0 ]] || [[ ${PLAYBBOK} -gt 4 ]]; do
    note "Available action:"
    info "[0] Reset configuration"
    info "[1] Base configuration"
    info "[2] Enable OpenDNS"
    info "[3] Enable DMZ"
    info "[4] Enable Dual WAN"
    note "Choose what you want to do:"
    read PLAYBOOK
  done
  
  case ${PLAYBOOK} in
    0)
      ansible-playbook -i "${DIR}/hosts" -v "${DIR}/conf-reset.yml" --extra-vars ${EXTRA_VARS}
    ;;
    1)
      ansible-playbook -i "${DIR}/hosts" -v "${DIR}/conf-base.yml" --extra-vars ${EXTRA_VARS}
    ;;
    2)
      ansible-playbook -i "${DIR}/hosts" -v "${DIR}/conf-opendns.yml" --extra-vars ${EXTRA_VARS}
    ;;
    3)
      ansible-playbook -i "${DIR}/hosts" -vvvv "${DIR}/conf-dmz.yml" --extra-vars ${EXTRA_VARS}
    ;;
    4)
      warning "Playbook not implemented"
    ;;
  esac
  PLAYBOOK=
  
  note "Do you something else? [y/N]"
  read CONFIRM
  
  if [[ "y" = $(echo ${CONFIRM} | awk '{ print tolower($1)}') ]]; then
    do_something
  fi
}

do_something


