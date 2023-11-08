#!/usr/bin/env python3
import xml.etree.ElementTree as ET
import json
import argparse

def parse_xml_to_json(xml_file_path):
    # Parse the XML file
    tree = ET.parse(xml_file_path)
    root = tree.getroot()

    # Initialize empty lists to hold edges and junctions
    edges = []
    junctions = []

    # Iterate through the root of the XML
    for element in root:
        # If the element is an edge, extract the relevant information
        if element.tag == 'edge' and 'function' not in element.attrib:
            edge_id = element.attrib.get('id')
            # Initialize a list to store the lane shapes
            lane_shapes = []
            for subelement in element:
                if subelement.tag == 'lane':
                    # Extracting the shape of the lane
                    lane_shapes.append(subelement.attrib.get('shape'))
            # Append the edge information to the edges list if it contains lanes
            if lane_shapes:
                edges.append({
                    'id': edge_id,
                    'shapes': lane_shapes
                })
        # If the element is a junction, extract the relevant information
        elif element.tag == 'junction':
            junction_id = element.attrib.get('id')
            shape = element.attrib.get('shape')
            # Append the junction information to the junctions list
            junctions.append({
                'id': junction_id,
                'shape': shape
            })

    # Construct the final JSON object
    output_json = {
        'edges': edges,
        'junctions': junctions
    }

    return output_json

# Set up the argument parser
parser = argparse.ArgumentParser(description='Convert .net.xml to .json for road networks.')
parser.add_argument('input_file', type=str, help='The input .net.xml file')
parser.add_argument('-o', '--output_file', type=str, default='road_network.json', help='The output .json file')

# Parse the arguments
args = parser.parse_args()

# Parse the XML and get the JSON output
road_network_json = parse_xml_to_json(args.input_file)

# Convert the JSON object to a JSON string
json_data = json.dumps(road_network_json, indent=4)

# Save the JSON data to the specified output file
with open(args.output_file, 'w') as json_file:
    json_file.write(json_data)

# Output the path to the JSON file (for confirmation)
print(f"Output saved to {args.output_file}")
