#!/usr/bin/env bash
# Usage: getopts.sh -a 12 -b "Hello" 192.168.1.116

while getopts "a:bc" OPT; do
    case "${OPT}" in
        a) echo "Found option ${OPT} with ${OPTARG}"; ;;
        b) echo "Found option ${OPT}"; ;;
        c) echo "Found option ${OPT}"; ;;
        *) echo "No options" ;;
    esac
done

# now skip all short options and go to positional parameters
shift $(($OPTIND - 1))

echo ${1}