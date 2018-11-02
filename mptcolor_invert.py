#!/usr/bin/env python3

import sys;

# Needs 2 args.
if len(sys.argv) != 3:
	sys.exit("Usage: mptcolor_invert.py <in.mptcolor> <out.mptcolor>");

# Open output and write header.
fo = open(sys.argv[2], "w");
fo.write("[Colors]\n");

# Parse input.
with open(sys.argv[1], "r") as fi:
	for line in fi:
		if line.startswith("Color"):
			colNum = line[5:7];              # Could assume this based off the loop but nah.
			colour = int(line[8:]);          # Rest of the line is colour.
			
			colour = ~colour & 0xFFFFFF;	 # Invert colours, make sure is unsigned 24 bit.
			
			# 'Color[ID]=[colour]'
			fo.write("Color{0}={1}\n".format(colNum, colour));

fo.close();

