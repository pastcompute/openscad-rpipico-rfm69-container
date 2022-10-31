all:;
	openscad -o printable.stl printable.scad

images:;
	openscad -o enclosure.png --camera 0,0,0,60,0,-33,200 enclosure.scad 
	openscad -o printable.png --camera 80,20,-40,60,0,-66,400 printable.scad 

fix:;
	openscad-format -i enclosure.scad -f
	openscad-format -i primitives.scad -f
	openscad-format -i printable.scad -f
	openscad-format -i pico.scad -f
