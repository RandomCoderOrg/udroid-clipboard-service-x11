#!/bin/bash

FILE=".clipboard"
_c_green="\e[32m"
_c_grey="\e[90m"
_c_reset="\e[0m"

[[ -f $FILE ]] && rm $FILE && touch $FILE

cleanup() {
    rm -rf "$FILE"
    echo
    echo "CLEANUP: Removed $FILE"
    exit 0
}

trap "cleanup;" HUP INT TERM

test run
buffer=$(timeout 6 termux-clipboard-get)
[[ -z $buffer ]] && {
    echo "Test Error"
    echo "Possible reasons:"
    echo "  Clipboard is empty"
    echo "  termux-api is inaccessible"
}

while true; do
    # sleep 2 # just in case if call are too fast
    buffer=$(timeout 6 termux-clipboard-get)
    
    if [[ $(cat $FILE) != "$buffer" ]]; then
        echo "$buffer" > $FILE
        echo "NEW: ${_c_grey}$buffer${_c_reset}"
    fi
done



