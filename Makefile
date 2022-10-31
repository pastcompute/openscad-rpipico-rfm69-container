all:;
	openscad -o printable.stl printable.scad

fix:;
	openscad-format -i enclosure.scad -f
	openscad-format -i primitives.scad -f
	openscad-format -i printable.scad -f
	openscad-format -i pico.scad -f
