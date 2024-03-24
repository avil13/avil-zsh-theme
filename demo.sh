#!/bin/bash

_demo() {

    # Reset # # # # # # # #
    local off='\033[0m' # Text Reset
    # Regular Colors
    local R='\033[0;31m'
    local G='\033[0;32m'
    local Y='\033[0;33m'
    local B='\033[0;34m'
    local P='\033[0;35m'
    local cyan='\033[0;36m'
    local GR='\033[37m'
    # # # # # # # # # # # #

    clear
    echo -e "${P}branch name     $off"
    echo -e "    │     ${P}hash     $off"
    echo -e "    │      │   ${G}staged     $off"
    echo -e "    │      │     │${R}deleted     $off"
    echo -e "    │      │     │  │${B}changed     $off   "
    echo -e "    │      │     │  │  │ ${Y}new file     $off                          ${B}           status of last command ${off}"
    echo -e "    │      │     │  │  │  │ ${GR}stashes     $off                                                       │"
    echo -e "    │      │     │  │  │  │  │     $off                                                            │ ${off}"
    echo -e "    │      │     │  │  │  │  │     $off                                                            │ ${off}"

    exit 1
            # ⟬master (2d9b2) ●3 ⊖1 ✚1 ≡1⟭ ~/git/GitHub/avil-zsh-theme

}

_demo
