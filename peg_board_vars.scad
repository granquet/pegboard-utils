// hole spacing - peg board properties
hole_spacing = 25.4;
// hole size - peg board properties
hole_size = 5.25;
// board thickness - peg board properties
board_thickness = 5;
    
poly_attach = [
    [ -2, -3], [0, -2],
    [ 2, -3], [2, 3],
    [ 0, 2], [-2, 3]
    ];

module generate_attachments(len_fixture,max_height) {

    pegs_space = peg_alter * hole_spacing;

    for(peg=[0:pegs_space:len_fixture]) {

            translate([peg+5, 0,0]) 
                    linear_extrude(height=max_height)
        rotate([0,0,90])
                    polygon(points=poly_attach);
    }
}