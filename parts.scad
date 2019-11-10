/*
	Parts – modules for keyboard switches, plate footprints, and other parts
	
	© 2018 Dale Price. This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
*/

include <MCAD/shapes.scad>;
include <util.scad>;
include <switch_colors.scad>;

/*
2D outline for just a switch
	type: (string) the model of switch, currently supports "PG1350" (Kailh Choc)
	center: (bool) whether to center the switch in the x and y axes
	tol: (number) tolerance (>0 recommended) if using this module to generate a plate
*/
module switchPlateFootprint(type = "PG1350", center = false) {
	if (type == "PG1350") {
		switchDim = 13.8;
		translate( center ? [-switchDim/2, -switchDim/2] : [0,0] ) roundrect([switchDim, switchDim], r = 0.5, $fn = 15);
	} else {
		echo("WARNING: unsupported switch type passed to switchPlateFootprint");
	}
}

/*
2D plate cutout for a key of a certain size, including switch, (soon) stabilizers, etc spaced out correctly
	w and h are expected in u, tol is in mm
	supports any type supported by switchPlateFootprint or "outline" (a unit square intended for defining the cutout area of high profile cases)
*/
module keyPlateFootprint(w = 1, h = 1, tol = 0, switchType) {
	offset(r = tol) if (switchType == "outline") {
		square([w*u[0], h*u[1]], center = true);
	} else {
		switchPlateFootprint(type = switchType, center = true);
	}
}

/*
	type: (string) the model of switch, currently only "PG1350" (Kailh Choc) is supported
	center: (bool) whether to center the switch in the x and y axes only
	pcbHeight: (bool) whether to position the switch for the top of the plate at 0 (false) or the top of the PCB at 0 (true)
	color: color of the switch stem, takes any value supported by OpenSCAD's color() function, defaults to a random switch color
*/
module switch(type = "PG1350", center = true, pcbHeight = false, color=switchColor()) {
	// PG1350 based on drawing at http://www.kailh.com/en/Products/Ks/CS/319.html
	if (type == "PG1350") {
		translate( pcbHeight ? [0, 0, 2.2] : [0,0,0] )
		translate( center ? [-15/2,-15/2,0] : [0,0,0] ) {
			translate([0, 0, -animPos()*3]) color(color) difference() {
				union() {
					translate([5/2, 15/2 - 4.5/2, 0.8]) cube([10, 4.5, 5]); // stem
					translate([5/2 + 5 - 3/2, 15/2-4.5/2-1, 0.8]) cube([3, 1.01, 5]); // stem notch
				}
				translate([15/2 - (5.7/2 + 1.2/2), 15/2 - 3/2, 1.8]) cube([1.2, 3, 4.01]); // stem holes
				translate([15/2 + (5.7/2 - 1.2/2), 15/2 - 3/2, 1.8]) cube([1.2, 3, 4.01]);
			}
			translate([15/2, 15/2, 0.4]) roundedBox(15, 15, 0.80, 1.1, $fn=18); // outer rim
			color([1,1,1,0.5]) translate([.7, .6, 0.799]) cube([13.6, 13.8, 2]); // upper body
			translate([0.6, 0.6, -2.20/2]) linear_extrude(height = 2.20, center = true) switchPlateFootprint("PG1350"); // lower body
			translate([15/2, 15/2, -2.20 - 2.65]) {
				// mounting pins
				cylinder(d = 3.20, h = 2.65, $fn=20);
				translate([-5, 0, 0]) cylinder(d = 1.8, h = 2.65, $fn=12);
				translate([5, 0, 0]) cylinder(d = 1.8, h = 2.65, $fn=12);
			}
			%translate([15/2, 15/2, -2.20 - 3/2]) color("gold") {
				// electrical pins
				translate([0, -5.9, 0]) cube([0.75, 0.25, 3], center=true);
				translate([-5, -3.8, 0]) cube([0.75, 0.25, 3], center=true);
			}
		}
	} else {
		echo("WARNING: unsupported switch type passed to switch()");
	}
}

/*
	size: ([number, number]) the x and y dimensions of the PCB
	thickness: (number) the thickness of the PCB, defaults to 1.6mm which is typical for keyboards
	center: (bool) whether or not to center the PCB in the x, y, and z axes
	surfaceAtZero: (bool) whether to place the top surface of the PCB at y=0 (true) or at the height equal to the thickness of the PCB (or thickness/2 if centered) (false)
	color: color of the PCB, takes any value supported by OpenSCAD's color() function (defaults to roughly the color of fr4)
	outline: (bool) whether to generate the pcb in 2D (true) or 3D (false)
*/
module pcb(size, thickness = 1.6, center = false, surfaceAtZero = false, color = [0.6, 0.75, 0.5], outline = false) {
	translate( center ? [-size[0]/2, -size[1]/2, -thickness/2] : [0,0,0] )
	translate( center && surfaceAtZero ? [0,0,thickness/2] : [0,0,0] ) {
		color(color) {
			if(outline) square([size[0], size[1]]);
			else translate( surfaceAtZero ? [0, 0, -thickness] : [0, 0, 0] ) cube([size[0], size[1], thickness]);
		}
	}
}



function randInt(min, max) = round(rands(min, max, 1)[0]);

function animPos(t = $t) = lookup(t, [[0, 0], [0.5, 1], [1, 0]]);