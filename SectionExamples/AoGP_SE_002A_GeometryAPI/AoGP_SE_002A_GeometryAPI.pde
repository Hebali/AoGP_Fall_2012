// Art of Graphics Programming
// Section Example 002: "Drawing Geometries: From Processing to OpenGL"
// Example Stage: A
// Course Materials by Patrick Hebron

import processing.opengl.*;

int   drawType;
PFont mFont;

void setup() {
  // Before we try to integrate a more elaborate geometric data structure into our
  // scene graph, let's look at some of the ways we can generate various geometries
  // in Processing and OpenGL.
  
  // Processing provides simple, built-in functions for the following 2D primitives:
  // Points, lines, triangles, rectangles, quadrilaterals, ellipses and arcs.
  
  // To be precise, points are zero-dimensional and lines are one-dimensional.
  // Since these figures would not be visible as such, in Processing and OpenGL,
  // a point is rendered as a circle and a line is rendered with some width.
  
  // Processing also provides built-in functions for the following 3D primitives:
  // Box (cube) and sphere.
  
  // These built-in functions are easy to use, but each function takes a unique set of inputs,
  // which is not ideal for a generic geometric data structure. After this, we'll look at
  // ways of constructing primitives and custom geometries using more generic tools.
  
  size( 500, 500, OPENGL );
  
  mFont = createFont( "Helvetica", 32 );
  textFont( mFont );
  textAlign( CENTER );  
  
  drawType = 0;
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( width/2, height/2, 0.0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  if( drawType == 0 ) {
    strokeWeight( 10 );
    point( 0.0, 0.0, 0.0 );
  }
  else if( drawType == 1 ) {  
    strokeWeight( 5 );
    line( -50.0, -50.0, -50.0, 50.0, 50.0, 50.0 );
  }
  else if( drawType == 2 ) {
    strokeWeight( 2 );
    triangle( 0.0, -50.0, -50.0, 50.0, 50.0, 50.0 );
  }
  else if( drawType == 3 ) {
    strokeWeight( 2 );
    rect( -50.0, -25.0, 100.0, 50.0 );
  }
  else if( drawType == 4 ) {
    strokeWeight( 2 );
    quad( -25.0, -25.0, 25.0, -25.0, 50.0, 25.0, -50.0, 25.0 );
  }
  else if( drawType == 5 ) {
    strokeWeight( 2 );
    ellipse( 0.0, 0.0, 100.0, 100.0 );
  }
  else if( drawType == 6 ) {
    strokeWeight( 2 );
    arc( 0.0, 0.0, 100.0, 100.0, 0.0, PI );
  }
  else if( drawType == 7 ) {
    strokeWeight( 1 );
    pushMatrix();
    rotateX( PI/3.0 );
    rotateY( PI/3.0 );
    rotateZ( PI/3.0 );
    box( 100.0, 100.0, 100.0 );
    popMatrix();
  }
  else if( drawType == 8 ) {
    strokeWeight( 1 );
    sphere( 100.0 );
  }
  
  // Draw the appropriate text label
  String[] labels = {"point()","line()","triangle()","rect()","quad()","ellipse()","arc()","box()","sphere()"};                   
  text( labels[drawType], 0.0, -100.0 );
  
  // Cycle through primitives
  if( frameCount % 60 == 0) {
    drawType++;
    if( drawType >= 9 ) {
      drawType = 0;
    }
  }
}


