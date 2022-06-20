#!/usr/bin/env python3
import os
import sys

cpath = "/sys/class/backlight/intel_backlight"


def get_current():
	file = open(os.path.join(cpath, "brightness"), "r")
	return int(file.read())


def get_max():
	file = open(os.path.join(cpath, "max_brightness"), "r")
	return int(file.read())


def set_current(power):
	file = open(os.path.join(cpath, "brightness"), "w")
	file.write("{0}".format(power))


def clamp(x, min, max):
	return min if x < min else max if x > max else x


def parse_arg(arg, max):
	mode = 0
	if arg[0] == '+':
		mode = 1
		arg = arg[1:]
	elif arg[0] == '-':
		mode = -1
		arg = arg[1:]

	lvl = None
	try:
		if arg[-1:] == '%':
			arg = arg[:-1]
			lvl = int(float(arg) / 100 * max)
		else:
			lvl = int(arg)
	except ValueError:
		sys.exit("malformed argument")

	if mode == 1:
		lvl = get_current() + lvl
	elif mode == -1:
		lvl = get_current() - lvl

	if not mode and (lvl < 0 or lvl > max):
		sys.exit("argument out of range")
	else:
		return clamp(lvl, 0, max)


if __name__ == "__main__":
	if len(sys.argv) == 1:
		lvl = get_current()
		max = get_max()
		print("{0}/{1} ({2:.2f}%)".format(lvl, max, lvl / max * 100))
	elif len(sys.argv) == 2:
		max = get_max()
		lvl = parse_arg(sys.argv[1].strip(), max)

		set_current(lvl)
	else:
		sys.exit("wrong number of arguments")
