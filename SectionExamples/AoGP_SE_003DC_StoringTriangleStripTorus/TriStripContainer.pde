class TriStripContainer {
  ArrayList<PVector>  mVertices;
  
  TriStripContainer() {
    // Initialize the vertex list
    mVertices = new ArrayList();
  }
  
  void clear() {
    // Remove all vertices from the container
    mVertices.clear();
  }
  
  void addVertex(PVector iVert) {
    // Add a vertex to container
    mVertices.add( iVert );
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
  
  int getVertexCount() {
    // Return the number of vertices in the container
    return mVertices.size();
  }
  
  void draw() {
    // Get vertex count
    int vertCount = getVertexCount();
   
    // Set point size
    strokeWeight(5);
    // Draw vertices
    beginShape(POINTS);
    for(int i = 0; i < vertCount; i++) {
      PVector currVert = mVertices.get(i);
      vertex( currVert.x, currVert.y, currVert.z );
    }
    endShape();
    
    // Set line width
    strokeWeight(1);
    // Draw the triangle strip
    beginShape(TRIANGLE_STRIP);
    for(int i = 0; i < vertCount; i++) {
      PVector currVert = mVertices.get(i);
      vertex( currVert.x, currVert.y, currVert.z );
    }
    endShape();
  }
}
