CREATE ROLE chirpstack WITH LOGIN PASSWORD 'chirpstack';
CREATE DATABASE chirpstack WITH OWNER chirpstack;
\connect chirpstack
CREATE EXTENSION pg_trgm;