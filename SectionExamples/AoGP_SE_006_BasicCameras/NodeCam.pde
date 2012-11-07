class NodeCam extends NodeBase {
  PVector         mEye, mTarget, mUp;
  float           mFov, mNear, mFar;
  boolean         useOrtho;
  
  NodeCam(Globals iGlobals) {
    // Initialize base class (NodeBase)
    super( iGlobals );
    // Initialize camera vector defaults
    mEye    = new PVector( 0.0, 0.0, 0.0 );
    mTarget = new PVector( 0.0, 0.0, 0.0 );
    mUp     = new PVector( 0.0, 1.0, 0.0 );
    // Initialize default field-of-view, near plane and far plane
    mFov    = PI/3.0;
    mNear   = 0.1;
    mFar    = 10000.0;
    // Uses perspective projection by default
    useOrtho = false;                                  
  }
  
  void draw() {
    // Set camera properties
    if( useOrtho ) {
      ortho( -width/2.0, width/2.0, -height/2.0, height/2.0, mNear, mFar );
    }
    else {
      perspective( mFov, (float)width/height, mNear, mFar );
    }
    camera( mEye.x, mEye.y, mEye.z, mTarget.x, mTarget.y, mTarget.z, mUp.x, mUp.y, mUp.z );
  }
  
  boolean getOrtho()                 { return useOrtho; }
  void    setOrtho(boolean iOrtho)   { useOrtho = iOrtho; }
  void    setOrtho()                 { useOrtho = true; }
  void    setPersp()                 { useOrtho = false; }
  
  PVector getEye()                   { return mEye; }
  PVector getTarget()                { return mTarget; }
  PVector getWorldUp()               { return mUp; }
  
  void    setEye(PVector iValue)     { mEye.set( iValue ); }
  void    setTarget(PVector iValue)  { mTarget.set( iValue ); }
  void    setWorldUp(PVector iValue) { mUp.set( iValue ); }
  
  float   getFov()                   { return mFov; }
  float   getNear()                  { return mNear; }
  float   getFar()                   { return mFar; }
  
  void    setFov(float iValue)       { mFov  = iValue; }
  void    setNear(float iValue)      { mNear = iValue; }
  void    setFar(float iValue)       { mFar  = iValue; }
}
