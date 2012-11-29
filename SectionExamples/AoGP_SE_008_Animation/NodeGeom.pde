// Class: NodeGeom
// Description: A basic scenegraph object, extended to store some basic geometric data.
// Purpose: Rather than adding geometric properties such as position, rotation and scale 
// directly to the NodeBase class, we'll make a sub-class of it called NodeGeom. The programming 
// concept of a "sub-class" is, in some ways, quite like a scenegraph. A sub-class inherits 
// all of the variables and methods defined within the super-class, but can also define additional 
// variables and methods that do not exist within its super. By sub-classing NodeGeom from 
// NodeBase, rather than combining them into a single class, we increase the legibility of each.
// More importantly, we allow for the possibility that we may at some point have use for 
// non-geometric NodeBase objects. We may also want to sub-class NodeBase in other directions that
// diverge from NodeGeom's properties. In this sense, a class hierarchy could also be 
// likened to a taxonomy of species. For instance, mammals possess all animal traits plus various 
// mammal-specific traits. Dogs and cats each possess all animal and mammal traits, plus various 
// other traits that each does not share with the other. As we develop our graphics platform,
// we will build up NodeGeom's capabilities further through the TMesh class. For easy geometry
// creation and parenting, each NodeGeom will have access to a TMeshFactory.

// Define NodeGeom as a sub-class of NodeBase
class NodeGeom extends NodeBase { 
  // Geometric properties:
  EaseVecDelta    mPosition, mRotation, mScale;
  // Geometry factory:
  TMeshFactory    mMeshFactory;

