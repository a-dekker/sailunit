#!/bin/bash
#
set -u

check_params ()
{
    OPTS=$(getopt -o lu:o: --long listunits,units:,owner: -n 'parse-options' -- "$@")
    if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

    while true; do
        case "$1" in
            -l | --listunits ) LISTUNITS=true; shift ;;
            -u | --units ) UNITS="$2"; shift; shift ;;
            -o | --owner ) OWNER="$2"; shift ;;
            -- ) shift; break ;;
            * ) break ;;
        esac
    done
    if [ "${LISTUNITS}" == "true" ]
    then
        get_units
    fi
}

get_units ()
{
    # if [ -z "${CRON_USER}" ]
    # then
    #     echo "No user specified"
    #     exit 1
    # fi
    # also exclude environment settings
    if [ "${OWNER}" == "all" ]
    then
        OWNER="root nemo"
    fi
    if [ "${UNITS}" == "all" ]
    then
        UNITS=""
    else
        UNITS="--type ${UNITS}"
    fi
    for PERSON in ${OWNER}
    do
        if [ "${PERSON}" == "root" ]
        then
            PARAM=""
        else
            PARAM="--user"
        fi
        while read -r RECORD
        do
            IFS=" " read NAME STATE < <(echo ${RECORD})
            TYPE=$(echo ${NAME} | awk -F. '{print $NF}')
            NAME=${NAME%.*}
            echo "${PERSON};${TYPE};${STATE};${NAME}"
        done < <(/bin/systemctl ${PARAM} list-unit-files ${UNITS}|head -n -2 | tail -n +2 | sort --ignore-case)
    done
}

main ()
{
    check_params $@
}

if [ ! -t 1 ]
then
    main $@
fi
