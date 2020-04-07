include <peg_board_vars.scad>

num_wrenches = 11;
height_fixture = 250;
girth_top_fixture = 75;
girth_bottom_fixture = 180;

wrench_slot_poly=[[0,0], [0,20], [10,20], [10,10], [15,10], [20,20], [25,20], [25,10]];

parts_thickness=4;

// will place one peg attachment every hole_spacing*peg_alter mm
peg_alter = 2;


for(spacing=[0:height_fixture/(num_wrenches-1):height_fixture]) {
y = spacing;
z = (girth_bottom_fixture/2)+(((girth_top_fixture-girth_bottom_fixture)/height_fixture)*spacing)/2;
    translate([0,y,z-parts_thickness])
    linear_extrude(parts_thickness)
        polygon(points=wrench_slot_poly);
    translate([0,y,-z])
    linear_extrude(parts_thickness)
        polygon(points=wrench_slot_poly);
}

frame_poly=[
[0,girth_bottom_fixture/2],
[0,-girth_bottom_fixture/2],
[height_fixture, -girth_top_fixture/2],
[height_fixture, girth_top_fixture/2],
[10,(girth_bottom_fixture/2)-10],
[10,(-girth_bottom_fixture/2)+10],
[height_fixture-10,(-girth_top_fixture/2)+20],
[height_fixture-10,(girth_top_fixture/2)-20],
[height_fixture+25, -girth_top_fixture/2],
[height_fixture+25, girth_top_fixture/2],
];

module make_frame() {
  rotate([90,0,90])
linear_extrude(parts_thickness)
  polygon(points=frame_poly,paths=[[0,1,2,3],[8,9,3,2],[4,5,6,7]]);  
}

difference() {
make_frame();
color("red")
rotate([90,90,0])
translate([10-girth_top_fixture/2,0,-height_fixture-30])
generate_attachments(girth_top_fixture,hole_spacing+5);
}

