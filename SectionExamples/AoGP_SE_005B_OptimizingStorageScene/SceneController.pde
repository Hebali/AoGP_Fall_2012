class SceneController extends NodeGeom {
  boolean           mDebugMode;
  
  SceneController(PApplet iApplet) {
    // Initialize base class (NodeGeom)
    super( new Globals( iApplet ) );
    // GLGraphics requires lower-level access to some of the PApplet's properties,
    // namely the OpenGL renderer. To provide this to each node, we'll create a globals
    // class that gets passed to each node when it is initialized. 
    mGlobals.setSceneController( this );
    // Do not draw debug by default
    mDebugMode = false;
  }
  void draw() {
    // Enter scene
    mGlobals.mRenderer.beginGL();
    background(0);
    pushMatrix();

    // Call superclass draw() method. NodeGeom's draw() implementation will apply transformation matrix:
    super.draw();
    
    // Exit scene
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
