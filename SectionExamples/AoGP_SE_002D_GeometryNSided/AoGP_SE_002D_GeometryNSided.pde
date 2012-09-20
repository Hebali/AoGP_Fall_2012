// Art of Graphics Programming
// Section Example 002: "Drawing Geometries: From Processing to OpenGL"
// Example Stage: D
// Course Materials by Patrick Hebron

import processing.opengl.*;

int     minSides, maxSides, numSides;
float   mRadius, theta;
boolean goingUp;

PFont   mFont;

void setup() {
  // We're not limited to triangles, quadrilaterals or circles/ellipses, of course. We can draw everything in between as well.
  // In this example, we create an n-sided polygon where n cycles between 3 and 50. The fifty-sided figure is almost
  // indistinguishable from a "perfect circle," making this method a candidate for implementing circles, cylinder caps, etc.
  // This method could also be useful in drawing tessellations (see http://mathworld.wolfram.com/Tessellation.html).
  // However, the figures generated here could also be created with triangles, a triangle strip or a triangle fan.
  // In the next example stage, we'll look at a triangle fan approach to generating n-sided polygons.
  
  size( 500, 500, OPENGL );
  
  mFont = createFont( "Helvetica", 32 );
  textFont( mFont );
  textAlign( CENTER );  
  
  // Choose a radius for the circle in which the polygon is inscribed
  mRadius = 200.0;
  
  // Choose a starting point on the inscribing circle
  // http://en.wikipedia.org/wiki/File:Degree-Radian_Conversion.svg
  theta    = -HALF_PI;
  
  // Animation cycle settings
  minSides = 3;
  maxSides = 50;
  numSides = minSides;
  goingUp  = true;
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( width/2, height/2, 0.0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  strokeWeight(2);
  
  // Compute the angle between each point on the polygon
  float deltaTheta = TWO_PI/numSides;
  
  // Prepare to draw the polygon
  beginShape();
  for(int i = 0; i < numSides; i++) {
    // Compute the x and y position of each vertex
    float x = mRadius * cos( i * deltaTheta + theta );
    float y = mRadius * sin( i * deltaTheta + theta );
    vertex( x, y, 0.0 );
  }
  // Close the polygon (connect the last vertex with the first)
  endShape(CLOSE);
  
  // Draw the side count text label
  text( (numSides + " sides"), 0.0, -(mRadius + 10.0) );
  
  // Every 15th frame, change the polygon's side count
  if(frameCount % 15 == 0) {
    // When we reach the top or bottom side count, turn around
    if(numSides == minSides) {
      goingUp = true;
    }
    else if(numSides == maxSides) {
      goingUp = false;
    }
    // Update the side count
    if( goingUp ) {
      numSides++;
    }
    else {
      numSides--;
    }
  }
}


