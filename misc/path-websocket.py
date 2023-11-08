#!/usr/bin/env python3
"""
Over time goes through time and
outputs a json message to a websocket server with x, y coordinates on a circle at a given t
"""

import asyncio
import websockets
import math
import json
import time

def circle(t, radius=1):
    x = radius * math.cos(t)
    y = radius * math.sin(t)

    # The derivative of x is -sin(t), and the derivative of y is cos(t).
    # The heading is the arctan of the derivative of y divided by the derivative of x.
    heading = math.atan2(radius * math.cos(t), -radius * math.sin(t))

    # Convert heading from radians to degrees if necessary
    # heading = math.degrees(heading)

    # Ensure the heading is between 0 and 2*pi
    heading = (heading + 2 * math.pi) % (2 * math.pi)
    
    return x, y, heading


def figure8(t, a=1):
    sin_t = math.sin(t)
    cos_t = math.cos(t)
    sin_squared = sin_t ** 2
    denominator = 1 + sin_squared
    
    x = a * cos_t / denominator
    y = a * sin_t * cos_t / denominator
    
    dx_dt = -a * sin_t * (1 + 2 * sin_squared) / (denominator ** 2)
    dy_dt = a * (1 - sin_squared - 2 * sin_squared ** 2) / (denominator ** 2)
    
    heading = math.atan2(dy_dt, dx_dt)
    
    # Ensure the heading is between 0 and 2*pi
    heading = (heading + 2 * math.pi) % (2 * math.pi)
    
    return x, y, heading




time_factor = 1
scale = {
    "CAR0": 100,
    "CAR1": 200,
    "CAR2": 20,
}
offset = {
    "CAR0": {
        'x': -200,
        'y': -200
    },
    "CAR1": {
        'x': 200,
        'y': 200
    },
    "CAR2": {
        'x': 0,
        'y': 0
    }
}

connected = set()  # Set to keep track of connected clients

async def time_coordinates(websocket, path):
    # Register client
    connected.add(websocket)
    last_time = time.time()
    try:
        while True:
            current_time = time.time()
            elapsed = current_time - last_time

            # Advance time by a scaled elapsed time instead of real time
            t = elapsed * time_factor

            path = circle(t)
            cars = {
                "CAR0": {
                    "x": path[0] * scale["CAR0"] + offset["CAR0"]['x'],
                    "y": path[1] * scale["CAR0"] + offset["CAR0"]['y'],
                    "heading": path[2],
                },
                "CAR1": {
                    "x": path[0] * scale["CAR1"] + offset["CAR1"]['x'],
                    "y": path[1] * scale["CAR1"] + offset["CAR1"]['y'],
                    "heading": path[2],
                },
                "CAR2": {
                    "x": path[0] * scale["CAR2"] + offset["CAR2"]['x'],
                    "y": path[1] * scale["CAR2"] + offset["CAR2"]['y'],
                    "heading": path[2],
                }
            }

            # Prepare JSON data to send
            message = json.dumps(cars)
            # Use a list to collect and remove websockets that are closed
            closed_websockets = []
            for client in connected:
                try:
                    # The send operation is asynchronous.
                    await client.send(message)
                except websockets.exceptions.ConnectionClosed:
                    # If the connection is closed, we want to remove it from the set
                    closed_websockets.append(client)
            # Remove closed websockets from the set
            for client in closed_websockets:
                connected.remove(client)

            # Wait for a second before sending the next position
            await asyncio.sleep(0.01)
    finally:
        # Unregister client
        connected.remove(websocket)


start_server = websockets.serve(time_coordinates, "localhost", 9001)

asyncio.get_event_loop().run_until_complete(start_server)
try:
    asyncio.get_event_loop().run_forever()
except KeyboardInterrupt:
    print('Server stopped manually.')
