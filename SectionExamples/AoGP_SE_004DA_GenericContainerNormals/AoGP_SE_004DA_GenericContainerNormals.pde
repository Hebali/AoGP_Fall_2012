// Art of Graphics Programming
// Section Example 004: "Storing Geometries: A Generic Approach"
// Example Stage: D (Part A)
// Course Materials by Patrick Hebron

import processing.opengl.*;

TMesh mesh;

void setup() {
  // In this stage, we integrate surface and vertex normals into TMesh, TMeshFactory, Tri and Vert classes.
  // A vertex normal represents the "orientation" of a vertex and is necessary for proper lighting calculations. 
  // Since a single point in space, by definition, has no dimension, its orientation is a bit of an abstraction. 
  // We determine the vertex normal by aggregating the surface normals of the triangles of which the vertex is a component. 
  // In this example stage, however, it appears that some of the vertex normals are being calculated incorrectly
  // due to the way in which we've been initializing our mesh. We'll need to resolve this in the next stage.
  
  size( 800, 600, OPENGL );
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 10;
  int meshPointsV = 10;
  // Choose a size for the mesh
  float sideLength = 500.0;
  
  // Using noiseSeed so that we get the same terrain
  // every time we run the program (for comparison with 004DB)
  noiseSeed(25);
  
  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory();
  
  // Create a new mesh object
  mesh = new TMesh();
  // Create terrain
  mesh = meshFactory.createTerrain( meshPointsU, meshPointsV, sideLength, sideLength, 0.0, sideLength/3.0, 8, 0.8 );
  
  // Center the mesh in window
  mesh.setPosition( new PVector( width/2.0, height/2.0, -200.0 ) );
}

void draw() {
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  // Use lights to show the effect of normals
  // (We'll look at lights more closely in a later example)
  spotLight( 255, 255, 255, mouseX, 100.0, -200.0, 0.0, 1.0, 0.0, HALF_PI, 10.0 );
  directionalLight( 100, 100, 100, 0, 1, 0 );
  
  // Draw the mesh
  mesh.draw();
}
