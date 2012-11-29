class EaseFloat {
  float     controlState;
  float     beginState;
  float     deltaState;
  
  float     beginTime;
  float     duration;
  
  int       easeType;
  
  HashMap   stateLibrary;  
  
  EaseFloat(float ControlState) {
    // Set control variable
    controlState = ControlState;
    // Initialize state map
    stateLibrary = new HashMap();
    setEaseType( 0 );
    // Reset animation parameters
    resetTransition();
  }
  
  void setEaseType(String iTypeName) {
    easeType = getEaseType( iTypeName );
  }
  
  void setEaseType(int iType) {
    easeType = iType;
  }
  
  int getEaseType() {
    return easeType;
  }
  
  void addState(String iStateName, float iState) {
    // If the state name is unique, add it to map:
    if( !stateLibrary.containsKey( iStateName ) ) {
      stateLibrary.put( iStateName, iState );
    }
    else { 
      println("You're trying to override state: " + iStateName);
    }
  }
  
  void goToState(String iStateName, float iDuration) {
    // If the given state exists in map, transition to it:
    if( stateLibrary.containsKey( iStateName ) ) {
      float targetState = (Float)stateLibrary.get( iStateName );
      transition( controlState, targetState, iDuration );
    }
  }

  void transition(float BeginState, float EndState, float DurationInSec) {
    // Set transition duration
    duration = DurationInSec;
    // Prevent divide-by-zero errors
    if( duration == 0.0 ) {
      duration = EPSILON;
    }
    // Set the transition states
    beginState   = BeginState;
    controlState = BeginState;
    // The Easing Library uses delta state rather than end
    deltaState   = EndState - beginState;
    // Now that everything is setup, start the transition timer
    startTransition();
  }
  
  void update() {
    // Only update if a beginTime has been defined (valid times will be >= 0)
    if( beginTime >= 0.0 ) {
      // Get the elapsed time
      float elapsedTime = getElapsedSeconds();
      // Clamp elapsed time to duration
      float currentTime = min( elapsedTime, duration );
      // Apply easing transition:
      controlState = getEaseValue( easeType, currentTime, beginState, deltaState, duration );
      // If we've reached duration, transition is complete and we can reset
      if( elapsedTime >= duration ) {
        resetTransition();
      }
    }
  }
  
  void set(float iValue) {
    controlState = iValue;
  }

  float get() {
    return controlState;
  }
  
  void resetTransition() {
    beginTime = -1.0; 
    duration  =  0.0;
  }
  
  void startTransition() {
    beginTime = (float)millis();
  }
  
  float getElapsedMillis() {
    return ((float)millis() - beginTime);
  }
  
  float getElapsedSeconds() {
    return (getElapsedMillis() / 1000.0);
  }
  
  int getEaseType(String iName) {
    // There are more elegant ways to do this, but they're more linguistically complex.
    if     ( iName.equals( "Linear.easeIn" ) ) 	        { return 0; }   
    else if( iName.equals( "Linear.easeOut" ) ) 	{ return 1; }      
    else if( iName.equals( "Linear.easeInOut" ) )       { return 2; }    
    else if( iName.equals( "Quad.easeIn" ) ) 	        { return 3; }        
    else if( iName.equals( "Quad.easeOut" ) ) 	        { return 4; }       
    else if( iName.equals( "Quad.easeInOut" ) ) 	{ return 5; }     
    else if( iName.equals( "Cubic.easeIn" ) ) 	        { return 6; }       
    else if( iName.equals( "Cubic.easeOut" ) ) 	        { return 7; }      
    else if( iName.equals( "Cubic.easeInOut" ) )	{ return 8; }    
    else if( iName.equals( "Quart.easeIn" ) ) 	        { return 9; }       
    else if( iName.equals( "Quart.easeOut" ) ) 	        { return 10; }      
    else if( iName.equals( "Quart.easeInOut" ) ) 	{ return 11; }    
    else if( iName.equals( "Quint.easeIn" ) ) 	        { return 12; }       
    else if( iName.equals( "Quint.easeOut" ) ) 	        { return 13; }      
    else if( iName.equals( "Quint.easeInOut" ) ) 	{ return 14; }    
    else if( iName.equals( "Sine.easeIn" ) )	        { return 15; }       
    else if( iName.equals( "Sine.easeOut" ) ) 	        { return 16; }      
    else if( iName.equals( "Sine.easeInOut" ) ) 	{ return 17; }    
    else if( iName.equals( "Circ.easeIn" ) ) 	        { return 18; }       
    else if( iName.equals( "Circ.easeOut" ) ) 	        { return 19; }      
    else if( iName.equals( "Circ.easeInOut" ) ) 	{ return 20; }    
    else if( iName.equals( "Expo.easeIn" ) ) 	        { return 21; }       
    else if( iName.equals( "Expo.easeOut" ) ) 	        { return 22; }      
    else if( iName.equals( "Expo.easeInOut" ) ) 	{ return 23; }    
    else if( iName.equals( "Back.easeIn" ) ) 	        { return 24; }       
    else if( iName.equals( "Back.easeOut" ) ) 	        { return 25; }      
    else if( iName.equals( "Back.easeInOut" ) ) 	{ return 26; }    
    else if( iName.equals( "Bounce.easeIn" ) ) 	        { return 27; }       
    else if( iName.equals( "Bounce.easeOut" ) ) 	{ return 28; }      
    else if( iName.equals( "Bounce.easeInOut" ) )       { return 29; }    
    else if( iName.equals( "Elastic.easeIn" ) ) 	{ return 30; }       
    else if( iName.equals( "Elastic.easeOut" ) ) 	{ return 31; }      
    else if( iName.equals( "Elastic.easeInOut" ) )      { return 32; }    
    return -1;
  }
  
  float getEaseValue(int iType, float iTime, float iBeginState, float iDeltaState, float iDuration) {
    // There are more elegant ways to do this, but they're more linguistically complex.
    if     ( iType == 0 )  { return Linear.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }   
    else if( iType == 1 )  { return Linear.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 2 )  { return Linear.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 3 )  { return Quad.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }        
    else if( iType == 4 )  { return Quad.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 5 )  { return Quad.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }     
    else if( iType == 6 )  { return Cubic.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 7 )  { return Cubic.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 8 )  { return Cubic.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 9 )  { return Quart.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 10 ) { return Quart.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 11 ) { return Quart.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 12 ) { return Quint.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 13 ) { return Quint.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 14 ) { return Quint.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 15 ) { return Sine.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 16 ) { return Sine.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 17 ) { return Sine.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 18 ) { return Circ.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 19 ) { return Circ.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 20 ) { return Circ.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 21 ) { return Expo.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 22 ) { return Expo.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 23 ) { return Expo.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 24 ) { return Back.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 25 ) { return Back.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 26 ) { return Back.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 27 ) { return Bounce.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 28 ) { return Bounce.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 29 ) { return Bounce.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }    
    else if( iType == 30 ) { return Elastic.easeIn( iTime, iBeginState, iDeltaState, iDuration ); }       
    else if( iType == 31 ) { return Elastic.easeOut( iTime, iBeginState, iDeltaState, iDuration ); }      
    else if( iType == 32 ) { return Elastic.easeInOut( iTime, iBeginState, iDeltaState, iDuration ); }   
    return iBeginState;
  }
}
