# TrekanterB - trekante.rb
#
# Copyright (c) 2015. Jaime Ortiz-Osorio ( jimijimi )
# emai: jim2o at hotmail.com
# or
#     : quark.charm at gmail.com

# This program requires
# Ruby 1.9.3 or greater.  
# OpenGL,
# glu and glut.
#
# The following assumes a working Ruby installation.
# To check if the components are present on the system, type:
#
#      $ gem list --local
#
# the output will be something like this:
#
# *** LOCAL GEMS ***
# glu (8.2.1 x86-mingw32)
# glut (8.2.1 x86-mingw32)
# opengl (0.9.1 x86-mingw32)
# etc ...
#
# if this is about the same then you can execute TrekanterB.
# if not, then you need to install them using gem ( preferred method )
#
#      $ gem install opengl <enter>
#      $ gem install glu <enter>
#      $ gem install glut <enter>
#
# you may need administrator privileges to execute gem 
# and under linux you may need to install ruby-dev package.
#
# trekante.rb was tested in Windows 7 and Debian 7.
#
# See accompanied license.md for license information.
#


require 'opengl'
require 'glu'
require 'glut'
require '../rotorb/roto.rb'

include Gl, Glu, Glut


def license
        puts "TrekanteR B Copyright (c) 2015 Jaime Ortiz."
        puts "TrekanteR B comes with ABSOLUTELY NOT WARRANTY."
        puts "This is free software, and you are welcome to redistribute it"
        puts "under certain conditions.( see end of code. )"
        
end


def printModelInfo( model_data )
        puts "Model name         : #{model_data['model_name']}"
        puts "Triangle count     : #{model_data['triangle_count']}"
        puts "Minimum coordinate : #{model_data['min_c']}"
        puts "Maximum coordinate : #{model_data['max_c']}"
        puts "Max dimension      : #{model_data['max_dimension']}"
        puts "Model center       : #{model_data['model_center']}"
end


def zoomin
        $zoom = $zoom * $zoom_sensitivity
        if $zoom > 24
                $zoom = 24
        end
end


def zoomout
        $zoom = $zoom / $zoom_sensitivity
        if $zoom < 0.2
                $zoom = 0.2
        end
end


def getmin( v0, v1 )
        min_is = []
        if v0[ 0 ] == nil
                v0[ 0 ] = v1[ 0 ]
        end

        #
        
        if v0[ 1 ] == nil
                v0[ 1 ] = v1[ 1 ]
        end

        if v0[ 2 ] == nil
                v0[ 2 ] = v1[ 2 ]
        end

        #
                
        if v0[ 0 ] < v1[ 0 ]
                min_is[ 0 ] = v0[ 0 ]
        else
                min_is[ 0 ] = v1[ 0 ]
        end

        #
        
        if v0[ 1 ] < v1[ 1 ]
                min_is[ 1 ] = v0[ 1 ]
        else
                min_is[ 1 ] = v1[ 1 ]
        end

        #
        
        if v0[ 2 ] < v1[ 2 ]
                min_is[ 2 ] = v0[ 2 ]
        else
                min_is[ 2 ] = v1[ 2 ]
        end

        return min_is
end


def getmax( v0, v1 )
        max_is = []

        if v0[ 0 ] == nil
                v0[ 0 ] = v1[ 0 ]
        end

        if v0[ 1 ] == nil
                v0[ 1 ] = v1[ 1 ]
        end

        if v0[ 2 ] == nil
                v0[ 2 ] = v1[ 2 ]
        end

        #
        
        if v0[ 0 ] > v1[ 0 ]
                max_is[ 0 ] = v0[ 0 ]
        else
                max_is[ 0 ] = v1[ 0 ]
        end

        if v0[ 1 ] > v1[ 1 ]
                max_is[ 1 ] = v0[ 1 ]
        else
                max_is[ 1 ] = v1[ 1 ]
        end

        if v0[ 2 ] > v1[ 2 ]
                max_is[ 2 ] = v0[ 2 ]
        else
                max_is[ 2 ] = v1[ 2 ]
        end
        return max_is
end


