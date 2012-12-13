class EaseVecDelta {
  EaseVec   pos, vel, acc;
  
  EaseVecDelta() {
    // Initialize ease vars
    pos = new EaseVec( new PVector( 0.0, 0.0, 0.0 ) );
    vel = new EaseVec( new PVector( 0.0, 0.0, 0.0 ) );
    acc = new EaseVec( new PVector( 0.0, 0.0, 0.0 ) );
  }
  
  EaseVecDelta(PVector iPosition, PVector iVelocity, PVector iAcceleration) {
    // Initialize ease vars
    pos = new EaseVec( iPosition.get() );
    vel = new EaseVec( iVelocity.get() );
    acc = new EaseVec( iAcceleration.get() );
  }
  
  void setEaseType(String iTypeName) {
    pos.setEaseType( iTypeName );
    vel.setEaseType( iTypeName );
    acc.setEaseType( iTypeName );
  }
  
  void addState(String iStateName, PVector iPosition, PVector iVelocity, PVector iAcceleration) {
    // Add component states
    pos.addState( iStateName, iPosition );
    vel.addState( iStateName, iVelocity );
    acc.addState( iStateName, iAcceleration );
  }
  
  void addState(String iStateName, PVector iValue) {
    pos.addState( iStateName, iValue );
  }
  
  void addStateVelocity(String iStateName, PVector iValue) {
    vel.addState( iStateName, iValue );
  }
  
  void addStateAcceleration(String iStateName, PVector iValue) {
    acc.addState( iStateName, iValue );
  }
  
  void goToState(String iStateName, float iDuration) {
    // Goto component states
    pos.goToState( iStateName, iDuration );
    vel.goToState( iStateName, iDuration );
    acc.goToState( iStateName, iDuration );
  }

  void update() {
    // Update components
    pos.update();
    vel.update();
    acc.update();
    // Update position and velocity
    vel.set( PVector.add( vel.get(), acc.get() ) );
    pos.set( PVector.add( pos.get(), vel.get() ) );
  }
  
  void set(PVector iPosition) {
    pos.set( iPosition );
  }
  
  void setVelocity(PVector iVelocity) {
    vel.set( iVelocity );
  }
  
  void setAcceleration(PVector iAcceleration) {
    acc.set( iAcceleration );
  }
  
  void set(PVector iPosition, PVector iVelocity, PVector iAcceleration) {
    pos.set( iPosition );
    vel.set( iVelocity );
    acc.set( iAcceleration );
  }
  
  PVector get() {
    return pos.get();
  }
  
  PVector getVelocity() {
    return vel.get();
  }
  
  PVector getAcceleration() {
    return acc.get();
  }
  
  void resetTransition() {
    // Reset components
    pos.resetTransition();
    vel.resetTransition();
    acc.resetTransition();
  }
  
  void startTransition() {
    // Start components
    pos.startTransition();
    vel.startTransition();
    acc.startTransition();
  }
}
