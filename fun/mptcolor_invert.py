#!/usr/bin/env python3

import sys
from pathlib import Path


def mptcolor_invert(inPath: Path, outPath: Path):
	# Open input
	with inPath.open("r") as fi:
		# Open output and write header
		with outPath.open("w") as fo:
			fo.write("[Colors]\n")

			# Parse input
			for line in fi:
				if line.startswith("Color"):
					colNum = line[5:7]          # Could assume this based off the loop but nah
					colour = int(line[8:])      # Rest of the line is colour

					colour = ~colour & 0xFFFFFF # Invert colours, make sure is unsigned 24 bit

					# 'Color[ID]=[colour]'
					fo.write(f"Color{colNum}={colour}\n")


if __name__ == "__main__":
	# Needs 2 args
	if len(sys.argv) != 3:
		sys.exit("Usage: mptcolor_invert.py <in.mptcolor> <out.mptcolor>")

	mptcolor_invert(Path(sys.argv[1]), Path(sys.argv[2]))
