#!/usr/bin/env python3
"""
Over time goes through time and
outputs a json message to a websocket with x, y coordinates on a circle at a given t
"""

import math
import json
import time

def circle(t):
    return (math.sin(t), math.cos(t))

def square(t):
    return (math.sin(t), math.cos(t))

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

    cars = {
        "CAR1": {
            "x": circle(t)[0] * scale + offset['x'],
            "y": circle(t)[1] * scale + offset['y'],
        }
    }

    print(json.dumps(cars))
    time.sleep(1)