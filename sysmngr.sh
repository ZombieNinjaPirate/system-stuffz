#!/usr/bin/env bash
#
#   Copyright (c) 2014, Are Hansen.
# 
#   All rights reserved.
# 
#   Redistribution and use in source and binary forms, with or without modification, are
#   permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice, this list
#   of conditions and the following disclaimer.
# 
#   2. Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# 
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND AN
#   EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
#   OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
#   SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
#   INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#   TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
#   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
#   WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
declare -rx Script="${0##*/}"


# Clears out any obsolete files in /boot
function clean_boot()
{
    dpkg --get-selections \
    | grep 'linux-image*' \
    | awk '{print $1}' \
    | egrep -v "linux-image-$(uname -r)|linux-image-generic" \
    | while read kern
    do
        sudo apt-get remove $kern -y
    done
}


# Updates/upgrades system, removes and cleans out what can be
function apt_update()
{
    sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean
}


# Updates/upgrades/dist-upgrade system, removes and cleans out what can be.
function apt_update_full()
{
    sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get dist-upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean
}


# Script help information.
function script_help()
{
echo "
    Usage: $Script [argument]

    - Clears out any obsolete files in /boot
    sudo $Script full_boot

    - Shows this help.
    $Script help

    - Updates/upgrades system, removes and cleans out what can be.
    sudo $Script update

    - Updates/upgrades/dist-upgrade system, removes and cleans out what can be.
    sudo $Script full_update
"
}



case "$1" in
    full_update)
        apt_update_full
        ;;
    full_boot)
        clean_boot
        ;;
    help)
        script_help
        exit 1
        ;;
    update)
        apt_update
        ;;
    *)
        echo "Usage: $Script {full_update|full_boot|help|update}"
        exit 1
        ;;
esac


exit 0
