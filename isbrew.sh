#!/bin/bash

function brag_and_exit {
    echo -e "Error:\n  $1\n" >&2
    if [ "$(type -t usage)" = 'function' ]; then
        usage >&2
    fi
    exit 1
}

for x in egrep basename sed brew; do
    which -s "$x" || brag_and_exit "Prerequisite '$x' is not on the \$PATH"
done

CACHE="$HOME/.$(basename "$0" | sed 's/\.sh$//').cache.xz"
SED_CMD_DEFAULT='s/\t/ (/; s/\t/): /'
SED_CMD_PATH_ONLY='s/^.*\t//'

function usage {
cat <<EOU
Usage:
  $(basename "$0") [-h] [-f <path>] [-u] [-1] [-g] [-l] [-L] [<file>]

Checks if file is likely to come from NomeBrew

Options:
  -h Print help and exit
  -f Path to HomeBrew files chache file; ~/$(basename $CACHE) if ommited
  -u Update HomeBrew files chache file; might take a few minutes
  -1 Print out just file names, one per line
  -l Run found files through 'ls -lh'
  -L Run found files through 'ls -l'
  -g Search also for g<file>; ex. 'gsed' when looking for 'sed'

EOU
}

while getopts ":f:hu1glL" OPT ; do
    case $OPT in
        h) # Print help and exit
            usage >&2
            exit 0
            ;;
        f) # Cache path
            CACHE="$OPTARG"
            ;;
        u) # Update cache
			UPDATE=1
            ;;
        1) # Like ls -1
			SED_CMD="$SED_CMD_PATH_ONLY"
            ;;
        g) # Include g<file>
			INC_G=1
            ;;
        l) # ls -lh
			SED_CMD="$SED_CMD_PATH_ONLY"
            WRAPPER=ls_minus_lh
            ;;
        L) # ls -l
			SED_CMD="$SED_CMD_PATH_ONLY"
            WRAPPER=ls_minus_l
            ;;
    esac
done

if [ -n "${!OPTIND}" ]; then
    FILE="${!OPTIND}"
fi

if [ -z "${UPDATE}${FILE}" ]; then
    brag_and_exit 'No file to search for'
fi

if [ -z "$UPDATE" ]; then
    if ! [ -e "$CACHE" ]; then
        brag_and_exit "No cache file, please run '$(basename "$0") -u'"
    fi
else
    echo -n 'Updating the HomeBrew files chache file...' >&2
    for type in formula cask; do
        brew list --"$type" \
        | while read package; do
            echo -n '.' >&2
            brew list --"$type" $package \
            | while read path; do
                echo -e "$package\t$type\t$path"
            done
        done
    done \
    | xz -9e >"$CACHE"
    echo ' done!' >&2
fi

function cook_grep_search {
    local FILE_NAME="$(basename "$FILE")"
    if [ -n "$INC_G" ]; then
        echo -n "/g?${FILE_NAME}$"
    else
        echo -n "/${FILE_NAME}$"
    fi
}

function get_list {
    SED_CMD="${SED_CMD:-$SED_CMD_DEFAULT}"
    GREP_SEARCH="$(cook_grep_search)"
    xz -d <"$CACHE" \
    | egrep "$GREP_SEARCH" \
    | sed -E "$SED_CMD"
}

function ls_minus_lh {
    ls -lh "$@"
}

function ls_minus_l {
    ls -l "$@"
}

if [ -n "$FILE" ]; then
    if [ -n "$WRAPPER" ]; then
        "$WRAPPER" $(get_list)
    else
        get_list
    fi
fi

