#!/usr/bin/env python3
import sys;

# Needs 2 args.
if len(sys.argv) != 3:
	sys.exit("Usage: linesfromobj.py <in.obj> <out.txt>")

# Parse input.
with open(sys.argv[1], "r") as fi:
	verts = []
	faces = []

	for line in fi:
		tokens = line.strip().split(" ")
		if tokens[0] == "v":
			verts.append((float(tokens[1]), float(tokens[2]), float(tokens[3])))
		elif tokens[0] == "f":
			if len(tokens) == 4:
				faces.append((int(tokens[1])-1, int(tokens[2])-1, int(tokens[3])-1))
			if len(tokens) == 5:
				faces.append((int(tokens[1])-1, int(tokens[2])-1, int(tokens[3])-1, int(tokens[4])-1))

	print("{0} vertices\n{1} faces".format(len(verts), len(faces)))

	lines = []
	for face in faces:
		if len(face) == 3:
			lines.append((face[0], face[1]))
			lines.append((face[1], face[2]))
			lines.append((face[2], face[0]))
		elif len(face) == 4:
			lines.append((face[0], face[1]))
			lines.append((face[1], face[2]))
			lines.append((face[2], face[3]))
			lines.append((face[3], face[0]))

	print("{0} lines".format(len(lines)))

	trimmed = []
	for line in lines:
		if line not in trimmed:
			if line[::-1] not in trimmed:
				trimmed.append(line)

	print("{0} trimmed lines".format(len(trimmed)))

	with open(sys.argv[2], "w") as fo:
		fo.write("/* -- header.h -- */\n\n")
		fo.write("#define VERTEXCOUNT {0}\n".format(len(verts)))
		fo.write("#define INDEXCOUNT {0}\n".format(len(trimmed) * 2))
		fo.write("#define LINECOUNT {0}\n\n".format(len(trimmed)))
		fo.write("extern const float vertices[{0}][3];\n".format(len(verts)))
		fo.write("extern const int indices[{0}];\n\n\n".format(len(trimmed)))

		fo.write("/* -- source.c -- */\n\n")
		fo.write("const float vertices[{0}][3]".format(len(verts)))
		fo.write(" =\n{\n")
		itr = 0
		for vert in verts:
			fo.write("  " if itr % 2 == 0 else "")
			itr += 1
			fo.write("{" + ", ".join([str(i) for i in vert]) + "}," + ("\n" if itr % 2 == 0 else " "))
		fo.write("\n};\n\n" if itr % 2 != 0 else "};\n\n")

		fo.write("const int indices[{0}]".format(len(trimmed) * 2))
		fo.write(" =\n{\n")
		itr = 0
		for line in trimmed:
			fo.write("  " if itr % 7 == 0 else "")
			itr += 1
			fo.write("{0}, {1},".format(line[0], line[1]) + ("\n" if itr % 7 == 0 else " "))
		fo.write("\n};\n\n" if itr % 7 != 0 else "};\n\n")