def getmaxdim( u, v )
        dx = ( u[ 0 ] - v[ 0 ] ).abs
        dy = ( u[ 1 ] - v[ 1 ] ).abs
        dz = ( u[ 2 ] - v[ 2 ] ).abs

        vals = [ dx, dy, dz ]

        return vals.max
end


def getcenter( u, v )
        xc = ( u[ 0 ] + v[ 0 ] ) * 0.5
        yc = ( u[ 1 ] + v[ 1 ] ) * 0.5
        zc = ( u[ 2 ] + v[ 2 ] ) * 0.5

        return [ xc, yc, zc ]
end


def get3Ddata( stl_file )

        model_data = { }
        triangle_count = 0
        normals = []
        temp_vertex = []
        temp_triangle = []
        triangles = []
        name = ""
        vertex_count = 0
        min_c = []
        max_c = []

        min_c[ 0 ] = nil
        min_c[ 1 ] = nil
        min_c[ 2 ] = nil

        max_c[ 0 ] = nil
        max_c[ 1 ] = nil
        max_c[ 2 ] = nil

        max_dim = 0

        model_data[ 'normal_array' ] = []
        model_data[ 'vertex_array' ] = []
        model_data[ 'color_array' ] = []
        model_data[ 'index_array' ] = []

        puts "\nOpening file: #{stl_file}."        
        puts "Preparing normal and vertex array."
        File.open( stl_file ).each do | this_line |
                if this_line.include? "endfacet"
                        triangle_count += 1
                elsif ( this_line.include? "solid" ) && !( this_line.include? "endsolid" )
                        split_line = this_line.split( " " )
                        name = split_line[ 1 ]
                elsif ( this_line.include? "facet" ) && ( this_line.include? "normal" )
                        split_line = this_line.split( " " )
                        model_data[ 'normal_array' ].push( split_line[ 2 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 3 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 4 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 2 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 3 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 4 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 2 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 3 ].to_f )
                        model_data[ 'normal_array' ].push( split_line[ 4 ].to_f )
                elsif this_line.include? "vertex"
                        vertex_count += 1
                        split_line = this_line.split( " " )
                        temp_vertex.push( split_line[ 1 ].to_f )
                        temp_vertex.push( split_line[ 2 ].to_f )
                        temp_vertex.push( split_line[ 3 ].to_f )

                        model_data[ 'vertex_array' ].push( temp_vertex[ 0 ] )
                        model_data[ 'vertex_array' ].push( temp_vertex[ 1 ] )
                        model_data[ 'vertex_array' ].push( temp_vertex[ 2 ] )

                        min_c = getmin( min_c, temp_vertex )
                        max_c = getmax( max_c, temp_vertex )
                        
                        temp_vertex = []
                end
        end

        puts "Preparing color array."
        color = [ 255, 0, 0, 255 ]
        for i in ( 0...( triangle_count * 3 ) )
                model_data['color_array'].push( color[ 0 ] )
                model_data['color_array'].push( color[ 1 ] )
                model_data['color_array'].push( color[ 2 ] )
                model_data['color_array'].push( color[ 3 ] )
        end
        
        puts "Preparing index array."
        j = 0
        for i in ( 0...( triangle_count * 3 ) )
                model_data['index_array'][i] = j
                j += 1
        end

        puts "Getting additional model information."
        model_data[ 'model_name' ] = name
        model_data[ 'triangle_count' ] = triangle_count
        model_data[ 'vertex_count' ] = triangle_count * 3
        model_data[ 'min_c' ] = min_c
        model_data[ 'max_c' ] = max_c
        model_data[ 'max_dimension' ] = getmaxdim( min_c, max_c )
        model_data[ 'model_center' ] = getcenter( min_c, max_c )
        puts " "
        
        return model_data
end


