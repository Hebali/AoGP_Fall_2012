// Art of Graphics Programming
// Section Example 002: "Drawing Geometries: From Processing to OpenGL"
// Example Stage: E
// Course Materials by Patrick Hebron

import processing.opengl.*;

int     minSides, maxSides, numSides;
float   mRadius, theta;
boolean goingUp;

PFont   mFont;

void setup() {
  // Triangle fans are an excellent way to create circles, cylinder caps, cones, parasols, etc.
  // Unlike the n-sided polygon we looked at in the previous stage, the geometry we will create
  // below is not a single polygon, per se, but rather a strip of triangles organized around a
  // center point. For OpenGL to properly compute the brightness of a polygon, all of the polygon's
  // vertices must reside on the same plane. A triangle fan is composed of multiple polygons and
  // by definition, the three vertices of each triangle will always be coplanar. Therefore,
  // we can position a triangle fan's vertices in multiple planes without rendering errors. 
  // Below, we will use this feature to create a cone. As we build up our 3D platform, 
  // we should try to favor implementation methods that are generalized and versatile. Since triangle 
  // fans have limited geometric applications, we will ultimately focus on triangles and triangle strips.
  // The idea is to create a set of tools that will allow us to produce the broadest set of visual 
  // possibilities while still being fast, efficient and easy to use. But it's good to know what's out there.
  
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
  translate( width/2, height/2, -200.0 );
  rotateY(width - map(mouseX,0,width,0,PI*2.0));
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  strokeWeight(2);
  
  // Compute the angle between each point on the polygon
  float deltaTheta = TWO_PI/numSides;

  // Begin the triangle fan
  beginShape(TRIANGLE_FAN);
  // Add center point to triangle fan
  // We'll animate the z-position of the center point
  // to cycle between a circle and cone
  vertex( 0.0, 0.0, 5.0 * numSides );
  // Add circumference points to triangle fan
  for(int i = 0; i < numSides; i++) {
    // Compute the x and y position of each vertex
    float x = mRadius * cos( i * deltaTheta + theta );
    float y = mRadius * sin( i * deltaTheta + theta );
    vertex( x, y, 0.0 );
  }
  // To close the triangle fan, we need to return to the first circumference vertex
  // At that vertex, i = 0, so (i * deltaTheta + theta) reduces to (theta).
  vertex( mRadius * cos( theta ), mRadius * sin( theta ), 0.0 );
  // End triangle fan
  endShape();
  
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


