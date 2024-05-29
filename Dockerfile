FROM bikenow.vkw.tu-dresden.de/priobike/priobike-nginx:v1.0

# Basic auth credentials for the auth service
ARG AUTH_USER=test
ARG AUTH_PASS=test

# Tokens and other passwords for the app
ARG MAPBOX_ACCESS_TOKEN=test
ARG PREDICTION_SERVICE_MQTT_USERNAME=test
ARG PREDICTION_SERVICE_MQTT_PASSWORD=test
ARG PREDICTOR_MQTT_USERNAME=test
ARG PREDICTOR_MQTT_PASSWORD=test
ARG SIMULATOR_MQTT_PUBLISH_USERNAME=test
ARG SIMULATOR_MQTT_PUBLISH_PASSWORD=test
ARG LINK_SHORTENER_API_KEY=test

# Install htpasswd
RUN apt-get update && apt-get install -y apache2-utils
# Create creds for our nginx endpoint
RUN htpasswd -bc /etc/nginx/.htpasswd ${AUTH_USER} ${AUTH_PASS}
# Create nginx endpoint that reads our htpasswd
COPY default.conf /etc/nginx/conf.d/default.conf

# Create config file for the app
RUN echo "{ \
\"mapboxAccessToken\": \"$MAPBOX_ACCESS_TOKEN\", \
\"predictionServiceMQTTUsername\": \"${PREDICTION_SERVICE_MQTT_USERNAME}\", \
\"predictionServiceMQTTPassword\": \"${PREDICTION_SERVICE_MQTT_PASSWORD}\", \
\"predictorMQTTUsername\": \"${PREDICTOR_MQTT_USERNAME}\", \
\"predictorMQTTPassword\": \"${PREDICTOR_MQTT_PASSWORD}\", \
\"simulatorMQTTPublishUsername\": \"${SIMULATOR_MQTT_PUBLISH_USERNAME}\", \
\"simulatorMQTTPublishPassword\": \"${SIMULATOR_MQTT_PUBLISH_PASSWORD}\", \
\"linkShortenerApiKey\": \"${LINK_SHORTENER_API_KEY}\" \
}" > /etc/nginx/config.json