def glinit( )
	light_diffuse = [1.0, 0.0, 0.0, 1.0]
	light_position = [0.0, 0.0, 30.0, 0.0]
	two_sided = [ 1.0 ]
	white_light = [ 1.0, 1.0, 1.0, 1.0 ]
	mat_specular = [ 0.16, 0.16, 0.16, 1.0 ]
	mat_shininess = [ 50.0 ]
	#
	glShadeModel( GL_SMOOTH )
        glClearColor( 0.0, 0.0, 0.0, 0.0 )
        glClearDepth( 1.0 )
	glMaterialfv( GL_FRONT, GL_SPECULAR, mat_specular )
	glMaterialfv( GL_FRONT, GL_SHININESS, mat_shininess )
	glLight( GL_LIGHT0, GL_DIFFUSE, white_light )
	glLight( GL_LIGHT0, GL_POSITION, light_position )
	glLight( GL_LIGHT0, GL_SPECULAR, white_light )
	glLightModelfv( GL_LIGHT_MODEL_TWO_SIDE, two_sided )
	glEnable( GL_LIGHT0 )
	glEnable( GL_LIGHTING )
	glEnable( GL_DEPTH_TEST )
	glEnable( GL_NORMALIZE )
	glEnable( GL_BLEND )
        glEnable( GL_DITHER )
        glEnable( GL_COLOR_MATERIAL )
        glEnable( GL_VERTEX_ARRAY )
        glEnable( GL_COLOR_ARRAY )
        glEnable( GL_NORMAL_ARRAY )
        glEnable( GL_INDEX_ARRAY )
        glDepthFunc( GL_LEQUAL )
        glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST )
	glColorMaterial( GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE )
end

