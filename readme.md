TrekanteR B
===========

trekantER is a Stereo Lithography file viewer written in Ruby.
Trekanter Currently is implemented in the old openGL pipeline style ( immediate mode ) and glut.
Plans exist to migrate to modern OpenGL.

The intention is to have a simple visualization tool for small STL files ( < 0.5M triangles ) that works under Windows and Linux for code/algorith testing.  


Features:
---------

Runs unchanged under Windows and Linux and potentially Mac provided the appropriate libraries ara installed.

Full arcball capability.

Full x,y pan capability.

Zoom capability

Very compact code, easy to read and understand.


Limitations:
------------

It can only show one part at a time.

This Ruby implementation may be slow, for large files ( > 0.1M triangles ) depending on the hardware, but it is just fine for a quick visualization.


Only ASCII files, binary files to be inplemented soon.


Future work:
------------


Support multiple geometries.

Selection of parts.

To read STL binary files.

Rewrite in modern OpenGL and other that GLUT after experimenting with this code.

Also hoping that the guys from the shoes.rb project implement a OpenGL context in their GUI tools.

To add error checking.


Requirements:
-------------

OpenGL ruby library.

glu and glut libraries.

A Ruby installation.

The program was tested using Ruby 1.9.3 on Windows 7 and Debian 7


To check if the components are present in the system, type:

	$ gem list --local

Linux users may need administrator privileges.

The output will be something like this:

```
*** LOCAL GEMS ***
glu (8.2.1 x86-mingw32)
glut (8.2.1 x86-mingw32)
opengl (0.9.1 x86-mingw32)
etc ...
```

If this is about the same then you can execute Trekanter-B.
If not, then you need to install them using 'gem' ( preferred method ) or by building the gems by yourself.

	$ gem install opengl <enter>
	$ gem install glu <enter>
	$ gem install glut <enter>

Installation:
-------------

(1) Clone the repository.

(2) Clone the trekanterB repository.

(3) Clone the rotorb library to have access to the quaternion/arcball functions.

(3) Change the path of the rotorb library inside cube.rb to the correct one.

(4) run using
	
	$ ruby .\trekante.rb my_stl_file.stl


Controls:
---------


Mouse left button + mouse drag - model rotation

Mouse right button + mouse grag - x, y tranlation

Mouse middle button + mouse up/down drag - zoom

Mouse scroll wheel - zoom

	
Autor:
------

Jaime Ortiz ( jimijimi ) email: jim2o at hotmail.com or quark.charm at gmail.com	
	
	
License:
--------

The ruby arcball controller implementation is Copyright(C) 2015 Jaime Ortiz.
See license.md file for licensing information.	

Document last updated March 31, 2015

