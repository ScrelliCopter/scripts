#!/usr/bin/env python3

import os
import sys
import urllib.parse
import urllib.request
import re


def fetchtemplate(name):
	url = [
		"https://raw.githubusercontent.com",
		"void-linux", "void-packages", "master",
		"srcpkgs", name, "template"]
	request = urllib.request.urlopen("/".join(url))
	res = request.read()
	return res.decode("utf-8")


def readtokens(template):
	tokens = ("pkgname", "version", "revision", "depends")
	regex = "^([a-zA-Z_-][a-zA-Z0-9_-]*)\s*=\s*(?:\"((?:\\\"|.)*?)\"|(.+?)\s|$)"

	d = {}
	tokenize = re.compile(regex, flags=re.DOTALL | re.MULTILINE)
	for m in tokenize.finditer(template):
		var = m.group(1)
		val = m.group(2) or m.group(3)
		for i in tokens:
			if i == var:
				d[var] = val
	return d


def fetchbinary(name, ver, rev, arch):
	#base = "http://alpha.de.repo.voidlinux.org/current"
	#base = "http://ftp.swin.edu.au/voidlinux/current"
	base = "http://mirror.aarnet.edu.au/pub/voidlinux/current"
	bindir = "xbps-binaries"
	file = "{}-{}_{}.{}.xbps".format(name, ver, rev, arch)

	url = "{}/{}".format(base, file)
	print(url)
	os.makedirs(bindir, exist_ok=True)
	urllib.request.urlretrieve(url, os.path.join(bindir, file))


def main(argv):
	if len(argv) != 2:
		exit(1)

	arch = "x86_64"

	t = fetchtemplate(argv[1])
	d = readtokens(t)
	fetchbinary(d["pkgname"], d["version"], d["revision"], arch)


if __name__ == '__main__':
	main(sys.argv)
