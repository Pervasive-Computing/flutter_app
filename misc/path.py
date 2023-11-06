#!/usr/bin/env python3
"""
Over time goes through time and
outputs a json message to a websocket with x, y coordinates on a circle at a given t
"""

import math
import json
import time
import websockets

def circle(t):
    return {
        'x': math.cos(t),
        'y': math.sin(t)
    }

def square(t):
    return {
        'x': math.sin(t),
        'y': math.sin(t)
    }

time_factor = 1 / 10
scale = 10
offset = {
    'x': 200,
    'y': 200
}

# websocket stuff
ip = "localhost"
port = 8080
uri = f"ws://{ip}:{port}"

# connect to websocket


while True:
    t = time.time() * time_factor

    shape = circle(t)
    shape['x'] *= scale
    shape['y'] *= scale
    shape['x'] += offset['x']
    shape['y'] += offset['y']



    # print(json.dumps(shape))
    time.sleep(0.1)