TrekantER-B
===========

trekantER is a Stereo Lithography file reader written in Ruby.
Treteker Currently is implemented in the old openGL pipeline style ( immediate mode ) and glut.
Plans exist to migrate to modern OpenGL.

The intention is to have a simple visualization tool for small STL files ( < 0.5M triangles ) that works under Windows and Linux for algorith testing/understanding.  


Features:
---------

Runs unchanged under Windows and Linux and potentially Mac provided the appropriate libraries ara installed.
Full arcball capability.
Very compact code, easy to read and understand.


Limitations:
------------

It can only show one part at a time.
This Ruby implementation may be slow, for large files ( > 0.5M triangles ) depending on the hardware.
No zoom / No pan


Future work:
------------

Add zoom/pan.
Support multiple geometries.
Selection of parts.
Rewrite in modern OpenGL and other that GLUT.
Also hoping that the guys from the shoes.rb project implement a OpenGL context in their GUI tools.


Requirements:
-------------

opengl ruby library.
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

	
	
Autor:
------

Jaime Ortiz ( jimijimi ) email: jim2o at hotmail.com or quark.charm at gmail.com	
	
	
License:
--------

The ruby arcball controller implementation is Copyright(C) 2015 Jaime Ortiz.
See license.md file for licensing information.	
