// Class: TMesh
// Description: A container class for an individual 3D model.
// Purpose: Building on NodeBase and NodeGeom, TMesh stores data related
// to the representation of a geometric mesh. It uses the Tri and Vert classes
// and a cross-referencing initialization procedure to assist in the 
// straight-forward and generalized creation and manipulation of 3D models.
// All mesh generation helper functions are contained within TMeshFactory.
// To visualize the normals for the various TMesh primitives we've
// added some debug drawing methods. We've also added the methods to assist 
// in attaching a texture or shader to the mesh.

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
  boolean            mUseVertAnim, mUseNormAnim, mUseUvAnim;
  
  // We now add shader support to our TMesh class
  ShaderWrapper      mActiveShader;
  
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
    // Do not animate mesh components by default
    mUseVertAnim       = false;
    mUseNormAnim       = false;
    mUseUvAnim         = false;
    // Do not use shaders by default
    mActiveShader      = null;
  }
  
  void drawContents() {
    // Draw model
    GL gl = mGlobals.mGl;

    // We've already preloaded the model into GPU memory,
    // so we don't need to recapulate its triangle or triangle-strip
    // mesh configuration here. Instead, we just call render() on the GLModel
    // object and everything else is handled on the GPU.
    // However, we may have vertex animation applied to the mesh.
    // So before rendering, we need to update the vertex buffer object
    
    int vertCount = getVertexCount();
    
    if( mUseVertAnim ) {
      // Update vertices 
      mModel.beginUpdateVertices();
      for(int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updatePosition();
        PVector cPos = mVertices.get( i ).getPosition();
        mModel.updateVertex( i, cPos.x, cPos.y, cPos.z );
      }
      mModel.endUpdateVertices();
    }
    
    if( mUseNormAnim ) {
      // Update normals
      mModel.beginUpdateNormals();
      for(int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updateNormal();
        PVector cNor = mVertices.get( i ).getNormal();
        mModel.updateNormal( i, cNor.x, cNor.y, cNor.z );
      }
      mModel.endUpdateNormals();
    }
    
    if( mUseUvAnim ) {
      // Update tex coords
      mModel.beginUpdateTexCoords(0);
      for(int i = 0; i < vertCount; i++) {
        mVertices.get( i ).updateUV();
        PVector cUV = mVertices.get( i ).getUV();
        mModel.updateTexCoord( i, cUV.x, cUV.y );
      }
      mModel.endUpdateTexCoords();
    }
    
    // If a shader is active, we need to bind it before rendering the model.
    
    // Draw model
    gl.glColor3f( 1.0, 1.0, 1.0 );
    if( mActiveShader != null ) {
      mActiveShader.mShader.start();
      mActiveShader.setAllUniforms();
      mModel.render();
      mActiveShader.mShader.stop();
    }
    else {
      mModel.render();
    }
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
  
  void setActiveShader(String iShaderName) {
    mActiveShader = mGlobals.mShaderManager.getShaderWrapper( iShaderName );
  }
  void clearActiveShader() {
    mActiveShader = null;
  }
  
  void createDefaultState() {
    int vertCount  = getVertexCount();
    // Copy vert positions, normals and uvs into default state
    for(int i = 0; i < vertCount; i++) {
      mVertices.get( i ).addPositionState( "default", mVertices.get( i ).getPosition() );
      mVertices.get( i ).addNormalState( "default", mVertices.get( i ).getNormal() );
      mVertices.get( i ).addUVState( "default", mVertices.get( i ).getUV() );
    }
    
    mPosition.addState( "default", mPosition.get(), mPosition.getVelocity(), mPosition.getAcceleration() );
    mRotation.addState( "default", mRotation.get(), mRotation.getVelocity(), mRotation.getAcceleration() );
    mScale.addState( "default", mScale.get(), mScale.getVelocity(), mScale.getAcceleration() );
  }
  
  void createTargetState(String iStateName, TMesh iTarget) {
    int vertCount  = getVertexCount();
    int tVertCount = iTarget.getVertexCount();
    // Make sure the target has the same number of vertices
    if( vertCount == tVertCount ) {
      // Copy target's vert positions, normals and uvs into a new state of this mesh
      for(int i = 0; i < vertCount; i++) {
        mVertices.get( i ).addPositionState( iStateName, iTarget.mVertices.get( i ).getPosition() );
        mVertices.get( i ).addNormalState( iStateName, iTarget.mVertices.get( i ).getNormal() );
        mVertices.get( i ).addUVState( iStateName, iTarget.mVertices.get( i ).getUV() );
      }
      // Copy target's transform matrix into a new state of this mesh
      mPosition.addState( "default", iTarget.mPosition.get(), iTarget.mPosition.getVelocity(), iTarget.mPosition.getAcceleration() );
      mRotation.addState( "default", iTarget.mRotation.get(), iTarget.mRotation.getVelocity(), iTarget.mRotation.getAcceleration() );
      mScale.addState( "default", iTarget.mScale.get(), iTarget.mScale.getVelocity(), iTarget.mScale.getAcceleration() );
      // Turn on animation flags
      mUseVertAnim = true;
      mUseNormAnim = true;
      mUseUvAnim   = true;
    }
  }
  
  void goToState(String iStateName, float iDuration) {
    // Transition matrix
    mPosition.goToState( iStateName, iDuration );
    mRotation.goToState( iStateName, iDuration );
    mScale.goToState( iStateName, iDuration );
    // Transition vertices
    int vertCount  = getVertexCount();
    for(int i = 0; i < vertCount; i++) {
      mVertices.get( i ).goToPositionState( iStateName, iDuration );
      mVertices.get( i ).goToNormalState( iStateName, iDuration );
      mVertices.get( i ).goToUVState( iStateName, iDuration );
    }
  }
}
