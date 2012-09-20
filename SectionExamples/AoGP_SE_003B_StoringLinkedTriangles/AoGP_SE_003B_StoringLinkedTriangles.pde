// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: B
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriContainer  triContainer;
PVector[][]   verts;

int           subdivisionsX, subdivisionsY;
float         subdivLength;
int           index;
boolean       goingUp;

void setup() {
  // In order to share vertices between rectangular subdivisions, as discussed in the previous example stage, 
  // we'll break the problem up into two parts. First, we'll create each vertex, determine its proper position
  // and store it in a vertex array. Then, we'll iterate over each rectangular subdivision and pass references
  // for the appropriate vertices into each component triangle and then add the triangles to the container.
  // This will allow us to treat the TriContainer as a coherent mesh. 
  
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
  
  // Initialize the vertex array. In each axis, there is one more vertex than subdivision, 
  // so we need to make room for (subdivisions + 1) vertices in each axis.
  verts = new PVector[subdivisionsX + 1][subdivisionsY + 1];
  
  // Center grid about origin
  float startX = -(subdivisionsX * subdivLength) / 2.0; 
  float startY = -(subdivisionsY * subdivLength) / 2.0;
  
  // Iterate over each vertex and set its position
  for (int y = 0; y < subdivisionsY + 1; y++) {
    for(int x = 0; x < subdivisionsX + 1; x++) { 
      verts[x][y] = new PVector( startX + x * subdivLength, startY + y * subdivLength, 0.0 );
    }
  }
  
  // Iterate over the rectangular subdivisions of the mesh
  for (int y = 0; y < subdivisionsY; y++) {
    for(int x = 0; x < subdivisionsX; x++) {  
      // For each subdivision, find the four corner vertices
      PVector vertA = verts[x][y]; 
      PVector vertB = verts[x+1][y];  
      PVector vertC = verts[x+1][y+1];  
      PVector vertD = verts[x][y+1];
      // Create two triangles for each subdivision, triangles ABD and CBD, using the shared vertices.
      triContainer.addTriangle( new Tri( vertA, vertB, vertD ) );
      triContainer.addTriangle( new Tri( vertC, vertB, vertD ) );
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
  
  // The vertices are now properly shared, so the object behaves like a coherent mesh.
  // However, our earlier method of moving triangles will not work in the way we hope.
  // Vertices on the corners and edges of the mesh are shared by fewer triangles than
  // vertices that are not on a mesh edge. Therefore, when we move each triangle as we
  // did in the previous example stage, some vertices will be moved more than others.
  // Uncomment the code below to see the effect:
  /*
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
  */
  
  // We need to manipulate vertices directly rather than triangles.
  // Since we've stored a persistent array of vertices as a global variable
  // in our program, we can get or set the position of any vertex at any time.
  // This is a step in the right direction. But it would be nice if that vertex
  // array were stored within the TriContainer as the current arrangement
  // could quickly become confusing with multiple meshes in a scene.
  // In the next example stage, we'll integrate the vertex array into TriContainer
  // and add some other methods to make the process below a bit simpler.
  
  // Get the 2D x and y index coordinates for the current 1D vertex index
  int vX = index % (subdivisionsX + 1);
  int vY = index / (subdivisionsX + 1);
  // Update the z position of the current vertex
  if( goingUp )
    verts[vX][vY].z -= subdivLength;
  else 
    verts[vX][vY].z += subdivLength;
  
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


