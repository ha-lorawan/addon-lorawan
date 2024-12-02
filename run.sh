#!/usr/bin/with-contenv bashio

service postgresql start
psql -U postgres -f pg_setup.sql

# chown -R mosquitto /var/run/mosquitto
service mosquitto start
service redis-server start

# start chirpstack-gateway-bridge
service chirpstack-gateway-bridge start
# start chirpstack
service chirpstack start

service --status-all

python3 -m http.server 8000