/*
	Switch Colors – color definitions for most varieties of mechanical keyboard switches
*/

// returns the color of the desired color from switchColors or a random color if the passed color name is not known or no color name is passed
// example usage: switchColor("brown") // returns the color value for the stem of cherry (or compatible) brown switches
// switchColor() // returns a random color from the known key switch varieties
function switchColor(color) = search([color], switchColors)[0] != [] ? switchColors[search([color], switchColors)[0]][1] : switchColors[randInt(0, len(switchColors)-1)][1];

switchColors = [
	// normal cherry and compatibles
	["red", [1,0,0]],
	["blue", [0.06, 0.45, 0.83]],
	["brown", [.28, .16, .1]],
	["black", [.1, .1, .1]],
	["clear", [0.9, 0.9, 0.9, 0.75]],
	
	// less well known cherry
	["nature_white", [0.9, 0.9, 0.9, 0.5]],
	["silent_red", [1, 0.5, 0.5]],
	["green", rgb(33, 154, 104)],
	["grey", [.6, .6, .6]],
	["gray", [.6, .6, .6]],
	["speed_silver", [.75,.75,.75]],
	["white", [1, 1, 1]],
	
	// kailh speed
	["bronze", rgb(179, 83, 59)],
	["copper", rgb(122, 34, 51)],
	["silver", rgb(209, 209, 209)],
	["gold", rgb(227, 168, 43)],
	["pink", rgb(205, 116, 156)],
	 
	// kailh pro
	["light_green", rgb(35, 127, 115)],
	["purple", rgb(79, 38, 96)],
	["burgundy", rgb(120, 38, 47)],
	
	// novelkeys x kailh
	["berry", rgb(82, 37, 35)],
	["plum", rgb(55, 37, 43)],
	["sage", rgb(53, 55, 44)],
	["jade", rgb(170, 203, 162)],
	["navy", rgb(61, 72, 99)],
	["dark_yellow", rgb(220, 195, 62)],
	["pale_blue", rgb(126, 148, 189)],
	["burnt_orange", rgb(213, 100, 80)],
	
	// aliaz
	["pink", rgb(213, 46, 130)],
		
	// zealios
	["lavender", rgb(137, 109, 213)], // 62g
	["violet", rgb(115, 85, 192)], // 65g
	["deep_violet", rgb(78, 62, 146)], // 67g
	["deeper_violet", rgb(68, 55, 115)], // 78g
	["tiffany_blue", rgb(129, 216, 208)], // tealio 67g
	
	// zilents
	["zilent62", rgb(160, 229, 243)],
	["zilent65", rgb(40, 197, 229)],
	["zilent67", rgb(41, 83, 148)],
	["zilent78", rgb(27, 33, 64)],
	
	// hako
	["pink_salt", rgb(227, 148, 131)], // hako true
	["hako_violet", rgb(189, 149, 186)],
	
	// misc
	["yellow", rgb(254, 227, 46)],
	["razer_green", rgb(81, 212, 57)],
	["orange", rgb(252, 162, 36)],
];

function rgb(r, g, b, a = 1) = [r/255, g/255, b/255, a];