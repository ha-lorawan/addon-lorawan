#!/bin/bash

# Configuration
DAEMON="/usr/bin/chirpstack"
DAEMON_OPTS="-c /etc/chirpstack create-api-key --name lorawan-integration"

# Execute the command
$DAEMON $DAEMON_OPTS