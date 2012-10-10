// Class: TMesh
// Description: A container class for an individual 3D model.
// Purpose: Building on NodeBase and NodeGeom, TMesh stores data related
// to the representation of a geometric mesh. It uses the Tri and Vert classes
// and a cross-referencing initialization procedure to assist in the 
// straight-forward and generalized creation and manipulation of 3D models.
// All mesh generation helper functions are contained within TMeshFactory.

int POINT_MODE    = 0;
int TRIANGLE_MODE = 1;
int TRISTRIP_MODE = 2;

class TMesh extends NodeGeom {
  int                dimensionU, dimensionV;
 
  ArrayList<Vert>    mVertices;
  ArrayList<Tri>     mTriangles;
  ArrayList<Integer> mTriStrip;
  
  int                mDrawMode;
    
  TMesh() {
    // Initialize base class (NodeGeom)
    super();
    // Initialize arrays
    mVertices  = new ArrayList();
    mTriangles = new ArrayList();
    mTriStrip  = new ArrayList();
    // Draw triangle strips by default
    mDrawMode  = TRISTRIP_MODE;
  }
  
  void drawContents() {
    // DRAW TRIANGLE STRIPS
    if( mDrawMode == TRISTRIP_MODE ) {
      int tsCount = mTriStrip.size();
      beginShape(TRIANGLE_STRIP);
      for(int i = 0; i < tsCount; i++) {
        Vert cVert = mVertices.get( mTriStrip.get(i) );
        // Set the vertex position
        vertex( cVert.mPosition.x, cVert.mPosition.y, cVert.mPosition.z );
      }
      endShape();
    }
    // DRAW TRIANGLES
    else if( mDrawMode == TRIANGLE_MODE ) {
      int triCount = mTriangles.size();
      beginShape(TRIANGLES);
      for(int i = 0; i < triCount; i++) {
        Tri cTri = mTriangles.get(i);
        for(int j = 0; j < 3; j++) {
          Vert cVert = cTri.getVertex( j );
          // Set the vertex position
          vertex( cVert.mPosition.x, cVert.mPosition.y, cVert.mPosition.z );
        }
      }
      endShape();
    }
    // DRAW POINTS
    else if( mDrawMode == POINT_MODE ) {
      int tsCount = mTriStrip.size();
      beginShape(POINTS);
      for(int i = 0; i < tsCount; i++) {
        Vert cVert = mVertices.get( mTriStrip.get(i) );
        // Set the vertex position
        vertex( cVert.mPosition.x, cVert.mPosition.y, cVert.mPosition.z );
      }
      endShape();
    }
  }
  
  Vert getVertex(int iIndex) {
    // Make sure that the input index is within the arraylist bounds
    if( iIndex >= 0 && iIndex < mVertices.size() ) {
      // Return the vertex at the given index
      return mVertices.get( iIndex );
    }
    // Otherwise return null (no object)
    return null;
  }
  
  Tri getTriangle(int iIndex) {
    // Make sure that the input index is within the arraylist bounds
    if( iIndex >= 0 && iIndex < mVertices.size() ) {
      // Return the index at the given index
      return mTriangles.get( iIndex );
    }
    // Otherwise return null (no object)
    return null;
  }

  int getVertexCount() {
    return mVertices.size();
  }
  
  int getTriangleCount() {
    return mTriangles.size();
  }
  
  int getTriangleStripIndexCount() {
    return mTriStrip.size();
  }
  
  void setDrawMode(int iMode) {
    mDrawMode = iMode;
  }
  
  int getDrawMode() {
    return mDrawMode;
  }
}
