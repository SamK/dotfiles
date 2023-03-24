#!/bin/bash

FAVOURITES="
bind9-dnsutils
diffutils
dos2unix
python3-venv
ack
lynx
jq
gzip
zsh
shellcheck
ncdu
git
moreutils
"

package_present () {
    dpkg -s $1 2>/dev/null > /dev/null
}


echo Missing favourite packages:
for package in $FAVOURITES; do
    if  ! package_present $package; then
        echo $package
    fi
done
