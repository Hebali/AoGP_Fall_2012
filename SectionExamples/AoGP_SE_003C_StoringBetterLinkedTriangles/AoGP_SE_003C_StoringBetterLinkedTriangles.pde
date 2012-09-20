// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: C
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriContainer  triContainer;

int           subdivisionsX, subdivisionsY;
float         subdivLength;
int           index;
boolean       goingUp;

void setup() {
  // Rather than storing an external vertex list to assist in this process, as with the last example stage, 
  // we have now moved this list as well as a createMesh() and a few other helper methods directly into the 
  // TriContainer class. We're slowly making our geometric container more versatile and easy-to-use.
  
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
  // Create mesh, a one-step process now that we've created an internal method within TriContainer
  triContainer.createMesh( subdivisionsX, subdivisionsY, subdivLength, subdivLength );
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

  // We've now integrated vertex handling into the TriContainer class. 
  // We now have the ability to interact with the mesh as a series of 
  // triangles or vertices, which greatly expands our creative options.
  
  // Get the vertex at the current index
  PVector currVert = triContainer.getVertex( index );
  // Update the z position of the current vertex
  if( goingUp )
    currVert.z -= subdivLength;
  else 
    currVert.z += subdivLength;
  
  // Update animation cycle
  if( frameCount % 5 == 0 ) {
    // We are now using the "index" variable to iterate over each vertex
    // rather than each triangle
    if( index + 1 < ( (subdivisionsX + 1) * (subdivisionsY + 1) ) ) {
      // Increment vertex index
      index++;
    }
    else {
      // Reset vertex index
      index   = 0;
      // Reverse direction
      goingUp = !goingUp;
    }
  }
}


