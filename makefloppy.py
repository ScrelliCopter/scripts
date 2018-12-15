#!/usr/bin/env python3
import sys, subprocess
from os import path, listdir
from shutil import rmtree, move
from tempfile import mkdtemp

if __name__ == "__main__":
	if len(sys.argv) < 3:
		sys.exit("Usage: makefloppy.py <out.img> <file(s)>...")

	outname = sys.argv[1]
	files   = []
	for filesrc in sys.argv[2:]:
		if not path.exists(filesrc):
			sys.exit("{0} does not exist".format(filesrc))
		
		itemdst = path.basename(filesrc)
		if path.isfile(filesrc) or path.isdir(filesrc):
			files.append((filesrc, itemdst))

	tdir = None
	try:
		tdir = mkdtemp()
		timg = path.join(tdir, "img")
		if not subprocess.run(["mkfs.vfat", "-C", timg, "1440"]):
			sys.exit("img creation failed")

		for file in files:
			not subprocess.run(["mcopy", "-si", timg, file[0], "::" + file[1]])

		move(timg, outname)

	finally:
		if tdir:
			rmtree(tdir)
