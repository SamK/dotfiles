#!/bin/bash

function ldap-login () {
    # attempt to connect to a ldap server

    DEFAULT_USER="${USER}"
    [ -n "${LDAP_SERVER}" ] || { >&2 echo ERR: Missing env var LDAP_SERVER ; return 127 ; }
    which ldapsearch || { >&2 echo ERR: cannot execute ldapsearch. Maybe install package java-utils?; return 127 ;}

    printf "LDAP Username [${DEFAULT_USER}]:"
    read LDAP_USERNAME
    [ -z "$LDAP_USERNAME" ] && LDAP_USERNAME=$DEFAULT_USER

    DN=$(ldapsearch -x -H ldaps://${LDAP_SERVER} -s sub "uid=${USERNAME}" | grep 'dn: ' | sed 's/dn: //g')
    ldapsearch -H ldaps://ldap.example.com -D "${DN}" -W > /dev/null
    EXITCODE=$?
    if [[ ${EXITCODE} -eq 0 ]]; then
        echo "Auth success"
    else
        echo "Auth failed"
        exit ${EXITCODE}
    fi

}

ldap-login
