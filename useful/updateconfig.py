#!/usr/bin/env python3
import os
import shutil
import typing
import filecmp

cdir = "./"


def syncfile(src: os.PathLike, dst: os.PathLike):
	dirname = os.path.dirname(dst)
	if not os.path.isdir(dirname):
		os.makedirs(dirname, exist_ok=True)
	shutil.copy2(src, dst, follow_symlinks=False)


def iffile(path: str):
	dstpath = os.path.join(cdir, os.path.relpath(path, "/"))
	if not os.path.isfile(dstpath):
		print("!HAVE: " + path)
		syncfile(path, dstpath)
		return

	if os.path.getsize(path) != os.path.getsize(dstpath) or not filecmp.cmp(path, dstpath):
		print("!SAME: " + path)
		syncfile(path, dstpath)
		return

	'''
	srcstat = os.stat(path, follow_symlinks=False)
	dststat = os.stat(dstpath, follow_symlinks=False)

	if srcstat.st_mtime > dststat.st_mtime:
		print("NEWER: " + path)
		return
	elif srcstat.st_mtime < dststat.st_mtime:
		print("OLDER: " + path)
		return
	'''

	#print(dstpath)


def read_clist(file: typing.TextIO):
	for line in file:
		path = line.strip()
		if not path or path.startswith("#"):
			continue

		if not os.path.exists(path):
			print("!EXIST: " + path)
			continue

		if os.path.isdir(path):
			for root, dirnames, filenames in os.walk(path, followlinks=False):
				for name in filenames:
					filepath = os.path.join(root, name)
					if os.path.isfile(filepath):
						iffile(filepath)
		elif os.path.isfile(path):
			iffile(path)
		else:
			print("!FILE: " + path)


def main():
	global cdir
	cdir = os.path.abspath(cdir)
	with open(os.path.join(cdir, "configlist.txt"), "r") as file:
		read_clist(file)


if __name__ == "__main__":
	main()
