class SceneController extends NodeGeom {
  NodeCam           mCamera;
  NodeLight[]       mLights;
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
    // Initialize light array (OpenGL only allows 8 lights)
    mLights = new NodeLight[8];
    for(int i = 0; i < 8; i++) {
      mLights[i] = new NodeLight( mGlobals );
    }
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
    
    // Render lights
    for(int i = 0; i < 8; i++) {
      mLights[i].draw();
    }

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
  
  void goToCameraState(String iStateName, float iDuration) {
    mCamera.gotoState( iStateName, iDuration );
  }
  
  void goToLightState(String iStateName, float iDuration) {
    // transitions all lights to given state (if state name is found in map)
    for(int i = 0; i < 8; i++) {
      mLights[i].goToState( iStateName, iDuration );
    }
  }
  
  NodeLight getLight(int iLightIndex) {
    iLightIndex = max( 0, iLightIndex );
    iLightIndex = min( 7, iLightIndex );
    return mLights[iLightIndex];
  }
}
