#!/bin/bash

first=1

printf '['

apt list --upgradable 2>/dev/null | tail -n +2 | while read -r line
do
    pkg=$(echo "$line" | cut -d'/' -f1)
    available=$(echo "$line" | awk '{print $2}')
    current=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null)

    if echo "$line" | grep -qi security; then
        security=1
    else
        security=0
    fi

    [ $first -eq 0 ] && printf ','
    first=0

    printf '{"pkg":"%s","current":"%s","available":"%s","security":"%s"}' \
        "$pkg" "$current" "$available" "$security"
done

printf ']'
