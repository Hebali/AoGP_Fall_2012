// Class: TMesh
// Description: A container class for an individual 3D model.
// Purpose: Building on NodeBase and NodeGeom, TMesh stores data related
// to the representation of a geometric mesh. It uses the Tri and Vert classes
// and a cross-referencing initialization procedure to assist in the 
// straight-forward and generalized creation and manipulation of 3D models.
// All mesh generation helper functions are contained within TMeshFactory.
// To visualize the normals for the various TMesh primitives we've
// added some debug drawing methods. We've also added the methods to assist 
// in attaching a texture to the mesh.

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
  boolean            mUseTexture;
    
  // In addition to the above representation,
  // We will now also store a GLModel (aka, a Vertex Buffer Object),
  // which allows us to keep our geometric data in GPU memory.
  // In Processing, we'll also need to store the texture in a slightly 
  // different way in order to make use of GLGraphics optimizations.
  GLModel            mModel;
  GLTexture          mTextureGl;
    
  TMesh(Globals iGlobals) {
    // Initialize base class (NodeGeom)
    super( iGlobals );
    // Initialize default bounds
    mBoundsL   = new PVector( 0.0, 0.0, 0.0 );
    mBoundsH   = new PVector( 0.0, 0.0, 0.0 );
    // Initialize arrays
    mVertices  = new ArrayList();
    mTriangles = new ArrayList();
    mTriStrip  = new ArrayList();
    // Draw triangle strips by default
    mDrawMode  = TRISTRIP_MODE;
    // Do not use textures by default
    mUseTexture = false;
    mTextureGl  = new GLTexture( mGlobals.mApplet );
  }
  
  void drawContents() {
    // Draw model
    GL gl = mGlobals.mGl;
    gl.glColor3f( 1.0, 1.0, 1.0 );
    // We've already preloaded the model into GPU memory,
    // so we don't need to recapulate its triangle or triangle-strip
    // mesh configuration here. Instead, we just call render() on the GLModel
    // object and everything else is handled on the GPU.
    mModel.render();
    // Draw debug view:
    // We probably don't want to draw this all the time.
    // We'll deal with that in the next example stage.
    drawDebug();
  }
  
  void drawDebug() {
    // Within the GLGraphics renderer, we cannot use some of the Processing-specific
    // draw functions we've used in previous examples. Instead, we must implement similar
    // functionality using raw OpenGL calls.
    
    // Get a pointer to the OpenGL renderer
    GL gl = mGlobals.mGl;
    
    // Get vertex count
    int vCount = mVertices.size();
    // Draw each vertex
    gl.glPointSize(5);
    gl.glColor3f( 0.0, 1.0, 0.0 );
    gl.glBegin(gl.GL_POINTS);
    for(int i = 0; i < vCount; i++) {
      PVector cPos = mVertices.get( i ).getPosition();
      gl.glVertex3f( cPos.x, cPos.y, cPos.z );
    }
    gl.glEnd();
    // Draw each normal
    float tNormLen = 10.0;
    gl.glLineWidth(2);
    gl.glColor3f( 0.0, 0.0, 1.0 );
    gl.glBegin(gl.GL_LINES);
    for(int i = 0; i < vCount; i++) {
      Vert cv = mVertices.get(i);
      PVector cPos = mVertices.get( i ).getPosition();
      PVector cNor = mVertices.get( i ).getNormal();
      gl.glVertex3f( cPos.x, cPos.y, cPos.z );
      gl.glVertex3f( cPos.x + cNor.x * tNormLen, cPos.y + cNor.y * tNormLen, cPos.z + cNor.z * tNormLen );
    }
    gl.glEnd();
    
    // Draw origin tri-axis
    gl.glLineWidth(3);
    gl.glBegin(gl.GL_LINES);
    gl.glColor3f( 1.0, 0.0, 0.0 );
    gl.glVertex3f( 0.0, 0.0, 0.0 );
    gl.glVertex3f( 50.0, 0.0, 0.0 );
    gl.glColor3f( 0.0, 1.0, 0.0 );
    gl.glVertex3f( 0.0, 0.0, 0.0 );
    gl.glVertex3f( 0.0, 50.0, 0.0 );
    gl.glColor3f( 0.0, 0.0, 1.0 );
    gl.glVertex3f( 0.0, 0.0, 0.0 );
    gl.glVertex3f( 0.0, 00.0, 50.0 );
    gl.glEnd();
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
  
  void useTexture(boolean iUseTexture) {
    mUseTexture = iUseTexture;
  }
  
  void setTexture(String iFilePath) {
    setTexture( loadImage( iFilePath ) );
  }
  
  void setTexture(PImage iTexture) {
    mTextureGl.putImage( iTexture ); 
    useTexture(true);
  }
}
