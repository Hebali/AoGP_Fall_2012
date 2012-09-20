// Art of Graphics Programming
// Section Example 002: "Drawing Geometries: From Processing to OpenGL"
// Example Stage: C
// Course Materials by Patrick Hebron

import processing.opengl.*;

int   drawType;
PFont mFont;

float sideLength;

void setup() {
  // Processing and OpenGL give us multiple ways of drawing a particular geometry. In this example,
  // we implement seven ways of drawing a square. Each method has its benefits and drawbacks.
  // Some of these methods are easy to conceptualize, while others are more efficient or generalizable. 
  // In general, triangles are the most "generalizable" geometry because any other polygon or mesh can be made 
  // from a set of them. Another benefit of using triangles is that its vertices, unlike those of a quad, 
  // are necessarily co-planar, which is important for correct lighting calculations. Also, QUADS are not 
  // supported in OpenGL ES, the version of OpenGL that runs on iOS and other mobile devices. Triangle strips 
  // and fans, which we'll look at more closely, are more efficient than basic triangles, but also come 
  // with certain conceptual difficulties and usage limitations.
  
  size( 500, 500, OPENGL );
  
  mFont = createFont( "Helvetica", 32 );
  textFont( mFont );
  textAlign( CENTER );  
  
  drawType   = 0;
  sideLength = 100.0;
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( width/2, height/2, 0.0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  // Translate the square to center
  pushMatrix();
  translate( -sideLength/2, -sideLength/2, 0.0 );
  // Cycle through various ways of drawing a square:
  if( drawType == 0 ) {
    // Using built-in rectangle
    rect( 0.0, 0.0, sideLength, sideLength );
  }
  else if( drawType == 1 ) {
    // Using built-in quadrilateral
    quad( 0.0, 0.0, sideLength, 0.0, sideLength, sideLength, 0.0, sideLength );
  }
  else if( drawType == 2 ) {
    // Using built-in triangle function, twice
    triangle( 0.0, 0.0, sideLength, 0.0, 0.0, sideLength );
    triangle( sideLength, sideLength, sideLength, 0.0, 0.0, sideLength );
  }
  else if( drawType == 3 ) {
    // Using a custom quad definition
    beginShape(QUADS);
    vertex( 0.0,        0.0,        0.0 );
    vertex( sideLength, 0.0,        0.0 );
    vertex( sideLength, sideLength, 0.0 );
    vertex( 0.0,        sideLength, 0.0 );
    endShape();
  }
  else if( drawType == 4 ) {
    // Using custom triangle definitions
    beginShape(TRIANGLES);
    // First triangle:
    vertex( 0.0,        0.0,        0.0 );
    vertex( sideLength, 0.0,        0.0 );
    vertex( 0.0,        sideLength, 0.0 );
    // Second triangle:
    vertex( sideLength, 0.0,        0.0 );
    vertex( sideLength, sideLength, 0.0 );
    vertex( 0.0,        sideLength, 0.0 );
    endShape();
  }
  else if( drawType == 5 ) {
    // Using a triangle strip
    beginShape(TRIANGLE_STRIP);
    // First triangle:
    vertex( 0.0,        sideLength, 0.0 );
    vertex( 0.0,        0.0,        0.0 );
    vertex( sideLength, sideLength, 0.0 );
    // Second triangle:
    vertex( sideLength, 0.0,        0.0 );
    // Triangle strips are more efficient than triangles for the following reason:
    // In quad ABCD, when you draw triangles ABD and BCD, line BD gets drawn twice.
    // With triangle strips, we define the vertices of triangle DAC.
    // We then add vertex B to define triangle ACB. 
    //
    // Each additional vertex adds the next triangle in the strip:
    // vertex( sideLength*2.0, sideLength, 0.0 );
    // vertex( sideLength*2.0, 0.0, 0.0 ); 
    //
    // Due to the way this strip configuration is stored within OpenGL, nothing is drawn twice, making it more efficient than triangles.
    // However, the downside to this approach is that it's not the most intuitive way of defining shapes.
    endShape();
  }
  else if( drawType == 6 ) {
    // Using a triangle fan
    beginShape(TRIANGLE_FAN);
    // Center point:
    vertex( sideLength/2.0, sideLength/2.0, 0.0 );
    // Each corner:
    vertex( 0.0,            0.0,        0.0 );
    vertex( sideLength,     0.0,        0.0 );
    vertex( sideLength,     sideLength, 0.0 );
    vertex( 0.0,            sideLength, 0.0 );
    // Return to the first corner:
    vertex( 0.0,            0.0,        0.0 );
    endShape();  
  }
  popMatrix();
  
  // Draw the appropriate text label
  String[] labels = {"rect()","quad()","triangle()","beginShape(QUADS)","beginShape(TRIANGLES)","beginShape(TRIANGLE_STRIP)","beginShape(TRIANGLE_FAN)"};                   
  text( labels[drawType], 0.0, -sideLength );
  
  // Cycle through geometries
  if( frameCount % 60 == 0) {
    drawType++;
    if( drawType >= 7 ) {
      drawType = 0;
    }
  }
}


