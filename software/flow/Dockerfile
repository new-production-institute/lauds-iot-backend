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
COPY --chown=node-red ./contrib/. /data/lib/flows/
COPY --chown=node-red ./models/. /data/models/


USER root
RUN apk add --no-cache \
        python3 \
        py3-pip \
        python3-dev \
        build-base \
        pkgconf \
        openblas-dev \
    && pip3 install --no-cache-dir --upgrade pip --break-system-packages \
    && pip3 install --no-cache-dir joblib numpy scikit-learn pandas --break-system-packages \
    && apk del build-base python3-dev pkgconf
USER node-red