  NodeGeom(Globals iGlobals) {
    // Initialize base class (NodeBase)
    super( iGlobals );
    // Initialize mesh factory
    mMeshFactory = new TMeshFactory( mGlobals );
    // Initialize transformations
    mPosition   = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mRotation   = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mScale      = new EaseVecDelta( new PVector( 1.0, 1.0, 1.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
  }
  
  NodeGeom(Globals iGlobals, PVector iPosition, PVector iRotation, PVector iScale) {
    // Initialize base class (NodeBase)
    super( iGlobals );
    // Initialize mesh factory
    mMeshFactory = new TMeshFactory( mGlobals );
    // Initialize transformations
    mPosition   = new EaseVecDelta( iPosition.get(), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mRotation   = new EaseVecDelta( iRotation.get(), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mScale      = new EaseVecDelta( iScale.get(), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
  }

  void draw() {  
    // Draw node if visible
    if( getVisibility() ) {
      // Enter node's transformation matrix
      pushMatrix();
      // Update transformations
      mPosition.update();
      mRotation.update();
      mScale.update();
      // Perform transformations
      PVector tPosition = mPosition.get();
      PVector tScale    = mScale.get();
      PVector tRotation = mRotation.get();
      translate( tPosition.x, tPosition.y, tPosition.z );
      scale( tScale.x, tScale.y, tScale.z );
      rotateX( tRotation.x );
      rotateY( tRotation.y );
      rotateZ( tRotation.z );
      // Draw node contents
      drawContents();
      // Determine from scene controller whether to draw debug
      if( mGlobals.mScene.getDebugMode() ) {
        noLights();
        drawDebug();
        lights();
      }
      // Draw children
      int tChildCount = getChildCount();
      for(int i = 0; i < tChildCount; i++) {
        getChild(i).draw();
      }
      // Exit node's transformation matrix
      popMatrix();
    }
  }
  
  void drawContents() {
    // This is a stub method. It will overrided by 
    // TMesh's method of the same name.
  }
  
  PVector getAbsolutePosition() {
    // If node is a root, return it's position
    if( isRootNode() ) {
      return mPosition.get();
    }
    // This method bakes parent translations into returned position:
    return PVector.add( mPosition.get(), ((NodeGeom)mParent).getAbsolutePosition() );
  }
  
  EaseVecDelta getPositionRef()             { return mPosition; }
  EaseVecDelta getRotationRef()             { return mRotation; }
  EaseVecDelta getScaleRef()                { return mScale; }
  
  void setPosition(PVector iValue)             { mPosition.set( iValue ); }
  void setPositionVelocity(PVector iValue)     { mPosition.setVelocity( iValue ); }
  void setPositionAcceleration(PVector iValue) { mPosition.setAcceleration( iValue ); }
  void setRotation(PVector iValue)             { mRotation.set( iValue ); }
  void setRotationVelocity(PVector iValue)     { mRotation.setVelocity( iValue ); }
  void setRotationAcceleration(PVector iValue) { mRotation.setAcceleration( iValue ); }
  void setScale(PVector iValue)                { mScale.set( iValue ); }
  void setScaleVelocity(PVector iValue)        { mScale.setVelocity( iValue ); }
  void setScaleAcceleration(PVector iValue)    { mScale.setAcceleration( iValue ); }
  
  void addStatePosition(String iStateName, PVector iValue)             { mPosition.addState( iStateName, iValue ); }
  void addStatePositionVelocity(String iStateName, PVector iValue)     { mPosition.addStateVelocity( iStateName, iValue ); }
  void addStatePositionAcceleration(String iStateName, PVector iValue) { mPosition.addStateAcceleration( iStateName, iValue ); }
  void addStateRotation(String iStateName, PVector iValue)             { mRotation.addState( iStateName, iValue ); }
  void addStateRotationVelocity(String iStateName, PVector iValue)     { mRotation.addStateVelocity( iStateName, iValue ); }
  void addStateRotationAcceleration(String iStateName, PVector iValue) { mRotation.addStateAcceleration( iStateName, iValue ); }
  void addStateScale(String iStateName, PVector iValue)                { mScale.addState( iStateName, iValue ); }
  void addStateScaleVelocity(String iStateName, PVector iValue)        { mScale.addStateVelocity( iStateName, iValue ); }
  void addStateScaleAcceleration(String iStateName, PVector iValue)    { mScale.addStateAcceleration( iStateName, iValue ); }
  
  void goToState(String iStateName, float iDuration) {
    mPosition.goToState( iStateName, iDuration );
    mRotation.goToState( iStateName, iDuration );
    mScale.goToState( iStateName, iDuration );
  }
  
  TMesh addMesh(int iDimU, int iDimV, float iLengthU, float iLengthV) {
    TMesh curr = mMeshFactory.createMesh( iDimU, iDimV, iLengthU, iLengthV );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addTerrain(int iDimU, int iDimV, float iLengthU, float iLengthV, float iMinHeight, float iMaxHeight, int iOctaves, float iFalloff) {
    TMesh curr = mMeshFactory.createTerrain( iDimU, iDimV, iLengthU, iLengthV, iMinHeight, iMaxHeight, iOctaves, iFalloff );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addCylinder(int iDimU, int iDimV, float iProfileRadius, float iLength) {
    TMesh curr = mMeshFactory.createCylinder( iDimU, iDimV, iProfileRadius, iLength );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addCone(int iDimU, int iDimV, float iBaseRadius, float iLength) {
    TMesh curr = mMeshFactory.createCone( iDimU, iDimV, iBaseRadius, iLength );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addTorus(int iDimU, int iDimV, float iProfileRadius, float iTorusRadius) {
    TMesh curr = mMeshFactory.createTorus( iDimU, iDimV, iProfileRadius, iTorusRadius );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addSphere(int iDimU, int iDimV, float iRadius) {
    TMesh curr = mMeshFactory.createSphere( iDimU, iDimV, iRadius );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
  
  TMesh addCube(int iDimW, int iDimH, int iDimD, float iLengthW, float iLengthH, float iLengthD) {
    TMesh curr = mMeshFactory.createCube( iDimW, iDimH, iDimD, iLengthW, iLengthH, iLengthD );
    curr.setParent( this );
    addChild( curr );
    return curr;
  }
}
