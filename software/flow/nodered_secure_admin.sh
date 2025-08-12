#!/bin/bash
if [ -z "${NR_ADMIN_GW}" ]; then
        export NR_ADMIN_PW="laudsgateway"
fi
export NR_ADMIN_PW_HASH=$(echo -n "${NR_ADMIN_PW}" | node-red-admin hash-pw | tail -n1 | cut -f2 -d' ')


echo -n "${NR_ADMIN_PW_HASH}" > /tmp/scripts/nr_admin.txt

export SEARCH='$2a$08$zZWtXTja0fB1pzD4sHCMyOCMYz2Z6dNbM6tl8sJogENOMcxWV9DN.'
export REPLACE=${NR_ADMIN_PW_HASH}
                                                        
# printf -- 's|%s|%s|g' ${SEARCH} ${REPLACE}

SED_EXPR="$(printf -- 's|%s|%s|g' ${SEARCH} ${REPLACE})"

sed "${SED_EXPR}" /data/settings.js.orig >/data/settings.js
