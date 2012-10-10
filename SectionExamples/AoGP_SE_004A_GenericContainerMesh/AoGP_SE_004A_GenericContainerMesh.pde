// Art of Graphics Programming
// Section Example 004: "Storing Geometries: A Generic Approach"
// Example Stage: A
// Course Materials by Patrick Hebron

import processing.opengl.*;

TMesh mesh;

void setup() {
  // In this first stage, we create basic storage structures for
  // an individual vertex, a triangle and a 3D geometry container
  // that contains a set of vertices and triangles (as well as a
  // triangle strip representation of them). The TMesh, Tri and Vert
  // classes generalize and encapsulate many of the comment elements
  // we saw in each stage of the SE_003 examples. In this stage,
  // TMesh will only be able to store a flat 2D mesh, but will be developed
  // in a way that allows us to easily extend to other geometries
  // in later stages.
  
  size( 800, 600, OPENGL );
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 20;
  int meshPointsV = 20;
  
  // Create a new mesh object
  mesh = new TMesh();
  // Initialize the mesh's UV coordinates
  // as well as its triangle and triangle strip
  // vertex connections.
  // This method sets vertex XYZ positions to 
  // the default origin.
  mesh.initMesh( meshPointsU, meshPointsV );
  
  // Choose a side length for a square mesh
  float sideLength = 500.0;
  
  // Set vertex positions for mesh
  for(int v = 0; v < meshPointsV; v++) {
    for(int u = 0; u < meshPointsU; u++) {
      // Get 1D index for current vertex
      int i = v * meshPointsU + u;
      // Get the vertex from mesh
      Vert currVert  = mesh.getVertex( i );
      // Get its UVs (these will be mapped 0.0..1.0 in each axis)
      PVector currUV = currVert.getUV();
      // Multiply by the square's side length
      PVector cPos = new PVector( currUV.x  * sideLength, currUV.y * sideLength, 0.0 );
      currVert.setPosition( cPos );
    }
  }
  
  // Center the mesh in window
  mesh.setPosition( new PVector( width/2.0 - sideLength/2.0, height/2.0 - sideLength/2.0, 0.0 ) );
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
