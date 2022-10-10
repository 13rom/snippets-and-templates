#!/usr/bin/env bash
#
#% SYNOPSIS
#%    ${SCRIPT_NAME} [-h] [-v] [-f] [-p param_value] args ...
#%
#% DESCRIPTION
#%    This is a script template
#%    to start any good shell script.
#%
#% OPTIONS
#%    -h, --help                    Print this help
#%    -v, --verbose                 Print debug information
#%    -f, --flag                    Some flag description
#%    -p, --param                   Some param description
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} -f -p param_value arg1 arg2
#%    ${SCRIPT_NAME} --help
#%
################################################################################
#  DEBUG OPTION
#    set -n  # Uncomment to check your syntax, without execution.
#    set -x  # Uncomment to debug this shell script
#    set -e  # Exit immediately if a command exits with a non-zero status.
#            # Better use trap instead of this.
#    set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
#
################################################################################

usage() {
    headFilter="^#%"
    while IFS= read -r line || [[ -n "$line" ]]; do
        case "$line" in
        '#!'*) # Shebang line
            ;;
        '' | '##'* | [!#]*) # End of Help block
            exit "${1:-0}"
            ;;
        *) # Help line
            printf '%s\n' "${line:2}" | sed -e "s/${headFilter}//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"
            ;;
        esac
    done <"$0"
}

cleanup() {
    trap - SIGINT SIGTERM ERR EXIT
    # script cleanup here
}

setup_colors() {
    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
        NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
    else
        NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
    fi
}

msg() {
    echo >&2 -e "${1-}"
}

die() {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}

parse_params() {
    # default values of variables set from params
    flag=0
    param=''

    while :; do
        case "${1-}" in
        -h | --help) usage 13 ;;
        -v | --verbose) set -x ;;
        --no-color) NO_COLOR=1 ;;
        -f | --flag) flag=1 ;; # example flag
        -p | --param)          # example named parameter
            param="${2-}"
            shift
            ;;
        -?*) die "Unknown option: $1" ;;
        *) break ;;
        esac
        shift
    done

    args=("$@")

    # check required params and arguments
    [[ -z "${param-}" ]] && die "Missing required parameter: param"
    [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

    return 0
}

##  USER FUNCTIONS #############################################################
func1() {
    # check params, size, null and exit 1 when needed

    # logic for-loop
    for projectName in "${projectNames[@]}"; do # array len, both ${#array[*]} and ${#array[@]} ok
        # more array ${array[@]:position:length}, unset array
        func2 $projectName
        # test expressions, most common, for file(-a, -e, -d, -s) , string (-n, -z), int(-eq, -lt), expr, [[ ]]
        if [ "$verbose" = "1" ]; then
            # elif commands; then
            echo -n . 1>&2
        else
            echo "xx"
        fi
    done

    # read files
    # read -t timeout, -p prompt -a array, -n number of characters, -e auto completion, -d,  -s hide, etc.
    # while also support test expr
    while IFS= read -r -d '' FILE; do # IFS default is space(" "), IFS=":" to change it.
        case $FILE in
        *)
            FILENAME=$(basename "$FILE")
            echo "processing file: $FILENAME "
            # handle file
            ;;
        esac
    done < <(find "$DIRECTORY" -type f -name "*.yaml" -print0)
}


##  VARIABLES ##################################################################
SCRIPT_NAME="$(basename ${0})"            # scriptname without path
SCRIPT_DIR="$(cd $(dirname "$0") && pwd)" # script directory
SCRIPT_FULLPATH="${SCRIPT_DIR}/${SCRIPT_NAME}"

SCRIPT_DIR_TEMP="/tmp" # Make sure temporary folder is RW
SCRIPT_TIMELOG_FORMAT="+%y/%m/%d@%H:%M:%S"
HOSTNAME="$(hostname)"
FULL_COMMAND="${0} $*"
EXEC_DATE=$(date "+%y%m%d%H%M%S")
EXEC_ID=${$}
setup_colors

##  PARAMETERS CHECK  ##########################################################
if [[ $# -lt 1 ]]; then
    usage 13
fi

parse_params "$@"

##  MAIN LOGIC  ################################################################
msg "${RED}Read parameters:${NOFORMAT}"
msg "- flag: ${flag}"
msg "- param: ${param}"
msg "- arguments: ${args[*]-}"
