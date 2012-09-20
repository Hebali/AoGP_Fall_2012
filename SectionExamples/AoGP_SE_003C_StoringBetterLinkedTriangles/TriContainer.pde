class TriContainer {
  ArrayList<Tri>      mTriangles;
  ArrayList<PVector>  mVertices;
  
  // This class stores a dynamically-sized list of triangles.
  // TriContainer allows us to access each triangle individually
  // as well as draw every triangle in the container with a single call to draw().
  // Eventually, we will attach an object like this to each NodeGeom
  // scenegraph node in a scene, thereby giving each TriangleContainer
  // the ability to receive a unique position, rotation and scale.
  // But first, we need to find the best possible generalized data structure.
  // We've now internalized the vertex list, allowing us to easily manipulate 
  // individual vertices or triangles. We've added a few methods to assist with this
  // as well as a createMesh() method, which wraps up some of the functionality
  // we developed in the previous example stage into a single easy-to-use method.
  
  TriContainer() {
    // Initialize the triangle list
    mTriangles = new ArrayList();
    // Initialize the vertex list
    mVertices  = new ArrayList();
  }
  
  void clear() {
    // Remove all triangles from the list
    mTriangles.clear();
    // Remove all vertices from the list
    mVertices.clear();
  }
  
  void createMesh(int iSubdivisionsX, int iSubdivisionsY, float iSubdivLengthX, float iSubdivLengthY) {
    // Notice we've added the ability to specifiy different subdivision lengths in each axis.
    
    // Center grid about its origin
    float startX = -(iSubdivisionsX * iSubdivLengthX) / 2.0; 
    float startY = -(iSubdivisionsY * iSubdivLengthY) / 2.0;
    
    // In each axis, there is one more vertex than subdivision
    // Iterate over each vertex and set its initial position
    for (int y = 0; y < iSubdivisionsY + 1; y++) {
      for(int x = 0; x < iSubdivisionsX + 1; x++) { 
        addVertex( new PVector( startX + x * iSubdivLengthX, startY + y * iSubdivLengthY, 0.0 ) );
      }
    }
    
    // Iterate over the rectangular subdivisions of the mesh
    for (int y = 0; y < iSubdivisionsY; y++) {
      for(int x = 0; x < iSubdivisionsX; x++) {  
        // We're now using a 1D vertex ArrayList, rather than a 2D array,
        // so we'll need to find the 1D index for the four corner vertices
        // of the current rectangular subdivision
        int iA = (y)     * (iSubdivisionsX + 1) + (x);
        int iB = (y)     * (iSubdivisionsX + 1) + (x + 1);
        int iC = (y + 1) * (iSubdivisionsX + 1) + (x + 1);
        int iD = (y + 1) * (iSubdivisionsX + 1) + (x);
        // Now get the four corner vertices
        PVector vertA = mVertices.get(iA); 
        PVector vertB = mVertices.get(iB);   
        PVector vertC = mVertices.get(iC);  
        PVector vertD = mVertices.get(iD); 
        // Create two triangles for each subdivision, triangles ABD and CBD, using the shared vertices.
        addTriangle( new Tri( vertA, vertB, vertD ) );
        addTriangle( new Tri( vertC, vertB, vertD ) );
      }
    } 
  }
  
  void addTriangle(Tri iTri) {
    // Add a triangle to container
    mTriangles.add( iTri );
  }
  
  void addVertex(PVector iVert) {
    // Add a vertex to container
    mVertices.add( iVert );
  }
  
  Tri getTriangle(int iIndex) {
    // Make sure that the input index is within the list bounds
    if( iIndex >= 0 && iIndex < getTriangleCount() ) {
      // Return the triangle at the given index
      return mTriangles.get( iIndex );
    }
    // Otherwise return null (no object)
    return null;
  }
  
  PVector getVertex(int iIndex) {
    // Make sure that the input index is within the list bounds
    if( iIndex >= 0 && iIndex < getVertexCount() ) {
      // Return the vertex at the given index
      return mVertices.get( iIndex );
    }
    // Otherwise return null (no object)
    return null;
  }
  
  int getTriangleCount() {
    // Return the number of triangles in the container
    return mTriangles.size();
  }
  
  int getVertexCount() {
    // Return the number of vertices in the container
    return mVertices.size();
  }
  
  void draw() {
    // Draw each triangle in the list
    int triCount = getTriangleCount();
    // Prepare to draw a series of triangles
    beginShape(TRIANGLES);
    for(int i = 0; i < triCount; i++) {
      // Draw the current triangle's vertices
      mTriangles.get(i).draw();
    }
    endShape();
  }
}
