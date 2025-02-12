#!/bin/bash

# Configuration
DAEMON="/usr/bin/chirpstack"
DAEMON_OPTS="-c /etc/chirpstack create-api-key --name lorawan-integration"
OUTPUT_FILE="/etc/chirpstack/api-key"

# Execute the command and save the output to a JSON file
$DAEMON $DAEMON_OPTS > $OUTPUT_FILE