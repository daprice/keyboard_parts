# Keyboard Parts OpenSCAD library

An [OpenSCAD](http://www.openscad.org) library to assist with CAD design of mechanical keyboard parts and accessories.

Provides 3D models and plate cutout shapes for mechanical key switches and other parts as well as functions and modules for defining and working with keyboard layouts. (currently there is only a rough model of PG1350-style switches suitable for making mounting plates; I plan on adding support for more switches over time, or you can fork this project and add your own definitions to parts.scad)

## Installation
To include in your OpenSCAD project, add this library's directory to the same directory as your main OpenSCAD file (or a subdirectory such as `/lib` if you prefer). If you're using Git, then you can do `git submodule add https://github.com/daprice/keyboard_parts.git` to add a [submodule](http://www.git-scm.com/book/en/v2/Git-Tools-Submodules) reference to the library, which makes it easy to keep up to date and for others who use your git repo to get a copy of the library.

This library can also be added to your local installation of OpenSCAD per the [User Manual](https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries), but be sure to document the dependency if you share your project with anyone.

## Documentation & Usage
For the time being, the code is fairly well commented to explain what each function and module does and how to use them. I also use this library in my [Airpad](https://github.com/daprice/ios-macropad) project so you can use that as an example.


------------------------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).