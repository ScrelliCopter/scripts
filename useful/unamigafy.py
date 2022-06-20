#!/usr/bin/env python3
'''
Python 3 script to batch rename files from Amiga format to something less messy.
'''

import os

if __name__ == "__main__":
	for file in os.listdir("."):
		split = file.split(".", 1)
		if len(split) > 1:
			if len(split[0]) <= 3:
				if split[0].isupper():
					os.rename(file, split[1].strip().replace(" ", "_") + "." + split[0].lower())
