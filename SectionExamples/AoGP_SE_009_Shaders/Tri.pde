// Class: Tri
// Description: A container class for the components of an individual triangle.
// Purpose: In order to assist the creation and intuitive manipulation of geometries, it is
// helpful to cross-reference the components and sub-components of a geometry.
// A Tri object stores a reference to the three Verts that comprise the triangle.
// The Tri object also store the index numbers for the position of each Vert object within
// a TMesh's mVertices arraylist. These two modes of accessing the constituent vertices
// allow us to manipulate geometries more easily. To assist with vertex normal and related
// calculations, Tri also implements getSurfaceNormal() and getCentroid().

class Tri {
  Vert[]    mVertices;
  int[]     mVertexIndices;
  
  Tri(Vert iVA, Vert iVB, Vert iVC, int iA, int iB, int iC) {
    // Initialize index array
    mVertexIndices = new int[3];
    // Initialize vertex array
    mVertices      = new Vert[3];

    setVertices( iVA, iVB, iVC );
    setIndices( iA, iB, iC );
  }
  
  void setVertices(Vert iVA, Vert iVB, Vert iVC) {
    // Add triangle reference to each vertex
    iVA.addTriangleRef( this );
    iVB.addTriangleRef( this );
    iVC.addTriangleRef( this );
    // Set vertices
    mVertices[0] = iVA;
    mVertices[1] = iVB;
    mVertices[2] = iVC;
  }
  
  void setIndices(int iA, int iB, int iC) {
    // Set indices
    mVertexIndices[0] = iA;
    mVertexIndices[1] = iB;
    mVertexIndices[2] = iC;
  }
  
  PVector getCentroid() {
    // The centroid is the average position of the three vertices
    PVector centroid = new PVector( 0.0, 0.0, 0.0 );
    centroid.add( mVertices[0].getPosition() );
    centroid.add( mVertices[1].getPosition() );
    centroid.add( mVertices[2].getPosition() );
    centroid.div( 3 );
    return centroid;
  }
  
  Vert getVertex(int iVertexNumber) {
    // Make sure that the vertex number is in range
    // 0: Vertex A, 1: Vertex B, 2: Vertex C
    iVertexNumber = max( 0, iVertexNumber );
    iVertexNumber = min( 2, iVertexNumber );
    // Return the vertex associated with given vertex number
    return mVertices[iVertexNumber];
  }
  
  int getVertexIndex(int iVertexNumber) {
    // Make sure that the vertex number is in range
    // 0: Vertex A, 1: Vertex B, 2: Vertex C
    iVertexNumber = max( 0, iVertexNumber );
    iVertexNumber = min( 2, iVertexNumber );
    // Return the index associated with given vertex number
    return mVertexIndices[iVertexNumber];
  }
  
  PVector getSurfaceNormal() {
    // Compute the vectors for sides BA and CA
    PVector ba = PVector.sub( getVertex(1).getPosition(), getVertex(0).getPosition() );
    PVector ca = PVector.sub( getVertex(2).getPosition(), getVertex(0).getPosition() );
    // The cross product of BA and CA give us the surface normal
    PVector n  = ba.cross( ca );
    n.normalize();
    return n;
  }
}
