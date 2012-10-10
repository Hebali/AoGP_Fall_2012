// Class: Tri
// Description: A container class for the components of an individual triangle.
// Purpose: In order to assist the creation and intuitive manipulation of geometries, it is
// helpful to cross-reference the components and sub-components of a geometry.
// A Tri object stores a reference to the three Verts that comprise the triangle.
// The Tri object also store the index numbers for the position of each Vert object within
// a TMesh's mVertices arraylist. These two modes of accessing the constituent vertices
// allow us to manipulate geometries more easily. As we add additional functionality to the 
// TMesh class, we will add new features to the Tri class as well.

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
}
