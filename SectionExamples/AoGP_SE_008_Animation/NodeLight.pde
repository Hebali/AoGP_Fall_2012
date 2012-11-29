class NodeLight extends NodeBase {
  int             mType;
  EaseVecDelta    mPosition, mDirection;  
  EaseVecDelta    mColor, mSpecularColor;
  EaseFloat       mSpotAngle, mSpotConcentration;
  
  NodeLight(Globals iGlobals) {
    // Initialize base class (NodeBase)
    super( iGlobals );
    // Initialize light defaults
    mPosition          = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mDirection         = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );    
    mColor             = new EaseVecDelta( new PVector( 255, 255, 255 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mSpecularColor     = new EaseVecDelta( new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ) );
    mSpotAngle         = new EaseFloat( radians( 45.0 ) );
    mSpotConcentration = new EaseFloat( 100.0 );    
    disable();    
  }

  void disable() {
    mType = -1;
  }
  
  int getType() {
    return mType;
  }
  
  void setType(int iType) {
    mType = iType;
  }  
  
  void draw() {
    if( mType < 0 ) { return; }
    
    // Update
    mPosition.update(); 
    mDirection.update();
    mColor.update();
    mSpecularColor.update();
    mSpotAngle.update();
    mSpotConcentration.update();
  
    // Render light
    if( mType == 0 ) {
      PVector tColor    = getColor();
      PVector tPosition = getPosition();
      ambientLight( tColor.x, tColor.y, tColor.z, tPosition.x, tPosition.y, tPosition.z );
    }
    else if( mType == 1 ) {
      PVector tColor     = getColor();
      PVector tDirection = getDirection();
      directionalLight( tColor.x, tColor.y, tColor.z, tDirection.x, tDirection.y, tDirection.z );
    }
    else if( mType == 2 ) {
      PVector tColor = getColor();
      PVector tPosition = getPosition();
      pointLight( tColor.x, tColor.y, tColor.z, tPosition.x, tPosition.y, tPosition.z );
    }
    else if( mType == 3 ) {
      PVector tColor     = getColor();
      PVector tPosition  = getPosition();
      PVector tDirection = getDirection();
      spotLight( tColor.x, tColor.y, tColor.z, 
                 tPosition.x, tPosition.y, tPosition.z, 
                 tDirection.x, tDirection.y, tDirection.z,
                 getSpotAngle(), getSpotConcentration() );
    }
    
    // Handle specularity
    PVector tSpecularColor = getSpecularColor();
    lightSpecular( tSpecularColor.x, tSpecularColor.y, tSpecularColor.z );
  }
  
  void goToState(String iStateName, float iDuration) {
    mPosition.goToState( iStateName, iDuration );
    mDirection.goToState( iStateName, iDuration ); 
    mColor.goToState( iStateName, iDuration );
    mSpecularColor.goToState( iStateName, iDuration );
    mSpotAngle.goToState( iStateName, iDuration ); 
    mSpotConcentration.goToState( iStateName, iDuration );
  }

  EaseVecDelta getPositionRef()                                { return mPosition; }
  EaseVecDelta getDirectionRef()                               { return mDirection; }
  
  EaseVecDelta getColorRef()                                   { return mColor; }
  EaseVecDelta getSpecularColorRef()                           { return mSpecularColor; }
    
  EaseFloat    getSpotAngleRef()                               { return mSpotAngle; }
  EaseFloat    getSpotConcentrationRef()                       { return mSpotConcentration; }
  
  PVector      getPosition()                                   { return mPosition.get(); }
  PVector      getDirection()                                  { return mDirection.get(); }
  
  PVector      getPositionVelocity()                           { return mPosition.getVelocity(); }
  PVector      getDirectionVelocity()                          { return mDirection.getVelocity(); }
  
  PVector      getPositionAcceleration()                       { return mPosition.getAcceleration(); }
  PVector      getDirectionAcceleration()                      { return mDirection.getAcceleration(); }
  
  PVector      getColor()                                      { return mColor.get(); }
  PVector      getSpecularColor()                              { return mSpecularColor.get(); }
  
  PVector      getColorVelocity()                              { return mColor.getVelocity(); }
  PVector      getSpecularColorVelocity()                      { return mSpecularColor.getVelocity(); }
  
  PVector      getColorAcceleration()                          { return mColor.getAcceleration(); }
  PVector      getSpecularColorAcceleration()                  { return mSpecularColor.getAcceleration(); }
    
  float        getSpotAngle()                                  { return mSpotAngle.get(); }
  float        getSpotConcentration()                          { return mSpotConcentration.get(); }
  
  void         setColor(PVector iValue)                        { mColor.set( iValue ); }
  void         setSpecularColor(PVector iValue)                { mSpecularColor.set( iValue ); }
  
  void         setColorVelocity(PVector iValue)                { mColor.setVelocity( iValue ); }
  void         setSpecularColorVelocity(PVector iValue)        { mSpecularColor.setVelocity( iValue ); }
  
  void         setColorAcceleration(PVector iValue)            { mColor.setAcceleration( iValue ); }
  void         setSpecularColorAcceleration(PVector iValue)    { mSpecularColor.setAcceleration( iValue ); }
  
  void         setSpotAngle(float iValue)                      { mSpotAngle.set( iValue ); }
  void         setSpotConcentration(float iValue)              { mSpotConcentration.set( iValue ); }
  
  void         setPosition(PVector iValue)                     { mPosition.set( iValue ); }
  void         setDirection(PVector iValue)                    { mDirection.set( iValue ); }
  
  void         setPositionVelocity(PVector iValue)             { mPosition.setVelocity( iValue ); }
  void         setDirectionVelocity(PVector iValue)            { mDirection.setVelocity( iValue ); }
  
  void         setPositionAcceleration(PVector iValue)         { mPosition.setAcceleration( iValue ); }
  void         setDirectionAcceleration(PVector iValue)        { mDirection.setAcceleration( iValue ); }
  
  void setLookAt(PVector iEye, PVector iTarget) {
    // This method will set a spotlight position and direction in a similar manner to
    // the specification of a camera's eye and target positions.
    mPosition.set( iEye );
    PVector tDir = PVector.sub( iTarget, iEye );
    tDir.normalize();
    mDirection.set( tDir );
  }
  
  void createAmbient(int iRed, int iGreen, int iBlue, PVector iPosition) {
    mColor.set( new PVector( iRed, iGreen, iBlue ) );
    mPosition.set( iPosition );
    setType( 0 );
  }
  
  void createDirectional(int iRed, int iGreen, int iBlue, PVector iDirection) {
    mColor.set( new PVector( iRed, iGreen, iBlue ) );
    mDirection.set( iDirection );
    setType( 1 );
  }
  
  void createPoint(int iRed, int iGreen, int iBlue, PVector iPosition) {
    mColor.set( new PVector( iRed, iGreen, iBlue ) );
    mPosition.set( iPosition );
    setType( 2 );
  }
  
  void createSpotlight(int iRed, int iGreen, int iBlue, PVector iPosition, PVector iDirection, float iAngle, float iConcentration) {
    mColor.set( new PVector( iRed, iGreen, iBlue ) );
    mPosition.set( iPosition );
    mDirection.set( iDirection );
    mSpotAngle.set( iAngle );
    mSpotConcentration.set( iConcentration );
    setType( 3 );
  }
}
