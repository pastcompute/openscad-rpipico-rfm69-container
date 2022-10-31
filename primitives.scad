// So that things that _exactly_ difference draw neatly
_comp1 = 0.01;
_comp2 = 0.02;

/** solid riser, no hole, slight taper in (base radius is radi+taper) if taper >
 * 0 */
module
riser(height, radi, taper = 0)
{
    // setting a negative taper will have it taper out at the top wider than the
    // bottom... alt. method using rotation with a squared trapezium //
    // rotate_extrude($fn=36) polygon([[0, 0], [radi + taper, 0], [radi,
    // height], [0, height]]);
    cylinder(height, radi + taper, radi, $fn = 36);
}

/** solid riser with a lug for mounting a PCB. When sizing the lug allow for 3D
 * printing tolerance for fit */
module
riser_with_lug(lug_height, lug_radi, height, radi, taper = 0, $lug_taper = 0)
{
    riser(height, radi, taper);
    translate([ 0, 0, height ])
        cylinder(lug_height, lug_radi, lug_radi + $lug_taper, $fn = 24);
}

/** shave off one side (on the x side) so there can be a wider gap in the middle
 */
module
cut_riser_with_lug(slice_xw,
                   slice_down,
                   lug_height,
                   lug_radi,
                   height,
                   radi,
                   taper = 0,
                   $lug_taper = 0)
{
    difference()
    {
        riser_with_lug(lug_height, lug_radi, height, radi, taper);
        translate([
            radi + taper - slice_xw,
            -radi - taper - _comp1,
            -_comp1 + height -
            slice_down
        ]) cube([ slice_xw, 2 * (radi + taper) + _comp2, slice_down + _comp2 ]);
    }
}

/** base plate, default height, z-centered, centered, rounded corner if bendradi
 * > 0 */
module
baseplate_tmpl(wx, wy, bendradi = 0)
{
    // A key point with the 2d primitives, this is z-centered, whereas when
    // extruded, is not
    if (!bendradi) {
        square([ wx, wy ], center = true);
    } else {
        // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Transformations#minkowski
        // We need to take the corner into account
        translate([ bendradi - wx / 2, bendradi - wy / 2 ])
        {
            minkowski()
            {
                square([ wx - bendradi * 2, wy - bendradi * 2 ]);
                circle(r = bendradi);
            }
        }
    }
}

// cornered at 0,0
module
triangularish_riser(height, wx, wy, tx)
{
    translate([ wx, 0 ]) rotate(a = -90, v = [ 0, 1, 0 ]) linear_extrude(wx)
        polygon([ [ 0, 0 ], [ 0, wy ], [ height, tx ], [ height, 0 ] ]);
}

/** Triangularish risers to slot a PCB between; centered */
module
riser_slot_pair(height, gap, wx, wy, tx)
{
    translate([ -wx / 2, gap / 2, 0 ]) triangularish_riser(height, wx, wy, tx);

    translate([ wx / 2, -gap / 2, 0 ]) rotate(a = 180, v = [ 0, 0, 1 ])
        triangularish_riser(height, wx, wy, tx);
}

module
baseplate(base_thickness, wx, wy, bendradi = 0)
{
    linear_extrude(height = base_thickness, convexity = 2)
    {
        baseplate_tmpl(wx, wy, bendradi);
    }
}

/** side walls to match a rounded corner baseplate. bottom lies on z-0 plane */
module
baseplate_wall(wall_thickness, height, wx, wy, bendradi = 0)
{
    // to make a lip on the floor, call this with wx-=inset, wy-=inset
    linear_extrude(height = height, convexity = 2)
    {
        difference()
        {
            baseplate_tmpl(wx, wy, bendradi);
            baseplate_tmpl(wx - wall_thickness, wy - wall_thickness, bendradi);
        }
    }
}

module
logo_stripe()
{
    s = 0.635;
    sw = 0.18;
    polygon([ [ 0, 0 ], [ sw, 0 ], [ sw + s, 1 ], [ s, 1 ] ]);
}

module
logo(w, b)
{
    scale([ w, b ]) union()
    {
        logo_stripe();
        translate([ 0.3, 0 ]) logo_stripe();
        translate([ 0.6, 0 ]) logo_stripe();
        translate([ 0.9, 0 ]) logo_stripe();
    }
}

// SMA plate 12.7mmsq holes inset to 11.1 outer