def drawAxis
        line_lenght = 30.0
        viewport_width = glutGet( GLUT_WINDOW_WIDTH )
        viewport_height = glutGet( GLUT_WINDOW_HEIGHT )
        glMatrixMode( GL_PROJECTION )
        glPushMatrix
          glLoadIdentity
          glOrtho( 0,
                   viewport_width,
                   0,
                   viewport_height,
                   -line_lenght,
                   line_lenght )
          glMatrixMode( GL_MODELVIEW )
          glPushMatrix
              glLoadIdentity
              glDisable( GL_DEPTH_TEST )
              glDisable( GL_LIGHTING )
              glTranslatef( line_lenght + 5,
                            viewport_height - line_lenght - 5,
                            0 )
              glMultMatrixf( $transformation )
              glLineWidth( 1.7 )
              glBegin( GL_LINES )
                 glColor3ub( 255, 0, 0 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( line_lenght, 0.0, 0.0 )
                 glColor3ub( 0, 255, 0 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( 0.0, line_lenght, 0.0 )
                 glColor3ub( 0, 0, 255 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( 0.0, 0.0, line_lenght )
              glEnd
              glLineWidth( 1.0 )
              glEnable( GL_LIGHTING )
              glEnable( GL_DEPTH_TEST )
          glPopMatrix
          glMatrixMode( GL_PROJECTION )
        glPopMatrix
        glMatrixMode( GL_MODELVIEW )
end


def drawOrigin
        line_lenght = 0.0
        if $model_data['max_dimension'] == 0
                line_lenght = 1.0
        else
                line_lenght = $model_data[ 'max_dimension' ] / 2
        end

        glScalef( 1.0 / $zoom,
                  1.0/ $zoom,
                  1.0/ $zoom )
        glDisable( GL_LIGHTING )
        glBegin( GL_LINES )
                 glColor3ub( 255, 0, 0 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( line_lenght, 0.0, 0.0 )
                 glColor3ub( 0, 255, 0 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( 0.0, line_lenght, 0.0 )
                 glColor3ub( 0, 0, 255 )
                 glVertex3f( 0.0, 0.0, 0.0 )
                 glVertex3f( 0.0, 0.0, line_lenght )
        glEnd
        glEnable( GL_LIGHTING )
end

def drawModel
        glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )
        viewport_width = glutGet( GLUT_WINDOW_WIDTH )
        viewport_height = glutGet( GLUT_WINDOW_HEIGHT )
        max_dim = $model_data['max_dimension']
        $camera_z = 1.5 * max_dim
        fov_rad = Math.atan( (  $model_data[ 'max_dimension' ] / 2.0 ) / ( $model_data[ 'max_dimension' ] ) )
        $fov = 360.0 * fov_rad / Math::PI
        aspect = viewport_width * 1.0  / viewport_height * 1.0
        glClearColor( 0.0, 0.0, 0.0, 0.0 )
        glMatrixMode( GL_PROJECTION )
        glLoadIdentity
        gluPerspective( $fov, aspect, $z_min, $z_max )
        glMatrixMode( GL_MODELVIEW )
        gluLookAt( $camera_x, $camera_y, $camera_z,
                   0, 0, 0,
                   0, 1, 0 )
        glPolygonMode( GL_FRONT_AND_BACK, GL_FILL )
        glPushMatrix
        glScalef( $zoom, $zoom, $zoom )
        glTranslatef( $x_pan, $y_pan, 0 )
        glMultMatrixf( $transformation )
        glTranslatef( -1 * $model_data[ 'model_center' ][ 0 ],
                      -1 * $model_data[ 'model_center' ][ 1 ],
                      -1 * $model_data['model_center'][ 2 ] )
        glColor3f( 1.0, 0.0, 0.0 )

        glNormalPointer( GL_FLOAT, 0, $model_data['normal_array'] )
        glColorPointer( 4, GL_UNSIGNED_BYTE, 0, $model_data[ 'color_array' ] )
        glVertexPointer( 3, GL_FLOAT, 0, $model_data[ 'vertex_array' ] )
        glDrawElements( GL_TRIANGLES, $model_data[ 'vertex_count' ], GL_UNSIGNED_INT, $model_data[ 'index_array' ] ) 
        
        drawOrigin
        drawAxis
        
        glPopMatrix
        glFlush
end


$transformation = [ 1.0, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0,
		    0.0, 0.0, 1.0, 0.0,
		    0.0, 0.0, 0.0, 1.0 ]

$this_rotation = [ 1.0, 0.0, 0.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
		   0.0, 0.0, 1.0, 0.0,
		   0.0, 0.0, 0.0, 1.0 ]			  

$last_rotation = [ 1.0, 0.0, 0.0, 0.0,
                   0.0, 1.0, 0.0, 0.0,
		   0.0, 0.0, 1.0, 0.0,
		   0.0, 0.0, 0.0, 1.0 ]

$z_min = 0.9
$z_max = 12000

#mouse buttons
$left_button_down = 0
$right_button_down = 0
$middle_button_down = 0

$pan_factor = 250
$x_pan = 0
$y_pan = 0
$cam_pos_factor_when_small = 30.0
$cam_pos_factor_when_big = 10.0
$translate_sensitivity = 1.0
$zoom_sensitivity = 1.04

$set_initial_coordinate = 1
$initial_coordinate = { 'x' => 0, 'y' => 0 }
$world_initial_coordinate = { 'x' => 0, 'y' => 0 }

$screen_center_x
$screen_center_y
$sphere_radius
$v0 = []
$v1 = []
$qdrag = []

$zoom = 1.0
$camera_x = 0.0
$camera_y = 0.0
$camera_z = 1.5
$fov = 10.0


display = Proc.new do
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glLoadIdentity
        glPushMatrix
        drawModel
        glPopMatrix
	glutSwapBuffers
        glFlush
end


keyboard = Proc.new do |key, x, y|
	case (key)
		when ?\e
		exit(0);
	end
end


mouse = Proc.new do | button, state, x, y |
        if button == 3 || button == 4
                if state == GLUT_UP
                        #return
                end

                if button == 3
                        zoomout
                        glutPostRedisplay
                end

                if button == 4
                        zoomin
                        glutPostRedisplay
                end
        end

        if button == GLUT_RIGHT_BUTTON
                $right_button_down = 1
        end

        if button == GLUT_MIDDLE_BUTTON
                $middle_button_down = 1
        end

        
        if button == GLUT_LEFT_BUTTON
		$left_button_down = 1
	end
		
	if state == GLUT_UP
                $left_button_down = 0
                $middle_button_down = 0
                $right_button_down = 0
		$set_initial_coordinate = 1
	end
end


mouse_motion = Proc.new do | x, y |
        viewport = []
        mvmatrix = []
        projmatrix = []
        wx = 0
        wy = 0
        wz = 0
        delta_x = 0
        delta_y = 0
        real_y = 0

        if $right_button_down == 1
                viewport = glGetIntegerv( GL_VIEWPORT )
                mvmatrix = glGetDoublev( GL_MODELVIEW_MATRIX )
                projmatrix = glGetDoublev( GL_PROJECTION_MATRIX )
                real_y = viewport[ 3 ] - y - 1
                wx, wy, wz = gluUnProject( x, real_y, 0.0, mvmatrix, projmatrix, viewport )
                
                if $set_initial_coordinate == 1
                        $initial_coordinate[ 'x' ] = x
                        $initial_coordinate[ 'y' ] = y
                        $world_initial_coordinate[ 'x' ] = wx
                        $world_initial_coordinate[ 'y' ] = wy
                        $set_initial_coordinate = 0
                else
                        delta_x = wx - $world_initial_coordinate[ 'x' ]
                        delta_y = wy - $world_initial_coordinate[ 'y' ]
                        if $model_data[ 'max_dimension' ] > 10.0 && $model_data[ 'max_dimension' ] < 501.0
                                $x_pan = ( $x_pan + delta_x * $model_data[ 'max_dimension' ] / $zoom ) * $translate_sensitivity
                                $y_pan = ( $y_pan + delta_y * $model_data[ 'max_dimension' ] / $zoom ) * $translate_sensitivity
                        elsif $model_data[ 'max_dimension' ] > 500.0 && $model_data[ 'max_dimension' ] < 1000.0
                                $x_pan = ( $x_pan + delta_x * $model_data[ 'max_dimension' ] * 0.1 / $zoom ) * $translate_sensitivity
                                $y_pan = ( $y_pan + delta_y * $model_data[ 'max_dimension' ] * 0.1 / $zoom ) * $translate_sensitivity
                        elsif $model_data[ 'max_dimesnion' ] > 999
                                $x_pan = ( $x_pan + delta_x * $model_data[ 'max_dimension' ] * 0.0222 / $zoom ) * $translate_sensitivity
                                $y_pan = ( $y_pan + delta_y * $model_data[ 'max_dimension' ] * 0.0222 / $zoom ) * $translate_sensitivity
                        else
                                $x_pan = ( $x_pan + delta_x * $model_data[ 'max_dimension' ] * $cam_pos_factor_when_small / $zoom ) * $translate_sensitivity
                                $y_pan = ( $y_pan + delta_y * $model_data[ 'max_dimension' ] * $cam_pos_factor_when_small / $zoom ) * $translate_sensitivity
                        end
                end
                
                
                $world_initial_coordinate[ 'x' ] = wx
                $world_initial_coordinate[ 'y' ] = wy
                
                $initial_coordinate[ 'x' ] = x
                $initial_coordinate[ 'y' ] = y

                glutPostRedisplay
        end
        
        
	if $left_button_down == 1
		window_width = glutGet( GLUT_WINDOW_WIDTH )
		window_height = glutGet( GLUT_WINDOW_HEIGHT )
		$screen_center_x = window_width / 2.0
		$screen_center_y = window_height / 2.0
		$sphere_radius = Roto.vectorMagnitude( [ $screen_center_x, $screen_center_y, 0 ] ) 
		if $set_initial_coordinate == 1
			$last_rotation = $transformation
			$v0 = [ ( x - $screen_center_x ) / $sphere_radius, ( y - $screen_center_y ) / $sphere_radius, 0 ]
			v0_magnitude = Roto.vectorMagnitude( $v0 )
			$v0[ 2 ] = ( 1 - v0_magnitude ** 2 ) ** 0.5
			$set_initial_coordinate = 0
		elsif  x >= 0 && x <= window_width && y >= 0 && y <= window_height
			$v1 = [ ( x - $screen_center_x ) / $sphere_radius, ( y - $screen_center_y ) / $sphere_radius, 0 ]
			v1_magnitude = Roto.vectorMagnitude( $v1 )
			$v1[ 2 ] = ( 1 - v1_magnitude ** 2 ) ** 0.5
			quat_vector_part = Roto.vectorCrossProduct( $v0, $v1 )
			quat_real_part = Roto.vectorDotProduct( $v0, $v1 )
			$qdrag = [ quat_real_part, quat_vector_part[ 0 ], -quat_vector_part[ 1 ], quat_vector_part[ 2 ] ]
			$this_rotation = Roto.quaternionToMatrix( $qdrag )
			$transformation = Roto.matrix4x4_Multiplication( $last_rotation, $this_rotation )
			glutPostRedisplay
		end
	end

        if $middle_button_down == 1
                if $set_initial_coordinate == 1
                        $initial_coordinate[ 'x' ] = x
                        $initial_coordinate[ 'y' ] = y
                        $set_initial_coordinate = 0
                end

                if y < $initial_coordinate[ 'y']
                        zoomout
                        glutPostRedisplay
                end

                if y > $initial_coordinate[ 'y' ]
                        zoomin
                        glutPostRedisplay
                end
                $initial_coordinate[ 'x' ] = x
                $initial_coordinate[ 'y' ] = y
        end
end


reshape = Proc.new do | w, h |
        if ( h == 0 )
                h = 1
        end
        aspect = w / h
        
        if ( $model_data[ 'max_dimension' ] <= 10.0 )
                $camera_z = $cam_pos_factor_when_small * $model_data['max_dimension']
                fov_rad = Math.atan( ( 1.1 * $model_data[ 'max_dimension' ] / 1.5 ) / ( $model_data[ 'max_dimension' ] * $cam_pos_factor_when_small ) )
        elsif
                $camera_z = $cam_pos_factor_when_big * $model_data['max_dimension']
                fov_rad = Math.atan( ( 1.1 * $model_data[ 'max_dimension' ] / 1.5 ) / ( $model_data[ 'max_dimension' ] * $cam_pos_factor_when_big ) )
        end
        
        $fov = 360.0 * fov_rad / Math::PI
        glViewport( 0, 0, w, h )
        glMatrixMode( GL_PROJECTION )
        glLoadIdentity
        gluPerspective( $fov, aspect, $z_min, $z_max )
        glMatrixMode( GL_MODELVIEW )
end


stl_file = ARGV[ 0 ]
$model_data = get3Ddata( stl_file )
printModelInfo( $model_data )
glutInit
glutInitDisplayMode( GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH )
glutInitWindowSize( 500, 500 )
glutInitWindowPosition( 100, 100 )
glutCreateWindow( "TrekanterB" )
glutDisplayFunc( display )
glutReshapeFunc( reshape )
glutKeyboardFunc( keyboard )
glutMouseFunc( mouse )
glutMotionFunc( mouse_motion )
glinit( )
glutMainLoop( )


__END__


<<LICENSE
GNU GENERAL PUBLIC LICENSE
Version 2, June 1991

Copyright (C) 1989, 1991 Free Software Foundation, Inc.,

51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.
Preamble

The licenses for most software are designed to take away your
freedom to share and change it. By contrast, the GNU General Public
License is intended to guarantee your freedom to share and change free
software--to make sure the software is free for all its users. This
General Public License applies to most of the Free Software
Foundation's software and to any other program whose authors commit to
using it. (Some other Free Software Foundation software is covered by
the GNU Lesser General Public License instead.) You can apply it to
your programs, too.

When we speak of free software, we are referring to freedom, not
price. Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
this service if you wish), that you receive source code or can get it
if you want it, that you can change the software or use pieces of it
in new free programs; and that you know you can do these things.
To protect your rights, we need to make restrictions that forbid
anyone to deny you these rights or to ask you to surrender the rights.
These restrictions translate to certain responsibilities for you if you
distribute copies of the software, or if you modify it.
For example, if you distribute copies of such a program, whether
gratis or for a fee, you must give the recipients all the rights that
you have. You must make sure that they, too, receive or can get the
source code. And you must show them these terms so they know their
rights.

We protect your rights with two steps: (1) copyright the software, and
(2) offer you this license which gives you legal permission to copy,
distribute and/or modify the software.

Also, for each author's protection and ours, we want to make certain
that everyone understands that there is no warranty for this free
software. If the software is modified by someone else and passed on, we
want its recipients to know that what they have is not the original, so
that any problems introduced by others will not reflect on the original
authors' reputations.

Finally, any free program is threatened constantly by software
patents. We wish to avoid the danger that redistributors of a free
program will individually obtain patent licenses, in effect making the
program proprietary. To prevent this, we have made it clear that any
patent must be licensed for everyone's free use or not licensed at all.
The precise terms and conditions for copying, distribution and
modification follow.

GNU GENERAL PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. This License applies to any program or other work which contains
a notice placed by the copyright holder saying it may be distributed
under the terms of this General Public License. The "Program", below,
refers to any such program or work, and a "work based on the Program"
means either the Program or any derivative work under copyright law:
that is to say, a work containing the Program or a portion of it,
either verbatim or with modifications and/or translated into another
language. (Hereinafter, translation is included without limitation in
the term "modification".) Each licensee is addressed as "you".
Activities other than copying, distribution and modification are not
covered by this License; they are outside its scope. The act of
running the Program is not restricted, and the output from the Program
is covered only if its contents constitute a work based on the
Program (independent of having been made by running the Program).
Whether that is true depends on what the Program does.

1. You may copy and distribute verbatim copies of the Program's
source code as you receive it, in any medium, provided that you
conspicuously and appropriately publish on each copy an appropriate
copyright notice and disclaimer of warranty; keep intact all the
notices that refer to this License and to the absence of any warranty;
and give any other recipients of the Program a copy of this License
along with the Program.
You may charge a fee for the physical act of transferring a copy, and
you may at your option offer warranty protection in exchange for a fee.

2. You may modify your copy or copies of the Program or any portion
of it, thus forming a work based on the Program, and copy and
distribute such modifications or work under the terms of Section 1
above, provided that you also meet all of these conditions:
a) You must cause the modified files to carry prominent notices
stating that you changed the files and the date of any change.
b) You must cause any work that you distribute or publish, that in
whole or in part contains or is derived from the Program or any
part thereof, to be licensed as a whole at no charge to all third
parties under the terms of this License.
c) If the modified program normally reads commands interactively
when run, you must cause it, when started running for such
interactive use in the most ordinary way, to print or display an
announcement including an appropriate copyright notice and a
notice that there is no warranty (or else, saying that you provide
a warranty) and that users may redistribute the program under
these conditions, and telling the user how to view a copy of this
License. (Exception: if the Program itself is interactive but
does not normally print such an announcement, your work based on
the Program is not required to print an announcement.)
These requirements apply to the modified work as a whole. If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works. But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it.
Thus, it is not the intent of this section to claim rights or contest
your rights to work written entirely by you; rather, the intent is to
exercise the right to control the distribution of derivative or
collective works based on the Program.
In addition, mere aggregation of another work not based on the Program
with the Program (or with a work based on the Program) on a volume of
a storage or distribution medium does not bring the other work under
the scope of this License.

