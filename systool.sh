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
set -e
declare -rx Script="${0##*/}"


# Script help information.
function script_help()
{
echo "
    Usage: $Script [argument]

    - Clears out any obsolete files thats filling up the /boot partition.
    $Script clean_boot

    - Shows this help text.
    $Script help

    -Preforms apt-get upgrade and apt-get dist-upgrade.
    $Script dist_upgrade

    - Preforms apt-get upgrade.
    $Script update
"
}


# Clears out any obsolete files thats filling up the /boot partition.
function clear_boot()
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


# Preforms apt-get upgrade
function apt_get_upgrade()
{
    sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean
}


# Preforms apt-get upgrade and apt-get dist-upgrade.
function apt_get_dist_upgrade()
{
    sudo apt-get update \
    && sudo apt-get upgrade -y \
    && sudo apt-get dist-upgrade -y \
    && sudo apt-get autoremove -y \
    && sudo apt-get autoclean
}



case "$1" in
    clean_boot)
        clear_boot
        ;;
    help)
        script_help
        ;;
    dist_upgrade)
        apt_get_dist_upgrade
        ;;
    update)
        apt_get_upgrade
        ;;
    *)
        echo "Usage: $Script help"
        exit 1
        ;;
esac


exit 0
