ARG BUILD_FROM
FROM $BUILD_FROM

# Install supporting services
RUN apt-get update && apt-get install -y \
    mosquitto \
    mosquitto-clients \
    redis-server \
    redis-tools \
    postgresql \
    python3 \
    procps \
    vim \
    iproute2 \
    screen
    
# Postgres Files
COPY pg_hba.conf /etc/postgresql/13/main
COPY pg_setup.sql /

# Configure Chirpstack Debian Repo
RUN apt-get install -y apt-transport-https dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1CE2AFD36DBCCA00
RUN echo "deb https://artifacts.chirpstack.io/packages/4.x/deb stable main" | tee /etc/apt/sources.list.d/chirpstack.list
RUN apt-get update

RUN apt-get install -y gcc make

# Python packages
RUN apt-get install -y python3-pip
RUN pip3 install chirpstack-api grpcio json5

# Install Chirpstack Gateway Bridge
RUN apt-get install -y chirpstack-gateway-bridge
COPY chirpstack-gateway-bridge.toml /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

# Install Chirpstack 
RUN apt-get install -y chirpstack

RUN mkdir /var/run/chirpstack
RUN chown chirpstack:chirpstack /var/run/chirpstack
RUN mkdir /var/log/chirpstack
RUN chown -R chirpstack:chirpstack /var/log/chirpstack
COPY chirpstack /etc/init.d/chirpstack
RUN chmod +x /etc/init.d/chirpstack

# Copy Chirpstack API Key Script
COPY create-chirpstack-api-key.sh /
RUN chmod +x /create-chirpstack-api-key.sh

RUN mkdir /etc/lora
COPY sx1302_hal /etc/lora/sx1302_hal
RUN cd /etc/lora/sx1302_hal && make

RUN mkdir /var/run/mosquitto
RUN chown -R mosquitto /var/run/mosquitto
COPY mosquitto.conf /etc/mosquitto/
COPY default.conf /etc/mosquitto/conf.d

# lora_pkt_fwd
# Create lora_pkt_fwd user
RUN useradd -r -s /bin/false lora-pkt-fwd
RUN mkdir /var/run/lora-pkt-fwd
RUN chown lora-pkt-fwd /var/run/lora-pkt-fwd
RUN mkdir /var/log/lora-pkt-fwd
RUN chown lora-pkt-fwd /var/log/lora-pkt-fwd
RUN chown -R lora-pkt-fwd /etc/lora/sx1302_hal/packet_forwarder
COPY lora-pkt-fwd /etc/init.d/lora-pkt-fwd
RUN chmod +x /etc/init.d/lora-pkt-fwd
COPY global_conf.json /etc/lora/sx1302_hal/packet_forwarder/global_conf.json

# Copy add gateway script
COPY add-gateway.py /

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Run run.sh
CMD ["./run.sh"]