3. You may copy and distribute the Program (or a work based on it,
under Section 2) in object code or executable form under the terms of
Sections 1 and 2 above provided that you also do one of the following:
a) Accompany it with the complete corresponding machine-readable
source code, which must be distributed under the terms of Sections
1 and 2 above on a medium customarily used for software interchange; or,
b) Accompany it with a written offer, valid for at least three
years, to give any third party, for a charge no more than your
cost of physically performing source distribution, a complete
machine-readable copy of the corresponding source code, to be
distributed under the terms of Sections 1 and 2 above on a medium
customarily used for software interchange; or,
c) Accompany it with the information you received as to the offer
to distribute corresponding source code. (This alternative is
allowed only for noncommercial distribution and only if you
received the program in object code or executable form with such
an offer, in accord with Subsection b above.)
The source code for a work means the preferred form of the work for
making modifications to it. For an executable work, complete source
code means all the source code for all modules it contains, plus any
associated interface definition files, plus the scripts used to
control compilation and installation of the executable. However, as a
special exception, the source code distributed need not include
anything that is normally distributed (in either source or binary
form) with the major components (compiler, kernel, and so on) of the
operating system on which the executable runs, unless that component
itself accompanies the executable.
If distribution of executable or object code is made by offering
access to copy from a designated place, then offering equivalent
access to copy the source code from the same place counts as
distribution of the source code, even though third parties are not
compelled to copy the source along with the object code.

