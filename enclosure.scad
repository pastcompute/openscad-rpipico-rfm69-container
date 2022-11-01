include <pico.scad>
include <primitives.scad>

enclosure_dim = [ 60, 66, 40 ]; // x, y, height of box bounding
enclosure_corners = 4;          // corner radii
enclosure_thickness = 2.5;

// reduce size of lip, other elements to allow for 3d printing tolerance
print_margin = 0.1;

pico_inset_x = 2;
pico_inset_y = 4.8;
pico_dim = [ 51, 21 ];
pico_splats = [for (y = [ 0, 11.4 ], x = [ 0, 47 ])[x, y] + [ pico_inset_x, pico_inset_y ]];
// position of pico mounting holes relative to pico
// 2mm in from x-ends, 4.8mm in from y ends
pico_hole_r = 2.1 / 2 - print_margin / 2; // radii of pico mounting holes

standoff_floor_r = 3; // don make this too wide or it will interfere with the USB
standoff_taper = 1;

pico_ofs = [ 2, 3 ];
enclosure_offset_pico = pico_ofs + [ pico_inset_x, 0 ];
// offset it so we can reach the USB power cord inside a hole
// and clear the sides
enclosure_standoff_pico = 12; // for our board, we have it mounted upside down with the
                              // still soldered  SWD pins, so leave space for these

rfm_grip_t = 3;
rfm_offset_opp = 8 + enclosure_thickness + rfm_grip_t;

// dont subtract the print margin, we need this to be a bit snugglier
lip_inset = 1.7;
lip_thickness = 1.7;
lip_height = 2;

lever_slot_w = 8;

module enclosure_lid() {
  w = enclosure_dim[0];
  b = enclosure_dim[1];
  h = enclosure_dim[2];
  cr = enclosure_corners;
  ct = enclosure_thickness;

  wh = h - ct - ct;
  y1 = -enclosure_dim[1] / 2 + pico_dim[1] / 2 + enclosure_offset_pico[1];

  // get it back relative to the floor, to make image rotation easier
  translate([ 0, 0, -ct ]) difference() {
    union() {
      translate([ 0, 0, h - ct ]) {
        difference() {
          baseplate(ct, w, b, cr);
          translate([ 0, y1 - 15 / 2, -_comp1 ]) linear_extrude(ct + _comp2) logo(15, 15);
        }
      }

      // main wall
      translate([ 0, 0, h - ct - wh + lip_height + print_margin ]) baseplate_wall(ct, wh - lip_height - print_margin, w, b, cr);

      // lip overlap
      translate([ 0, 0, ct + 2 * print_margin ]) baseplate_wall(lip_thickness, lip_height - print_margin, w, b, cr);
    }
    // slots to make it easier to lever the lid off
    translate([ -lever_slot_w / 2, b / 2 - lip_thickness - _comp1, ct - _comp1 ])
        cube([ lever_slot_w, lip_thickness + _comp2, lip_height * 0.9 ]);

    translate([ -lever_slot_w / 2, -b / 2 + _comp1, ct - _comp1 ]) cube([ lever_slot_w, lip_thickness + _comp2, lip_height * 0.9 ]);

    // make a slice and a hole on the side for the antenna SMA connector
    // this will let us pull up the antenna without desoldering it
    hbx = -15;
    hbot = 25;
    sqx = 5;
    sqy = 7;
    sqw = 2;
    translate([ hbx, b / 2 - ct - _comp1, hbot - sqy / 2 ]) cube([ sqx, ct + _comp2, sqy ]);
    translate([ hbx - sqw / 2, b / 2 - ct - _comp1, ct - _comp1 ]) cube([ sqw, ct + _comp2, hbot + _comp2 ]);

    // Hole for the USB cable; even though it looks OK in the model, it is too low in practice
    fudge = 2;
    uw = 12;
    uh = 6 + fudge;
    translate([ w / 2 - ct - _comp1, y1 - uw / 2, enclosure_standoff_pico - uh / 2 + fudge ]) cube([ ct + _comp2, uw, uh ]);
  }
}

module enclosure_floor() {
  w = enclosure_dim[0];
  b = enclosure_dim[1];
  h = enclosure_dim[2];
  cr = enclosure_corners;
  ct = enclosure_thickness;

  sr = standoff_floor_r - standoff_taper;

  union() {
    difference() {
      baseplate(ct, w, b, cr);
      // Make a slot to access the SWD pins
      translate([ -w / 2, -b / 2 ]) { translate(pico_splats[0]) translate([ 2, 4.8, -_comp1 ]) cube([ 3, 7, ct + _comp2 ]); }
    }

    // lip
    translate([ 0, 0, ct ]) baseplate_wall(lip_thickness, lip_height, w - lip_inset, b - lip_inset, cr);

    // pico standoffs
    lug_slice_usb_h = 5;
    lug_slice_pins_h = 8;
    slice_x = 2;
    lug_height = 2;
    translate(enclosure_offset_pico + [ 0, 0, enclosure_thickness ]) translate([ -w / 2, -b / 2 ]) {
      // This positions it such that the board would line up with a corner
      // at 0,0 with the cylinder bigger than 2mm it means that the risers
      // are outside where the board is... (more with taper)
      // so enclosure_offset_pico needs to include this

      // These two need a cut out so there is room for the USB, and the
      // SWD pins, when upside down I did have a for loop but then I need
      // to rotate them all opposite This end needs a deeper slice
      translate(pico_splats[0]) rotate(a = 90, v = [ 0, 0, 1 ])
          cut_riser_with_lug(slice_x, lug_slice_pins_h, lug_height, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
      translate(pico_splats[2]) rotate(a = -90, v = [ 0, 0, 1 ])
          cut_riser_with_lug(slice_x, lug_slice_pins_h, lug_height, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);

      translate(pico_splats[1]) rotate(a = 90, v = [ 0, 0, 1 ])
          cut_riser_with_lug(slice_x, lug_slice_usb_h, lug_height, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
      translate(pico_splats[3]) rotate(a = -90, v = [ 0, 0, 1 ])
          cut_riser_with_lug(slice_x, lug_slice_usb_h, lug_height, pico_hole_r, enclosure_standoff_pico, sr, standoff_taper);
    }

    translate([ -w / 2, -b / 2 ]) translate([ 40, b - rfm_offset_opp, enclosure_thickness ])
        riser_slot_pair(4, 1.7, 10, rfm_grip_t, rfm_grip_t - 1);
  }
}

if (!printables) {
  rotate([ 0, 0, 180 ]) {
    color("blue") enclosure_floor();

    y1 = -enclosure_dim[1] / 2 + pico_dim[1] / 2 + enclosure_offset_pico[1];
    color("green") translate([ -enclosure_offset_pico[0] + 3.5, y1, enclosure_standoff_pico + enclosure_thickness ])
        rotate([ 0, 180, 0 ]) pico();

    translate([ 0, 0, enclosure_thickness ]) color("blue", alpha = 0.4) enclosure_lid();
  }
}