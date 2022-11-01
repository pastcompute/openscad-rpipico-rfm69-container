printables = 1;
show_part = 0; // Use command line to override this to print one thing instead of all: -Dshow_part=1

include <enclosure.scad>

if (show_part == 0 || show_part == 1) {
  translate([ 40, 0, 0 ]) enclosure_floor();
}

if (show_part == 0 || show_part == 2) {
  rotate([ 180, 0, 0 ]) translate([ -40, 0, -enclosure_dim[2] + enclosure_thickness ]) enclosure_lid();
}