4. You may not copy, modify, sublicense, or distribute the Program
except as expressly provided under this License. Any attempt
otherwise to copy, modify, sublicense or distribute the Program is
void, and will automatically terminate your rights under this License.
However, parties who have received copies, or rights, from you under
this License will not have their licenses terminated so long as such
parties remain in full compliance.

5. You are not required to accept this License, since you have not
signed it. However, nothing else grants you permission to modify or
distribute the Program or its derivative works. These actions are
prohibited by law if you do not accept this License. Therefore, by
modifying or distributing the Program (or any work based on the
Program), you indicate your acceptance of this License to do so, and
all its terms and conditions for copying, distributing or modifying
the Program or works based on it.

6. Each time you redistribute the Program (or any work based on the
Program), the recipient automatically receives a license from the
original licensor to copy, distribute or modify the Program subject to
these terms and conditions. You may not impose any further
restrictions on the recipients' exercise of the rights granted herein.
You are not responsible for enforcing compliance by third parties to
this License.

7. If, as a consequence of a court judgment or allegation of patent
infringement or for any other reason (not limited to patent issues),
conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License. If you cannot
distribute so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you
may not distribute the Program at all. For example, if a patent
license would not permit royalty-free redistribution of the Program by
all those who receive copies directly or indirectly through you, then
the only way you could satisfy both it and this License would be to
refrain entirely from distribution of the Program.
If any portion of this section is held invalid or unenforceable under
any particular circumstance, the balance of the section is intended to
apply and the section as a whole is intended to apply in other
circumstances.

