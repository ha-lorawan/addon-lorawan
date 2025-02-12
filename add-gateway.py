import grpc
from chirpstack_api import api
import json5

# Configuration.
# Read the gateway ID from the JSON configuration file.
config_file_path = "/etc/lora/sx1302_hal/packet_forwarder/global_conf.json"
with open(config_file_path, "r") as config_file:
  config = json5.load(config_file)
  gateway_id = config["gateway_conf"]["gateway_ID"]

print("Gateway ID: %s" % gateway_id)

# This must point to the API interface.
server = "homeassistant.local:8080"

# Read the API token from the file.
api_key_file_path = "/etc/chirpstack/api-key"
with open(api_key_file_path, "r") as api_key_file:
  for line in api_key_file:
    if line.startswith("token:"):
      api_token = line.split("token:")[1].strip()
      break

if __name__ == "__main__":
  # Connect without using TLS.
  channel = grpc.insecure_channel(server)

  # Define the API key meta-data.
  auth_token = [("authorization", "Bearer %s" % api_token)]

  # Get Tenant ID
  tenant_service = api.TenantServiceStub(channel)
  tenant_list_req = api.ListTenantsRequest(limit=1)
  tenant_list_resp = tenant_service.List(tenant_list_req, metadata=auth_token)
  tenant_id = tenant_list_resp.result[0].id

  print("Tenant ID: %s" % tenant_id)

  # Create the Gateway.
  gateway_client = api.GatewayServiceStub(channel)

  req = api.CreateGatewayRequest()
  req.gateway.gateway_id = gateway_id
  req.gateway.tenant_id = tenant_id
  req.gateway.name = "RAK Gateway"
  req.gateway.description = "RAK7271 / RAK7371 - WisGate Developer LoRaWAN Gateway"
  # req.gateway.location.latitude = 37.944773
  # req.gateway.location.longitude = -122.052319
  # req.gateway.location.altitude = 1
  req.gateway.stats_interval = 30

  try:
    resp = gateway_client.Create(req, metadata=auth_token)
    print("Gateway created successfully")
  except grpc.RpcError as e:
    print("Error creating gateway: %s" % e.details())
    print("Error code: %s" % e.code())
  