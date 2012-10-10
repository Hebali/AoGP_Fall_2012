// Art of Graphics Programming
// Section Example 004: "Storing Geometries: A Generic Approach"
// Example Stage: B
// Course Materials by Patrick Hebron

import processing.opengl.*;

TMesh mesh;

void setup() {
  // In this stage, we verify that the TMesh class provides a generalized structure that will be suitable for
  // the various primitives constructed in the previous section example. Here, we use TMesh to construct a
  // cylinder. In the next stage, we should begin to think about building a "mesh factory" that constructs 
  // various primitives with a single function call.
  
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
  
  // Choose a radius for the cylinder profile
  float cylinderRadius = 50.0;
  // Choose a length for the cylinder
  float cylinderLength = 500.0;
  
  // This time we'll iterate one-dimensionally, just for variation
  int vCount = mesh.getVertexCount();
  for(int i = 0; i < vCount; i++) {
    // Get the vertex from mesh
    Vert currVert  = mesh.getVertex( i );
    // Get its UVs (these will be mapped 0.0..1.0 in each axis)
    PVector currUV = currVert.getUV();
    // We find our position along the circumference of the current profile by
    // lerping the U coordinate (radial axis) in the range 0.0 .. 2PI
    float thetaU = TWO_PI * currUV.x;
    // Using thetaU, we find the coordinates of the current point in relation to the center of the current profile
    // and then multiply these coordinates by the profile radius to size it appropriately.
    // Here we are thinking of the current profile as a circle inscribed in a plane spanning the X and Y axes.
    float x = cylinderRadius * cos(thetaU);
    float y = cylinderRadius * sin(thetaU);
    // We find the z-value of the current vertex by computing the length of one cylinder segment
    // and then multiplying this by current index in the V axis (non-radial axis) of our mesh.
    // Also, subtract half the cylinder's length to center about the origin.
    float z = cylinderLength * currUV.y - cylinderLength/2.0;
    // Set the current vertex position
    currVert.setPosition( new PVector( x, y, z ) );
  }
  
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
