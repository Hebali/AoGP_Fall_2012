// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: A
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriContainer  triContainer;

int           subdivisionsX, subdivisionsY;
float         subdivLength;
int           index;
boolean       goingUp;

void setup() {
  // One of the nice things about OpenGL triangles as opposed to triangle strips (which we'll look at in later examples)
  // is that triangles can be aligned with one another to appear as a coherent mesh or detatched from one another entirely.
  // We can, of course, also transition between these states, allowing for effects that imitate explosions, objects breaking, etc.
  // Partly because of this versatility, however, we have to be careful about how we store and access triangles and the vertices
  // that compose them. In this example, we'll begin to develop a class for the storage and management of multiple triangles.
  // We'll also look at some of the problems and limitations associated with this approach as we move towards integrating a generalized
  // geometric storage structure with the scenegraph nodes from earlier examples. 
  
  size( 500, 500, OPENGL );
  
  // Prepare geometric properties
  subdivisionsX = 10;
  subdivisionsY = 10;
  subdivLength  = 30.0;
  // Prepare animation properties
  index         = 0;
  goingUp       = true;
  
  // Initialize triangle container
  triContainer = new TriContainer();
  
  // Center grid about origin
  float startX = -(subdivisionsX * subdivLength) / 2.0; 
  float startY = -(subdivisionsY * subdivLength) / 2.0;
  
  // Iterate over the rectangular subdivisions of the mesh
  for (int y = 0; y < subdivisionsY; y++) {
    for(int x = 0; x < subdivisionsX; x++) {      
      // For each subdivision, find the four corner vertices
      PVector vertA = new PVector( startX + x * subdivLength,     startY + y * subdivLength,     0.0 );
      PVector vertB = new PVector( startX + (x+1) * subdivLength, startY + y * subdivLength,     0.0 );
      PVector vertC = new PVector( startX + (x+1) * subdivLength, startY + (y+1) * subdivLength, 0.0 );
      PVector vertD = new PVector( startX + x * subdivLength,     startY + (y+1) * subdivLength, 0.0 );
      
      // Create two triangles for each subdivision, triangles ABD and CBD.
      // Notice that these two triangles share vertices B and D.
      // We use PVector's get() method to clone vertices B and D, so that each triangle possesses its own unique copies.
      triContainer.addTriangle( new Tri( vertA, vertB.get(), vertD.get() ) );
      triContainer.addTriangle( new Tri( vertC, vertB.get(), vertD.get() ) );
      
      // Try rerunning the program with the following two lines instead of the preceeding lines:
      //triContainer.addTriangle( new Tri( vertA, vertB, vertD ) );
      //triContainer.addTriangle( new Tri( vertC, vertB, vertD ) );
      // Triangles ABD and CBD are now sharing vertices B and D, preventing us from moving
      // each triangle individually.
      
      // In some cases, shared vertices may be useful. For instance, in a mesh surface,
      // when we move a vertex, we want all of the attached triangles to move with it.
      // In the above method, however, only some of the vertices are shared.
      // The problem is in how we're iterating over the rectangular subdivisions.
      // In the following diagram:
      // A---B---E---F
      // |   |   |   |
      // C---D---G---H
      // We will touch subdivision ABCD, then BEDG, then EFGH, etc.
      // Notice that vertex B and D are in both of the first two subdivisions.
      // However, in the above method, even if we share vertices between the two
      // triangles of each subdivision, we are not sharing them between subdivisions.
      // In the next example stage, we'll look at a method for sharing vertices between subdivisions.
    }
  }
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( width/2.0, height/2.0, 0.0 );
  rotateY( radians( mouseX - width/2.0 ) / 2.0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  strokeWeight(1);

  // Draw triangles
  triContainer.draw();
  
  // Get the triangle at current index
  Tri currTri = triContainer.getTriangle( index );
  // Make sure the returned triangle is valid
  if( currTri != null ) {
    // Cycle through the vertices of each triangle and update their z positions.
    for(int i = 0; i < 3; i++) {
      if( goingUp )
        currTri.mVerts[i].z -= subdivLength;
      else 
        currTri.mVerts[i].z += subdivLength;
    }
  }
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    if( index + 1 < subdivisionsX * subdivisionsY * 2 ) {
      // Increment triangle index
      index++;
    }
    else {
      // Reset triangle index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
}


