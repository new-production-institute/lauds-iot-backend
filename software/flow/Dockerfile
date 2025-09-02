FROM nodered/node-red

# Copy package.json to the WORKDIR so npm builds all
# of your added nodes modules for Node-RED
COPY ./package.json .
RUN npm install --unsafe-perm --no-update-notifier --no-fund --only=production
RUN mkdir -p /tmp/scripts
COPY --chown=node-red nodered_secure_admin.sh /tmp/scripts
COPY --chown=node-red settings.js /data/settings.js.orig
USER node-red
RUN chmod +x /tmp/scripts/nodered_secure_admin.sh
RUN /tmp/scripts/nodered_secure_admin.sh
USER root
RUN rm /data/flows.json
USER node-red
COPY --chown=node-red flows.json /data/flows.json
COPY --chown=node-red fchh-flows/ /data/lib/flows/fchh-flows/
