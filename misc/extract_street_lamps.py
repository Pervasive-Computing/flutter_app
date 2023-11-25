# import traci
import sys
import os
if 'SUMO_HOME' in os.environ:
    sys.path.append(os.path.join(os.environ['SUMO_HOME'], 'tools'))
else:
    print("Make sure the SUMO_HOME environment variable is set.", file=sys.stderr)
    sys.exit(1)
import traci

import xml.etree.ElementTree as ET
from pathlib import Path
import argparse

# read xml file sumo/katrinebjerg-lamp.osm
tree = ET.parse('sumo/katrinebjerg-lamp.osm')
root = tree.getroot()

# get all nodes that have a tag with key 'highway' and value 'street_lamp'
nodes = root.findall(".//node/tag[@k='highway'][@v='street_lamp']/")

print(len(nodes))



# traci.simulation.convertGeo(lat, long, fromGeo=True)