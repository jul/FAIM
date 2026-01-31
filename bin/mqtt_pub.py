#!/usr/bin/env python
# -*- coding: utf-8 -*-

from time import sleep, time
from subprocess import Popen,PIPE
import os
import paho.mqtt.client as mqtt
import pathlib

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    client.subscribe("SENSOR/")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    # do something
    pass

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id="pub")
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.username = "pub"
mqttc.password= "pub"
mqttc.tls_set(
    keyfile="./cfg/pub.key",
    certfile="./cfg/pub.crt",
    ca_certs="./cfg/RootCA.crt", 
    tls_version=2
)
mqttc.connect("badass.home", 8883, 60)
os.chdir(os.path.dirname(__file__))
plugins = pathlib.Path("../plugin")
while True:
    start = time()
    for p in plugins.glob("*_enabled"):
        with Popen([ p,  ], stdout=PIPE, stdin=PIPE, stderr=PIPE, bufsize=0,) as writer:

            while res := writer.stdout.read():
                writer.stdout.flush()
                for msg in res.split():
                    mqttc.publish("SENSOR", msg.decode())
    sleep(1 - (time() - start))

