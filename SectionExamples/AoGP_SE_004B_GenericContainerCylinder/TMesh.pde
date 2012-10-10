// Class: TMesh
// Description: A container class for an individual 3D model.
// Purpose: Building on NodeBase and NodeGeom, TMesh stores data related
// to the representation of a geometric mesh. It uses the Tri and Vert classes
// and a cross-referencing initialization procedure to assist in the 
// straight-forward and generalized creation and manipulation of 3D models.

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
  
  void initMesh(int iDimensionU, int iDimensionV) {
    // Initialize the mesh for the given UV dimensions
    // Notice that we do not set vertex positions within this method.
    // We setup our UV coordinates and create the connections necessary
    // to access data in vertex, triangle or triangle strip format.
    
    // Mesh must have at least 2 points per axis
    iDimensionU = max(iDimensionU,2);
    iDimensionV = max(iDimensionV,2);
    // Set mesh dimensions
    dimensionU = iDimensionU;
    dimensionV = iDimensionV;
    
    // Initialize vertices and setup the mesh UV coordinates
    for(int v = 0; v < iDimensionV; v++) {
      for(int u = 0; u < iDimensionU; u++) {
        Vert cVert = new Vert();
        cVert.setUV( (float)u/(iDimensionU - 1), (float)v/(iDimensionV - 1) );  
        mVertices.add( cVert );
      }
    }
    
    // Setup subdivisions (triangles and triangle strip)
    for(int v = 0; v < iDimensionV - 1; v++) {
      // Determine the direction of the current row
      boolean goingRight = (v % 2 == 0);
      
      // Find the indices for the first and last column of the row
      int firstCol = 0;
      int lastCol  = iDimensionU - 1;
      
      // Get the current column index, direction dependent
      int u = ( goingRight ) ? ( firstCol ) : ( lastCol );
      
      // Iterate over each column in the row
      boolean rowComplete = false;
      while( !rowComplete ) {
        // For each column, determine the indices of the current rectangular subdivision
        // This depends on whether we're going right or left in the current row
        int iA, iB, iC, iD;
        if( goingRight ) {
          // Rightward triangles abc, bcd:
          // a   c
          // 
          // b   d
        
          // Get the four indices of the current subdivision
          iA = (v) * (iDimensionU) + (u);
          iB = (v + 1) * (iDimensionU) + (u);
          iC = (v) * (iDimensionU) + (u + 1);
          iD = (v + 1) * (iDimensionU) + (u + 1);
          
          // Add the two triangles of the current subdivision
          Tri iABC = new Tri( mVertices.get( iA ), mVertices.get( iB ), mVertices.get( iC ), iA, iB, iC );
          mTriangles.add( iABC );
          Tri iBCD = new Tri( mVertices.get( iB ), mVertices.get( iC ), mVertices.get( iD ), iB, iC, iD );
          mTriangles.add( iBCD );
        }
        else {
          // Leftward triangles abc, bcd
          // c   a
          // 
          // d   b
          
          // Get the four indices of the current subdivision
          iA = (v) * (iDimensionU) + (u);
          iB = (v + 1) * (iDimensionU) + (u);
          iC = (v) * (iDimensionU) + (u - 1);
          iD = (v + 1) * (iDimensionU) + (u - 1);
          
          // Add the two triangles of the current subdivision
          Tri iABC = new Tri( mVertices.get( iA ), mVertices.get( iB ), mVertices.get( iC ), iA, iB, iC );
          mTriangles.add( iABC );
          Tri iBCD = new Tri( mVertices.get( iB ), mVertices.get( iC ), mVertices.get( iD ), iB, iC, iD );
          mTriangles.add( iBCD );          
        }
        
        // Add the four indices of current subdivision to triangle strip
        mTriStrip.add( iA );
        mTriStrip.add( iB );
        mTriStrip.add( iC );
        mTriStrip.add( iD );
        
        // Iterate through each column in the row, direction dependent 
        if( goingRight ) {
          u++;
        }
        else {
          u--;
        }
        
        // Check whether we've reached the end of the row
        if( ( goingRight && u == lastCol ) || ( !goingRight && u == firstCol ) ) {
          // At the end of the row, add last index of current subdivision
          // two more times to create "degenerate triangles"
          mTriStrip.add( iD );
          mTriStrip.add( iD );
          // Prepare to exit row
          rowComplete = true;
        }
      }
    }
  }
}
