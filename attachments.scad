include<peg_board_vars.scad>

    attachment_sz_factor = 0.85;

epsilon = 0.1;
clip_height = 2 * hole_size + 2;

module pin() {

  rotate([ 0, 0, 15 ])
      cylinder(r = hole_size / 2, h = board_thickness * 1.5 + epsilon,
               center = true, $fn = 12);

  rotate([ 0, 0, 90 ]) intersection() {
    translate([ 0, 0, hole_size - epsilon ]) cube(
        [ hole_size + 2 * epsilon, clip_height, 2 * hole_size ], center = true);

    translate([ 0, hole_size / 2 + 2, board_thickness / 2 ])
        rotate([ 0, 90, 0 ]) rotate_extrude(convexity = 5, $fn = 20)
            translate([ 0.44 * hole_size + 2.36, 0, 0 ])
                circle(r = (hole_size * 0.95) / 2);

    translate([ 0, hole_size / 2 + 2 - 1.6, board_thickness / 2 ])
        rotate([ 45, 0, 0 ]) translate([ 0, -0, hole_size * 0.6 ])
            cube([ hole_size + 2 * epsilon, 3 * hole_size, hole_size ],
                 center = true);
  }

  translate([ hole_spacing, 0, 0 ])
      cylinder(r = hole_size / 2, h = board_thickness * 1.5 + epsilon,
               center = true, $fn = 12);
}

module make_peg_attachment() {

  pin();
  rotate([ 0, 90, 0 ]) translate([ 5, 0, -5 ])
      linear_extrude(height = hole_spacing + 10) scale(
          [ attachment_sz_factor, attachment_sz_factor, attachment_sz_factor ])

          polygon(points = poly_attach);
}

make_peg_attachment();
