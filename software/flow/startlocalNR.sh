#!/usr/bin/env bash

# First install node-red locally with npm install in this director

baseDir="."
nrDir="${baseDir}/locNR"
contribDir="${baseDir}/contrib"

flowsDir="${nrDir}/lib/flows"

if [ ! -d "${flowsDir}" ]
then
    mkdir -p "${flowsDir}"
fi

# copy flows to be accessible to Node-RED import
cp -r ${contribDir}/* ${flowsDir}

# start Node-RED
./node_modules/.bin/node-red --settings ./settings.js --userDir "${nrDir}"/
# user: admin, password:password
# https://nodered.org/docs/user-guide/runtime/configuration

# https://github.com/node-config/node-config/wiki/Command-Line-Overrides
## NODE_CONFIG='{"editorTheme":{"library":{"sources":[{"id": "team-collaboration-library","type": "node-red-library-file-store","path": "./","label": "Team collaboration","icon": "font-awesome/fa-users"}]}}}'

