import xml.etree.ElementTree as ET
from pathlib import Path
import sys
import argparse
import os
# convert the nodes' lat,long coordinates to x,y coordinates
if 'SUMO_HOME' in os.environ:
    sys.path.append(os.path.join(os.environ['SUMO_HOME'], 'tools'))
else:
    print("Make sure the SUMO_HOME environment variable is set.", file=sys.stderr)
    sys.exit(1)

import traci
# Check if rich is installed, and only import it if it is.
try:
    from rich import pretty, print

    pretty.install()
except ImportError or ModuleNotFoundError:
    pass

# Parse arguments
parser = argparse.ArgumentParser(description='Extracts lamp data from a .osm file')
parser.add_argument('-osm', '--osm-file', type=str, required=True, help='Path to the OSM map file')
parser.add_argument('-s', '--sumo-cfg', type=str, required=True, help='Path to the SUMO config file')
parser.add_argument('-o', '--output', type=str, required=True, help='Path to the output file')

args = parser.parse_args()

# Check if the file exists
if not Path(args.osm_file).exists():
    print(f'[red]Error: {args.osm_file} does not exist.')
    sys.exit(1)

# Check if the sumo config file exists
if args.sumo_cfg:
    if not Path(args.sumo_cfg).exists():
        print(f'[red]Error: {args.sumo_cfg} does not exist.')
        sys.exit(1)

# Check if the output file exists
if args.output:
    if Path(args.output).exists():
        print(f'[yellow]Warning: {args.output} already exists. Overwrite? \[y/N]')
        answer = input()
        if answer.lower() != 'y':
            print('Aborting.')
            sys.exit(0)

# Parse the file
tree = ET.parse(args.osm_file)
root = tree.getroot()

# connect to sumo
traci.start(['sumo', '-c', args.sumo_cfg])

# EXAMPLE NODE THAT WE WANT
#  <node id="8918593277" visible="true" version="2" changeset="117312786" timestamp="2022-02-12T08:37:39Z" user="osmviborg" uid="379467" lat="55.8592049" lon="9.8605380">
#   <tag k="highway" v="street_lamp"/>
#   <tag k="lamp_type" v="electric"/>
#  </node>

# Find all nodes with the tag "highway" and value "street_lamp"
nodes = root.findall("./node/tag[@k='highway'][@v='street_lamp']/..")

# Print the number of nodes found
print(f'Found [green]{len(nodes)}[/green] nodes with the tag [green]highway=street_lamp[/green]')

# convert all the nodes to x,y coordinates
# traci.simulation.convertGeo(lat, long, fromGeo=True)
with open(args.output, 'w') as lamp_file:
    # Write the header
    lamp_file.write('<?xml version="1.0" encoding="UTF-8"?>\n')
    # parent tag
    lamp_file.write('<lamps>\n')
    # Loop through all the nodes
    for node in nodes:
        # Get the node id
        node_id = node.get('id')
        # Get the node's lat and long
        lat = float(node.get('lat'))
        lon = float(node.get('lon'))
        # Convert the lat and long to x,y coordinates
        x, y = traci.simulation.convertGeo(lon, lat, fromGeo=True)
        # Write the data to the file
        lamp_file.write(f'\t<lamp id="{node_id}" x="{x}" y="{y}" lat="{lat}" long="{lon}"/>\n')
    lamp_file.write('</lamps>\n')

# Print a message
print(f'[green]Done. Wrote lamp data to {lamp_file}[/green]')