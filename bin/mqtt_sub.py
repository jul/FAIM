import paho.mqtt.client as mqtt
from time import time

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    client.subscribe("DATA/#")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    source, ds, value, dst = msg.payload.decode().split(":")
    now = time()
    with open(f"./data/{ds}~{source}.csv", "a+") as f:
        f.write(f"{now} {value}\n")


mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="sub")
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.username = "sub"
mqttc.password= "sub"
mqttc.tls_set(
    keyfile="./cfg/sub.key",
    certfile="./cfg/sub.crt",
    ca_certs="./cfg/RootCA.crt",
    tls_version=2
)
mqttc.connect("badass.home", 8883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
mqttc.loop_forever()
