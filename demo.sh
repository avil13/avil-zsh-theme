#!/bin/bash

_demo() {

    # Reset # # # # # # # #
    local off='\033[0m' # Text Reset
    # Regular Colors
    local redBG='\033[0;41m'
    local red='\033[0;31m'
    local green='\033[0;32m'
    local yellow='\033[0;33m'
    local blue='\033[0;34m'
    local purple='\033[0;35m'
    local cyan='\033[0;36m'
    local gray='\033[37m'
    # # # # # # # # # # # #

    clear
    echo -e "${purple}branch name     $off"
    echo -e "    │     ${purple}hash     $off"
    echo -e "    │      │   ${green}staged     $off"
    echo -e "    │      │     │ ${blue}changed     $off"
    echo -e "    │      │     │  │ ${yellow}new file     $off   "
    echo -e "    │      │     │  │  │ ${red}deleted     $off                          ${blue}           status of last command ${off}"
    echo -e "    │      │     │  │  │  │ ${gray}stashes     $off                                                       │"
    echo -e "    │      │     │  │  │  │  │     $off                                                            │ ${off}"
    echo -e "    │      │     │  │  │  │  │     $off                                                            │ ${off}"

    exit 1
}

_demo
