$fn = 20;

include <peg_board_vars.scad>

// list of drills bits to store in mm : first indice is drill diameter,
// second is drill holder len
// second row of drill bits
drill_list2 = [
  [ 2, 20 ],
  [ 3, 25 ],
  [ 4, 30 ],
  [ 5, 35 ],
  [ 6, 35 ],
  [ 8, 40 ],
  [ 8, 40 ],
  [ 10, 45 ],
];

// first row of drill bits
drill_list = [
  [ 7, 50 ],
  [ 7, 50 ],
  [ 7, 50 ],
  [ 7, 50 ],
  [ 7, 50 ],
  [ 7, 50 ],
  [ 7, 50 ],
];

// extra diameter to add for the holes of the drill bits
//  too tight and the drill bit is hard to put in/out.
bit_hole_extra = 0.75;
// wall thickness between two drill bits
bit_separation = 2;

// will place one peg attachment every hole_spacing*peg_alter mm
peg_alter = 1;

// drill bit attachment forward angle
fwd_angle = 20;

epsilon = 0.1;
clip_height = 2 * hole_size + 2;

module generate_bits(bit_vector, depth = 0, idx = 0) {
  if (idx < len(bit_vector)) {
    height = bit_vector[idx][1];
    diameter = bit_vector[idx][0];
    dim = max(depth, diameter);

    translate([
      (diameter + bit_separation + bit_hole_extra) / 2, -(diameter + 2) / 2, -
      height
    ]) {
      // drill "tube"
      linear_extrude(height = height) difference() {
        translate([ 0, depth ? -0.5 - depth / 2 + (diameter + 1) / 2 : 0, 0 ])
            square([ diameter + 1 + bit_separation, dim + 2.5 ], center = true);
        circle(d = diameter + bit_hole_extra);
      }

      //"tube" bottom
      cube([ diameter + bit_separation + bit_hole_extra, diameter + 1, 1 ],
           center = true);
    };

    // drill size text
    translate([ (diameter + 1) / 2, -dim - 2, -5 ]) {
      rotate([ 90, 0, 0 ]) scale([ 0.25, 0.25, 0.25 ]) {
        color("red") linear_extrude(height = 2)
            text(str(diameter), halign = "center");
      }
    }

    // next drill bit
    translate([ diameter + bit_separation + bit_hole_extra, 0, 0 ]) {
      generate_bits(bit_vector, depth, idx + 1);
    }
  }
}

drill_sizes = [for (i = drill_list) i[0]];
drill_holder_lens = [for (i = drill_list) i[1]];
lengths_fixture = [for (i = drill_list) 1] * drill_list;
len_fixture = lengths_fixture[0] + len(drill_list);
drill_holder_len = max(drill_holder_lens);
drill_size = max(drill_sizes);

rotate([ fwd_angle, 0, 0 ]) generate_bits(drill_list, depth = drill_size);
rotate([ fwd_angle, 0, 0 ])
    translate([ 0, -drill_size - bit_separation - bit_hole_extra, -10 ])
        generate_bits(drill_list2);

module generate_attachments(bit_vector) {

  sum_bits = [for (p = bit_vector) 1] * (bit_vector);
  drill_heights = [for (p = bit_vector) p[1]];
  max_height = max(drill_heights);
  len_fixture =
      sum_bits[0] + len(bit_vector) * (bit_hole_extra + bit_separation);
  pegs_space = peg_alter * hole_spacing;

  rotate([ 0, 90, 0 ]) linear_extrude(height = len_fixture) polygon(
      [
        [ 0, 0 ], [ cos(fwd_angle) * max_height, sin(fwd_angle) * max_height ],
        [ 0, sin(fwd_angle) * max_height ]
      ],
      convexity = 1);

  difference() {

    translate([ 0, sin(fwd_angle) * max_height, -cos(fwd_angle) * max_height ])
        cube([ len_fixture, 5, cos(fwd_angle) * max_height ]);

    for (peg = [0:pegs_space:len_fixture]) {
      echo(peg);

      translate([
        peg + 5, sin(fwd_angle) * max_height, -cos(fwd_angle) * max_height
      ]) linear_extrude(height = max_height) polygon(points = poly_attach);
    }
  }
}

color("red") generate_attachments(drill_list);
