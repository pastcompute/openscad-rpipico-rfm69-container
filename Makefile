all:;
	openscad -o printable.stl printable.scad
	openscad -o floor.stl -Dshow_part=1 printable.scad
	openscad -o lid.stl -Dshow_part=2 printable.scad

images:;
	openscad -o enclosure.png --camera 0,0,0,60,0,-33,240 enclosure.scad 
	openscad -o printable.png --camera 0,0,0,45,0,45,400 printable.scad 

format:;
	openscad-format -i enclosure.scad -f
	openscad-format -i primitives.scad -f
	openscad-format -i printable.scad -f
	openscad-format -i pico.scad -f
