/*
	Keyboard parts utilities
	While you are free to include or use this file directly in your own projects, it is intended for internal use by the Keyboard Parts library and the functions and modules may change at any time
	
	© 2018 Dale Price. This work is licensed under the Creative Commons Attribution-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/4.0/.
*/

u = [19.05, 19.05]; // definition of a "u" key unit in [width, height]

// add() from https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Add_all_values_in_a_list
function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

module roundrect(size = [0, 1], r = 0) {
	translate([r, r]) minkowski() {
		square([size[0] - r*2, size[1] - r*2]);
		circle(r = r);
	}
}