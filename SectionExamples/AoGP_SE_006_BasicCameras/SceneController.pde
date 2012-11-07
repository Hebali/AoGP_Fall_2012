class SceneController extends NodeGeom {
  NodeCam               mCamera;
  boolean           mDebugMode;
  
  SceneController(PApplet iApplet) {
    // Initialize base class (NodeGeom)
    super( new Globals( iApplet ) );
    // GLGraphics requires lower-level access to some of the PApplet's properties,
    // namely the OpenGL renderer. To provide this to each node, we'll create a globals
    // class that gets passed to each node when it is initialized. 
    mGlobals.setSceneController( this );
    // Initialize camera
    mCamera = new NodeCam( mGlobals );
    // Do not draw debug by default
    mDebugMode = false;
  }
  void draw() {
    // Enter scene
    mGlobals.mRenderer.beginGL();
    background(0);
    pushMatrix();
    // Everything drawn between beginCamera() and endCamera() 
    // will be render through mCamera's perspective.
    beginCamera();
    
    // Render camera
    mCamera.draw();
    
    // Flip the y-axis (Processing sets the +Y direction as the opposite of OpenGL's default, we'll flip it back here)
    scale(1,-1,1);

    // Call superclass draw() method. NodeGeom's draw() implementation will apply transformation matrix:
    super.draw();
    
    // Exit scene
    endCamera();
    popMatrix();
    mGlobals.mRenderer.endGL();
  }
  
  void toggleDebugMode() {
    mDebugMode = !mDebugMode;
  }
  
  boolean getDebugMode() {
    return mDebugMode;
  }
}