It is not the purpose of this section to induce you to infringe any
patents or other property right claims or to contest validity of any
such claims; this section has the sole purpose of protecting the
integrity of the free software distribution system, which is
implemented by public license practices. Many people have made
generous contributions to the wide range of software distributed
through that system in reliance on consistent application of that
system; it is up to the author/donor to decide if he or she is willing
to distribute software through any other system and a licensee cannot
impose that choice.
This section is intended to make thoroughly clear what is believed to
be a consequence of the rest of this License.

8. If the distribution and/or use of the Program is restricted in
certain countries either by patents or by copyrighted interfaces, the
original copyright holder who places the Program under this License
may add an explicit geographical distribution limitation excluding
those countries, so that distribution is permitted only in or among
countries not thus excluded. In such case, this License incorporates
the limitation as if written in the body of this License.

9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time. Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.
Each version is given a distinguishing version number. If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation. If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
Foundation.

10. If you wish to incorporate parts of the Program into other free
programs whose distribution conditions are different, write to the author
to ask for permission. For software which is copyrighted by the Free
Software Foundation, write to the Free Software Foundation; we sometimes
make exceptions for this. Our decision will be guided by the two goals
of preserving the free status of all derivatives of our free software and
of promoting the sharing and reuse of software generally.
NO WARRANTY

