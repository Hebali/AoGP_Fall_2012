// Art of Graphics Programming
// Section Example 004: "Storing Geometries: A Generic Approach"
// Example Stage: C
// Course Materials by Patrick Hebron

import processing.opengl.*;

TMesh mesh;

void setup() {
  // In this stage, we introduce the TMeshFactory, which encapsulates various geometric primitive generators
  // into a simple API. Rather than the lengthy setup() in the previous two stages, we can reduce the instantiation
  // of each new geometry to something like meshFactory.createCylinder(...)
  // Also notice that we've added addCylinder, etc to NodeGeom so that child geometries can be easily added to any node.
  
  size( 800, 600, OPENGL );
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 20;
  int meshPointsV = 20;
  
  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory();
  
  // Create a new mesh object
  mesh = new TMesh();
  
  // Choose a radius for the cylinder profile
  float cylinderRadius = 50.0;
  // Choose a length for the cylinder
  float cylinderLength = 500.0;
  
  mesh = meshFactory.createCylinder( meshPointsU, meshPointsV, cylinderRadius, cylinderLength );
  
  // Center the mesh in window
  mesh.setPosition( new PVector( width/2.0, height/2.0, -100.0 ) );
  // Rotate mesh
  mesh.setRotation( new PVector( HALF_PI, QUARTER_PI, 0.0 ) );
}

void draw() {
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  // Draw the mesh
  mesh.draw();
}
