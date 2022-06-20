#!/usr/bin/env python3
'''
Quick & dirty script to list the contents of zip files en masse.
To be used in conjunction with other tools (such as grep). 
'''

import os
import zipfile

if __name__ == "__main__":
	for file in os.listdir("."):
		if not zipfile.is_zipfile(file): continue
		with zipfile.ZipFile(file) as zip:
			for name in zip.namelist():
				print(os.path.join(file, name))
