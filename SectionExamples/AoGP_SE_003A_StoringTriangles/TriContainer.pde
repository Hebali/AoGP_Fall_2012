class TriContainer {
  ArrayList<Tri>  mTriangles;
  
  // This class stores a dynamically-sized list of triangles.
  // TriContainer allows us to access each triangle individually
  // as well as draw every triangle in the container with a single call to draw().
  // Eventually, we will attach an object like this to each NodeGeom
  // scenegraph node in a scene, thereby giving each TriangleContainer
  // the ability to receive a unique position, rotation and scale.
  // But first, we need to find the best possible generalized data structure.
  
  TriContainer() {
    // Initialize the triangle list
    mTriangles = new ArrayList();
  }
  
  void clear() {
    // Remove all triangles from the list
    mTriangles.clear();
  }
  
  void addTriangle(Tri iTri) {
    // Add a triangle to the list
    mTriangles.add( iTri );
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
  
  int getTriangleCount() {
    // Return the number of triangles in the list
    return mTriangles.size();
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