11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS
TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE
PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
REPAIR OR CORRECTION.

12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.
END OF TERMS AND CONDITIONS

How to Apply These Terms to Your New Programs
If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.
To do so, attach the following notices to the program. It is safest
to attach them to the start of each source file to most effectively
convey the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.
<one line to give the program's name and a brief idea of what it does.>
Copyright (C) <year> <name of author>
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
Also add information on how to contact you by electronic and paper mail.

If the program is interactive, make it output a short notice like this
when it starts in an interactive mode:
Gnomovision version 69, Copyright (C) year name of author
Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
0under certain conditions; type `show c' for details.
The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License. Of course, the commands you use may
be called something other than `show w' and `show c'; they could even be
mouse-clicks or menu items--whatever suits your program.
You should also get your employer (if you work as a programmer) or your
school, if any, to sign a "copyright disclaimer" for the program, if
necessary. Here is a sample; alter the names:
Yoyodyne, Inc., hereby disclaims all copyright interest in the program
`Gnomovision' (which makes passes at compilers) written by James Hacker.
<signature of Ty Coon>, 1 April 1989
Ty Coon, President of Vice

This General Public License does not permit incorporating your program into
proprietary programs. If your program is a subroutine library, you may
consider it more useful to permit linking proprietary applications with the
library. If this is what you want to do, use the GNU Lesser General
Public License instead of this License.

>>
