#!/usr/bin/with-contenv bashio
service postgresql start
psql -U postgres -f pg_setup.sql
# service mosquitto start
service redis-server start
/usr/sbin/mosquitto -d

sleep 5

ss -l

# tail -f /var/log/mosquitto/mosquitto.log
# echo "mosquitto test 1"
# mosquitto_sub -h localhost -t test
# echo "mosquitto test 2"
# mosquitto_sub -h 127.0.0.1 -t test
# echo END

# sleep 3
# # start chirpstack-gateway-bridge
service chirpstack-gateway-bridge start

sleep 3

# cat /var/log/chirpstack-gateway-bridge/chirpstack-gateway-bridge.log

# cat /etc/mosquitto/mosquitto.conf
# cat /etc/mosquitto/conf.d/default.conf


# /usr/bin/chirpstack-gateway-bridge


# start chirpstack
# service --status-all
/usr/bin/chirpstack -c /etc/chirpstack
# service chirpstack start
# service --status-all
# bash while loop to run command forever

# sleep 2

# tail -f /var/log/chirpstack/chirpstack.log

# while true
# do
#     tail -f /var/log/chirpstack/chirpstack.log
#     service chirpstack status
#     sleep 5
# done

# tail -f /var/log/chirpstack/chirpstack.log

# python3 -m http.server 8000