/*
	Layout – modules and functions for working with keyboard layouts
	
	© 2018 Dale Price. This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
*/

use <parts.scad>;
include <util.scad>;

/*
	Key layout format
	[
		[rowHeight, [[keyWidth, keyHeight(, keyAttr)], [keyWidth, keyHeight]...]],
		...
	]
	
	* All values are in "u" (key size units). Set the variable `u` to an array of [width, height] when you call `layout` if you want to use a custom size.
*/
example_key_layout = [
	[1,    [[1,1], [1,1], [1,1]]],
	[0.25, []                   ],
	[1,    [[1,1], [1,1], [1,2]]],
	[1,    [[1,1], [1,1]]],
	[1,    [    [2,1],    [1,1]]],
]; // if you want a layout with a section of rotated or offset keys (like ergodox thumb clusters), best to make multiple layouts and position their plateCutout()s separately
example_col_offsets = [ // defines the vertical offsets of each column in u
	        0.25,    0,    0.25 // negative offsets not recommended
];

// preview example layout
/*layout("PG1350", example_key_layout, example_col_offsets, plateCutouts = false) {
	switch();
}*/
layout_outline(1, example_key_layout, example_col_offsets);

/*
	layout() generates plate cutouts and/or arbitrary objects according to a layout matrix
	switchType: (string) any type supported by keyPlateFootprint in parts.scad
	layout: (array) a layout matrix (see layout format above)
	colOffsets: (array) the vertical offsets of each column, if any (see example_col_offsets above)
	tol: (number) if plateCutouts is true, outset the cutout by this amount
	center: (bool) whether 0,0 should be the center of the layout or its upper right corner
	plateCutouts: (bool) if true, generates the cutouts for a plate for the specified switch type; if false, arranges passed child objects according to the layout
*/
module layout(switchType, layout, colOffsets, tol = 0.05, center = false, plateCutouts = false) {
	layoutSize = getLayoutSize(layout, colOffsets);
	translate(center ? [-layoutSize[0]/2, layoutSize[1]/2, 0] : [0,0,0])
	for(r = [0 : len(layout)-1]) {
		if(len(layout[r][1]) > 0) for(c = [0 : len(layout[r][1])-1]) {
			keyPosition(layout, r, c, colOffsets)
			keySpace(w = layout[r][1][c][0], h = layout[r][1][c][1]) {
				if(plateCutouts) {
					keyPlateFootprint(w = layout[r][1][c][0], h = layout[r][1][c][1], tol = tol, switchType = switchType);
				} else {
					children();
				}
			}
		}
	}
}

/*
	layout_outline() generates an outline around the keys for the given layout matrix, intended for use when generating high profile case cutouts
	r: (number) rounded corner radius
	layout: (array) a layout matrix (see layout format above)
	colOffsets: (array) the vertical offsets of each column, if any (see example_col_offsets above)
	tol: (number) outset the result by this amount
	center: (bool) whether 0,0 should be the center of the layout or its upper right corner
*/
module layout_outline(r = 0, layout, colOffsets, tol = 0.05, center = false) {
	minkowski() {
		offset(r = -2*r) // inset the shape with desired rounded corner size
			offset(delta=r) // undo half of that inset so rounded corners are correct size
				layout("outline", layout= layout, colOffsets = colOffsets, tol = tol, center = center, plateCutouts = true);
		if(r > 0) circle(r = r);
	}
}

// generates a PCB for the given layout with the given margins [top, right, bottom, left] in mm
module pcb_for(layout, colOffsets, margins, thickness = 1.6, center, centerOnLayout = false, surfaceAtZero, color, outline) {
	size = getLayoutSize(layout, colOffsets);
	sizeWithMargins = [
		size[0] + margins[3] + margins[1],
		size[1] + margins[0] + margins[2]
	];
	translate( centerOnLayout ? [(margins[1]-margins[3])/2, (margins[0] - margins[2])/2, 0] : [0,0,0] )
		pcb(sizeWithMargins, thickness, center, surfaceAtZero, color, outline);
}

// centers its children in a space of the specified size in u
module keySpace(w = 1, h = 1) {
	translate(h > 1 ? [0, -h/2*u[1], 0] : [0,0,0]) {
		translate([w*u[0]/2, h*u[1]/2]) children();
	}
}

// takes a layout (see above format), row number, col number, and colOffsets vector (see above format); positions any children at the correct coordinates for the given row and column
// example usage: keyPosition(example_key_layout, 0, 0, example_col_offsets) { switch(); }
module keyPosition(layout, row, col, colOffsets) {
	keyPos = getKeyPos(layout, row, col, colOffsets);
	translate([keyPos[0]*u[0], -keyPos[1]*u[1], 0]) {
		children();
	}
}

// returns the overall [x, y] dimensions in mm of the given layout with the given column offsets
function getLayoutSize(layout, colOffsets) = [
	getKeyPos(layout, len(layout) - 1, len(layout[len(layout) - 1][1]) - 1, colOffsets)[0]*u[0] + layout[len(layout) - 1][1][len(layout[len(layout) - 1][1]) - 1][0]*u[0],
	(getRowY(layout, len(layout) - 1) + max(colOffsets)) * u[1]
];

// returns starting Y coordinate in u for a row in a layout
function getRowY(layout, row) = add([ for (i=[0:row]) layout[i][0] ]);

function getKeyX(layout, row, col) = col > 0 ? add([ for (c=[0:col-1]) layout[row][1][c][0] ]) : 0;

// returns [x, y] coordinates in u for a key at a row, col
function getKeyPos(layout, row, col, colOffsets) = [
	getKeyX(layout, row, col),
	getRowY(layout, row) + (len(colOffsets) > round(getKeyX(layout, row, col)) ? colOffsets[round(getKeyX(layout, row, col))] : 0) // find col offset for the clostest x POSITION of the key (not just its col) and add it to the Y position
];