class Globals {
  PApplet             mApplet;
  GLGraphics          mRenderer;
  GL                  mGl;
  SceneController     mScene;
  
  Globals(PApplet iApplet) {
    // Get applet reference
    mApplet = iApplet;
    // Get GLGraphics renderer reference
    mRenderer = (GLGraphics)g;
    // Get OpenGL handle reference
    mGl = mRenderer.gl;
  }
  
  void setSceneController(SceneController iScene) {
    mScene = iScene;
  }
}
