#!/usr/bin/bash

export TEXTDOMAIN=mx-tour
export TEXTDOMAIN_DIR=.
. gettext.sh

pushtext(){  # push text file into var
    local file=${1} var=${2}
    : ${file:=-}
    IFS='' read -r -d '' ${var} < <( eval cat "${file}") || true
}

GETTEXT="$(cat mx-tour)"

for F in text/*; do
    [[ -f ${F}      ]] || continue     # only files
    [[ -z ${F##*.*} ]] && continue  # ignore any backup files with dot
    [[ -z ${F##*~}  ]] && continue  # ignore any backup files with ~

    N=${F##*/}   # basename
    N=${N//-/_}  # replace hyphens with underline

    declare -n nameref=$N
    pushtext "$F" $N
    GETTEXT+="
    $N="'$(gettext '"${nameref@Q})
    "

done

xgettext -v -L SHELL \
        --no-location \
        --no-wrap \
        --sort-output \
        --from-code=UTF-8 \
        --package-name=mx-tour \
        --msgid-bugs-address=swamprabbit@mxlinux.org \
         --output=en.pot -  \
        <<<$GETTEXT

sed -i '/^msgid "gtk30"/,/^msgstr/d' en.pot
exit
