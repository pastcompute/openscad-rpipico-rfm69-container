include <primitives.scad>

translate([-50, 0])
baseplate(2, 30, 40, 5);

translate([0, 0])
riser_slot_pair(12, 3, 20, 6, 3);

translate([0, 50])
riser(20, 6, 1);

translate([0, 100])
riser_with_lug(4, 2, 10, 5, 1);

translate([0, -150])
cut_riser_with_lug(3.5, 3, 4, 2, 10, 5, 1);

translate([50, 0])
baseplate_wall(3, 10, 30, 40, 5);

translate([0, -50])
triangularish_riser(12, 20, 6, 3);
