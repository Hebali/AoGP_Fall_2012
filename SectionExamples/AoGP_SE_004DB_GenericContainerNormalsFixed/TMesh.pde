// Class: TMesh
// Description: A container class for an individual 3D model.
// Purpose: Building on NodeBase and NodeGeom, TMesh stores data related
// to the representation of a geometric mesh. It uses the Tri and Vert classes
// and a cross-referencing initialization procedure to assist in the 
// straight-forward and generalized creation and manipulation of 3D models.
// All mesh generation helper functions are contained within TMeshFactory.
// To visualize the normals for the various TMesh primitives we've
// added some debug drawing methods.

int POINT_MODE    = 0;
int TRIANGLE_MODE = 1;
int TRISTRIP_MODE = 2;

class TMesh extends NodeGeom {
  int                dimensionU, dimensionV;
  PVector            mBoundsL, mBoundsH;
 
  ArrayList<Vert>    mVertices;
  ArrayList<Tri>     mTriangles;
  ArrayList<Integer> mTriStrip;
  
  int                mDrawMode;
    
  TMesh() {
    // Initialize base class (NodeGeom)
    super();
    // Initialize default bounds
    mBoundsL   = new PVector( 0.0, 0.0, 0.0 );
    mBoundsH   = new PVector( 0.0, 0.0, 0.0 );
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
        // Set the vertex normal
        normal( cVert.mNormal.x, cVert.mNormal.y, cVert.mNormal.z );
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
          // Set the vertex normal
          normal( cVert.mNormal.x, cVert.mNormal.y, cVert.mNormal.z );
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
    
    // DRAW NORMALS (for debug purposes)
    stroke( 0, 0, 255 );
    float tNormLen = 20.0;
    int vCount = mVertices.size();
    beginShape(LINES);
    for(int i = 0; i < vCount; i++) {
      Vert cv = mVertices.get(i);
      vertex( cv.mPosition.x, cv.mPosition.y, cv.mPosition.z );
      vertex( cv.mPosition.x + cv.mNormal.x  * tNormLen, cv.mPosition.y + cv.mNormal.y * tNormLen, cv.mPosition.z + cv.mNormal.z  * tNormLen );
    }
    endShape();
    stroke( 255, 0, 0 );
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
  
  PVector getBoundsLow() {
    return mBoundsL;
  }
  
  PVector getBoundsHigh() {
    return mBoundsH;
  }
  
  PVector getCentroid() {
    PVector tCentroid = PVector.sub( mBoundsH, mBoundsL );
    tCentroid.div( 2.0 );
    return tCentroid;
  }
  
  void computeBounds() {
    float maxv  = 999999999.9;
    mBoundsL.set( maxv, maxv, maxv );
    mBoundsH.set( -maxv, -maxv, -maxv );
    int vCount = mVertices.size();
    for(int i = 0; i < vCount; i++) {
      PVector cV = mVertices.get(i).getPosition();
      mBoundsL.x = min( mBoundsL.x, cV.x );
      mBoundsL.y = min( mBoundsL.y, cV.y );
      mBoundsL.z = min( mBoundsL.z, cV.z );
      mBoundsH.x = max( mBoundsH.x, cV.x );
      mBoundsH.y = max( mBoundsH.y, cV.y );
      mBoundsH.z = max( mBoundsH.z, cV.z );
    }
  }
}
