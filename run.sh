#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json

# LoRaWAN Addon Startup Script
bashio::log.info "Starting LoRaWAN Addon"

# Get Region from Options
REGION=$(bashio::config 'region')
echo "Region: $REGION"

# Copy the appropriate global configuration file based on the region
CONFIG_FILE="/etc/lora/sx1302_hal/packet_forwarder/global_conf.json.sx1250.${REGION}.USB"
TARGET_FILE="/etc/lora/sx1302_hal/packet_forwarder/global_conf.json"

if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "$TARGET_FILE"
    bashio::log.info "Copied $CONFIG_FILE to $TARGET_FILE"
else
    bashio::log.error "Configuration file for region $REGION not found"
    exit 1
fi

# Update chirpstack-gateway-bridge.toml with the appropriate region values
CS_REGION=""
case "$REGION" in
    US915)
        CS_REGION="us915_1"
        ;;
    EU868)
        CS_REGION="eu868"
        ;;
    AS923)
        CS_REGION="as923"
        ;;
    *)
        bashio::log.error "Unsupported region: $REGION"
        exit 1
        ;;
esac

sed -i "s|event_topic_template=.*|event_topic_template=\"${CS_REGION}/gateway/{{ .GatewayID }}/event/{{ .EventType }}\"|g" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml
sed -i "s|command_topic_template=.*|command_topic_template=\"${CS_REGION}/gateway/{{ .GatewayID }}/command/#\"|g" /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

bashio::log.info "Updated chirpstack-gateway-bridge.toml with region $CS_REGION"

# Set User Limits on File Descriptor Values
# start-stop-daemon wasn't working with --background without this
ulimit -n 65536

# start postgresql
service postgresql start
psql -U postgres -f pg_setup.sql

# start redis
service redis-server start

# service mosquitto start
/usr/sbin/mosquitto -d
sleep 5

# start chirpstack-gateway-bridge
service chirpstack-gateway-bridge start

# start chirpstack
service chirpstack start

# start lora_pkt_fwd
service lora-pkt-fwd start

# run chripstack api script
sleep 5
/create-chirpstack-api-key.sh

# add gateway to chirpstack
python3 add-gateway.py

# keep the container running
while true; do
    sleep 1
done