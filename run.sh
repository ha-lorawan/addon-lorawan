# LoRaWAN Addon Startup Script

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

# keep the container running
while true; do
    sleep 1
done