class NodeLight extends NodeBase {
  int             mType;
  PVector         mPosition, mDirection;  
  PVector         mColor, mSpecularColor;
  float           mSpotAngle, mSpotConcentration;
  
  NodeLight(Globals iGlobals) {
    // Initialize base class (NodeBase)
    super( iGlobals );
    // Initialize light defaults
    mPosition          = new PVector( 0.0, 0.0, 0.0 );
    mDirection         = new PVector( 0.0, 0.0, 0.0 );    
    mColor             = new PVector( 255, 255, 255 );
    mSpecularColor     = new PVector( 0.0, 0.0, 0.0 );
    mSpotAngle         = radians(45.0);
    mSpotConcentration = 100.0;    
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
    
    // Render light
    if( mType == 0 ) {
      ambientLight( mColor.x, mColor.y, mColor.z, mPosition.x, mPosition.y, mPosition.z );
    }
    else if( mType == 1 ) {
      directionalLight( mColor.x, mColor.y, mColor.z, mDirection.x, mDirection.y, mDirection.z );
    }
    else if( mType == 2 ) {
      pointLight( mColor.x, mColor.y, mColor.z, mPosition.x, mPosition.y, mPosition.z );
    }
    else if( mType == 3 ) {
      spotLight( mColor.x, mColor.y, mColor.z, 
                 mPosition.x, mPosition.y, mPosition.z, 
                 mDirection.x, mDirection.y, mDirection.z,
                 mSpotAngle, mSpotConcentration );
    }
    
    // Handle specularity
    lightSpecular( mSpecularColor.x, mSpecularColor.y, mSpecularColor.z );
  }

  PVector getPosition()                       { return mPosition; }
  PVector getDirection()                      { return mDirection; }
  
  PVector getColor()                          { return mColor; }
  PVector getSpecularColor()                  { return mSpecularColor; }
    
  float   getSpotAngle()                      { return mSpotAngle; }
  float   getSpotConcentration()              { return mSpotConcentration; }
  
  void    setColor(PVector iValue)            { mColor.set( iValue ); }
  void    setSpecularColor(PVector iValue)    { mSpecularColor.set( iValue ); }
      
  void    setSpotAngle(float iValue)          { mSpotAngle = iValue; }
  void    setSpotConcentration(float iValue)  { mSpotConcentration = iValue; }
  
  void    setPosition(PVector iValue)         { mPosition.set( iValue ); }
  void    setDirection(PVector iValue)        { mDirection.set( iValue ); }
  
  void setLookAt(PVector iEye, PVector iTarget) {
    // This method will set a spotlight position and direction in a similar manner to
    // the specification of a camera's eye and target positions.
    mPosition.set( iEye );
    mDirection.set( PVector.sub( iTarget, iEye ) );
    mDirection.normalize();
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
    mSpotAngle = iAngle;
    mSpotConcentration = iConcentration;
    setType( 3 );
  }
}
