import paho.mqtt.client as mqtt
from time import time, sleep
from confined import parse, Value, pop
from subprocess import Popen,PIPE
import pathlib
import os
import socket

stack = []
client_id = socket.gethostname()
show_must_go = False

def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    client.subscribe(f"BUS/{client_id}")
    client.subscribe(f"BUS")

def on_lun(*a, **kw):
    kw["ctx"]["state"]="RAZ"

def on_set_time_slice(*a, **kw):
    kw["ctx"]["time_slice"]=stack.pop().float
    

def on_ping(*a, **kw):
    global client_id
    client = kw["ctx"]["client"]
    client.publish("RES", f"'{client_id}':PONG")


def on_sel(stack, **kw):
    global client_id, show_must_go
    if stack.pop().str == client_id:
        show_must_go = True

def on_unsel(stack, **kw):
    global client_id, show_must_go
    if stack.pop().str == client_id:
        show_must_go = False


ctx = dict(
    cap=["www", "forth" ],
    time_slice=10,
    dispatch=dict(
        lun=on_lun,
        ping=on_ping,
        sel=on_sel,
        unsel=on_unsel,
        tsset=on_set_time_slice,
    ),
)

def on_message(client, userdata, msg):
    global stack, ctx
    ctx["client"] = client
    client.publish(
        "RES", 
        str(parse(
           ctx,
           msg.payload.decode(),
           data=stack, 
           )
        )
    )


mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, client_id=client_id)
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
mqttc.loop_start()
os.chdir(os.path.dirname(__file__))

plugins = pathlib.Path("../plugin")
# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
while True:
    start = time()
    if show_must_go:
        for p in plugins.glob("*_enabled"):
            with Popen([ p,  ], stdout=PIPE, stdin=PIPE, stderr=PIPE, bufsize=0,) as writer:
                while res := writer.stdout.read():
                    writer.stdout.flush()
                    for msg in res.split():
                        mqttc.publish("DATA", msg.decode())
        mqttc.publish("RES/", f"{client_id}:core.processing_time:{time()-start}:GAUGE")
        if time() -start < ctx["time_slice"]:
            sleep(ctx["time_slice"] - (time() - start))

