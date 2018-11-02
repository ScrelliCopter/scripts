#!/usr/bin/env python3
'''
Tool to mass compress files into individual zips, intended for game ROMs.
FIXME: might be better to use the OS zip cus zipfile compression
       quality is apparently not that great...
'''

import os;
import zipfile;

if __name__ == "__main__":
	for dirs, subdirs, files in os.walk("."):
		for file in files:

			if file.endswith(".zip"): continue
			if file.endswith(".sav"): continue
			if file.endswith(".SRM"): continue
			if file.endswith(".py"): continue

			zf = zipfile.ZipFile(file + ".zip", "w", zipfile.ZIP_DEFLATED)
			zf.write(file)
			zf.close()
			os.remove(file)
