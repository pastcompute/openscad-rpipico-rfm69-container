printables = 1;

include <enclosure.scad>

enclosure_floor();

rotate([ 180, 0, 0 ]) translate([ 0, 50, -enclosure_dim[2] + enclosure_thickness ]) enclosure_lid();