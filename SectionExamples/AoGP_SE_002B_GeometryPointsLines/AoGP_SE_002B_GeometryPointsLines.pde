// Art of Graphics Programming
// Section Example 002: "Drawing Geometries: From Processing to OpenGL"
// Example Stage: B
// Course Materials by Patrick Hebron

import processing.opengl.*;

// Animation properties
int minPoints = 3;
int maxPoints = 100;
int numPoints = maxPoints;
boolean goingUp = false;
float step, staticStep;

// Drawing scale
float scalar = 120.0;


void setup() {
  // In later examples, we will focus primarily on polygons and polygon meshes.
  // But first, let's look more closely at the simplest forms of drawing 
  // in Processing: points and lines. 
  
  // In this example, we use several methods of generating points and lines
  // to visualize a sine wave and the calculus concept of integrals. 
  // Though the wave is created from a series of straight line segments,
  // when these segments are made sufficiently granular, the curve appears
  // to be smooth and continuous. This subject of geometric "resolution" will
  // recur in later examples as both a technical and aesthetic concern.
  
  // Setup window
  size(800, 600, OPENGL);
  
  // Compute the sine-step between each point
  step = TWO_PI / (float)numPoints;
  staticStep = step;
}

void draw() {
  // Clear the window and set background color
  background( 0 );

  // Translate to the center of the screen and scale drawing
  pushMatrix();
  translate( width/2.0, height/2.0, 0.0 );
  scale( scalar, scalar, scalar );
  
  // Set line width
  strokeWeight( 1 );
  // Set line color
  stroke( 255 );
  
  // METHOD 0:
  // Processing provides a simple built-in function for drawing a line segment:
  // line( float Ax, float Ay, float Az, float Bx, float By, float Bz );
  line( -PI, 0.0, PI, 0.0 );
  line( 0.0, -PI, 0.0, PI );
  
  // Set line color
  stroke( 255, 0, 0 );
  
  // METHOD 1:
  // This approach allows us to specify line segments as pairs of points.
  // beginShape(LINES);
  // vertex( float Ax, float Ay, float Az );
  // vertex( float Bx, float By, float Bz );
  // endShape();
  // DRAW HIGH-RES APPROXIMATION OF SINE WAVE:
  beginShape(LINES);
  for(float i = -PI; i <= PI - staticStep; i += staticStep) {
    // Draw each vertex-pair
    vertex( i, sin(i), 0.0 );
    vertex( i+staticStep, sin(i+staticStep), 0.0 );
  }
  endShape();
  
  // Set line color
  stroke( 0, 255, 0 );
  
  // METHOD 1: (again)
  // The vertex-pair format provides a straight-forward way to
  // draw a single line segment or a group of related ones.
  // DRAW INTEGRAL BOUNDING LINES:
  beginShape(LINES);
  for(float i = -PI; i <= PI; i += step) {
    // Calculate the current integral's x-axis range, 
    // clamping to the edges of the sine phase
    float sx = max(i - step/2.0, -PI);
    float ex = min(i + step/2.0,  PI);

    // Draw the integral's horizontal line
    vertex( sx, sin(i), 0.0 );
    vertex( ex, sin(i), 0.0 );
    
    // Draw the integral's vertical lines
    vertex( sx, sin(i), 0.0 );
    vertex( sx, 0.0, 0.0 );
    //
    vertex( ex, sin(i), 0.0 );
    vertex( ex, 0.0, 0.0 );
  }
  endShape();
  
  // If noFill() is not called, METHOD 2 will draw filled polygons in addition to lines
  noFill();

  // METHOD 2:
  // Though METHOD 1 was ideal for the above,
  // it may be cumbersome in some cases to think in terms of vertex-pairs.
  // beginShape();
  // vertex( float Px, float Py, float Pz );
  // vertex( ... );
  // endShape();
  // With this approach, we call vertices individually.
  // A series of line segments will be drawn, which connect vertices enumerated between beginShape() and endShape()
  // DRAW INTEGRAL APPROXIMATION OF SINE WAVE:
  stroke( 0, 0, 255 );
  beginShape();
  for(float i = -PI; i <= PI; i += step) {
    // Draw each vertex
    vertex( i, sin(i), 0.0 );
  }
  // Depending on the step size, rounding error may prevent us from 
  // reaching the precise end of phase (PI). 
  // So, just in case, we'll draw this last vertex, even if it is redundant for certain step values
  vertex( PI, sin(PI), 0.0 );
  endShape();
  
  // Set points size
  strokeWeight(5);
  
  // Draw points
  stroke( 255, 0, 0 );
  beginShape(POINTS);
  for(float i = -PI; i <= PI; i += step) {
    // Draw each vertex
    vertex( i, sin(i), 0.0 );
  }
  // Depending on the step size, rounding error may prevent us from 
  // reaching the precise end of phase (PI). 
  // So, just in case, we'll draw this last vertex, even if it is redundant for certain step values
  vertex( PI, sin(PI), 0.0 );
  endShape();

  popMatrix();

  // Update animation:
  if(frameCount % 10 == 0) {
    // When we reach the minimum or maximum number of points, turn around
    if( numPoints == minPoints ) {
      goingUp = true;
    }
    else if( numPoints == maxPoints ) {
      goingUp = false;
    }
    // Update the point count
    if( goingUp ) {
      numPoints++;
    }
    else {
      numPoints--;
    }
    // Re-compute the sine-step between each point
    step = TWO_PI / (float)numPoints;
  }
}

