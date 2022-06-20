#!/usr/bin/env python3

import sys


png_magic = b"\x89\x50\x4e\x47\x0d\x0a\x1a\x0a"


def main(argv):
	with open(argv[1], "rb") as fin:
		dat = fin.read()
		pngpos = dat.find(png_magic)
		if pngpos < 0:
			print("no PNG header found", file=sys.stderr)
			exit(1)

		with open("out.png", "wb") as fout:
			fout.write(dat[pngpos:])


if __name__ == "__main__":
	main(sys.argv)
