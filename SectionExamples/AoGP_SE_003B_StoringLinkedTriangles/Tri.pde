class Tri {
  PVector[]  mVerts;
  
  // This class is built to store the three vertices of a triangle
  // and also provides a method of drawing these vertices as triangles
  // from within the TriContainer class.

  Tri(PVector vertexA, PVector vertexB, PVector vertexC) {
    // Create an array to store the three vertices of a triangle
    mVerts    = new PVector[3];
    // Store each vertex of the triangle within this array
    mVerts[0] = vertexA;
    mVerts[1] = vertexB;
    mVerts[2] = vertexC;
  }
  
  void draw() {
    // Draw each vertex of the current triangle    
    for(int i = 0; i < 3; i++) {
      vertex( mVerts[i].x, mVerts[i].y, mVerts[i].z );
    }
  }
}
