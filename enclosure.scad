include <primitives.scad>

enclosure_dim = [ 60, 36, 13];      // x, y, height of box bounding
enclosure_corners = 4;              // corner radii
enclosure_thickness = 2;

// reduce size of lip, other elements to allow for 3d printing tolerance
print_margin = 0.1;

pico_inset_x = 2;
pico_inset_y = 4.8;
pico_dim = [ 51, 21 ];
pico_splats = [for (y=[0, 11.4], x=[0, 47]) [x, y] + [pico_inset_x, pico_inset_y]];
                                    // position of pico mounting holes relative to pico
                                    // 2mm in from x-ends, 4.8mm in from y ends
pico_hole_r = 2.1 / 2;              // radii of pico mounting holes

standoff_floor_r = 3;               // don make this too wide or it will interfere with the USB
standoff_taper = 1;


pico_ofs = [2, 3];
enclosure_offset_pico = pico_ofs + [ pico_inset_x, 0];  
                                   // offset it so we can reach the USB power cord inside a hole
                                   // and clear the sides
enclosure_standoff_pico = 12;       // for our board, we have it mounted upside down with the
                                   // still soldered  SWD pins, so leave space for these

rfm_grip_t = 3;
rfm_offset_opp = enclosure_thickness + 2 + rfm_grip_t;

module enclosure_floor() {
    w = enclosure_dim[0];
    b = enclosure_dim[1];
    h = enclosure_dim[2];
    cr = enclosure_corners;
    ct = enclosure_thickness;
  
    sr = standoff_floor_r - standoff_taper;

    lip_inset = 1 + print_margin;
    lip_thickness = 1 - print_margin;
    lip_height = 1.5;

    union() {
        baseplate(ct, w, b, cr);
        // lip
        translate([0, 0, ct])
        baseplate_wall(lip_thickness, lip_height, w - lip_inset, b - lip_inset, cr);

        translate(enclosure_offset_pico + [0, 0, enclosure_thickness])
        translate([-w/2, -b/2]) {
            // This positions it such that the board would line up with a corner at 0,0
            // with the cylinder bigger than 2mm it means that the risers
            // are outside where the board is... (more with taper)
            // so enclosure_offset_pico needs to include this
            translate(pico_splats[0])
            riser_with_lug(2, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
            translate(pico_splats[2])
            riser_with_lug(2, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
            // These two need a cut out so there is room for the USB when upside down
            translate(pico_splats[1])
            rotate(a=90, v=[0,0,1])
            cut_riser_with_lug(2, 2, 2, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
            translate(pico_splats[3])
            rotate(a=-90, v=[0,0,1])
            cut_riser_with_lug(2, 2, 2, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
        }

        translate([-w/2, -b/2])
        translate([25, b - rfm_offset_opp, enclosure_thickness])
        riser_slot_pair(4, 1.7, 10, rfm_grip_t, rfm_grip_t-1);
    }


}

enclosure_floor();


        
