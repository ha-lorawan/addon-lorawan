FROM ghcr.io/home-assistant/amd64-base-debian:bullseye
# FROM debian:bullseye
# FROM ubuntu:22.04

# ARG DEBIAN_FRONTEND=noninteractive

# Install supporting services
RUN apt-get update && apt-get install -y \
    mosquitto \
    mosquitto-clients \
    redis-server \
    redis-tools \
    postgresql \
    python3 \
    procps \
    vim
    
# Postgres Files
COPY pg_hba.conf /etc/postgresql/13/main
COPY pg_setup.sql /

# Configure Chirpstack Debian Repo
RUN apt-get install -y apt-transport-https dirmngr
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1CE2AFD36DBCCA00
RUN echo "deb https://artifacts.chirpstack.io/packages/4.x/deb stable main" | tee /etc/apt/sources.list.d/chirpstack.list
RUN apt-get update

# Install Chirpstack Gateway Bridge
RUN apt-get install -y chirpstack-gateway-bridge
COPY chirpstack-gateway-bridge.toml /etc/chirpstack-gateway-bridge/chirpstack-gateway-bridge.toml

# Install Chirpstack 
RUN apt-get install -y chirpstack

RUN mkdir /var/run/chirpstack
RUN chown -R chirpstack /var/run/chirpstack
RUN mkdir /var/log/chirpstack
RUN chown -R chirpstack /var/log/chirpstack
COPY chirpstack /etc/init.d/chirpstack
RUN chmod +x /etc/init.d/chirpstack

RUN mkdir /var/run/mosquitto
RUN chown -R mosquitto /var/run/mosquitto
COPY mosquitto.conf /etc/mosquitto/
COPY default.conf /etc/mosquitto/conf.d

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Expose Chirpstack Ports
EXPOSE 8080
EXPOSE 1700

# Run run.sh
CMD ["bash", "./run.sh"]