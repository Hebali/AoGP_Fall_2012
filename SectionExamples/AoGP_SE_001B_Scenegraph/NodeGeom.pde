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
// we can build up NodeGeom's capabilities further. For now, NodeGeom will store the position, 
// rotation, scale, color and side length of a square.

// Define NodeGeom as a sub-class of NodeBase
class NodeGeom extends NodeBase { 
  // Geometric properties:
  PVector mPosition, mRotation, mScale;
  // Rendering properties:
  color mColor;
  float mSideLength;

  NodeGeom() {
    // Initialize base class (NodeBase)
    super();
    // Initialize transformations
    mPosition   = new PVector( 0.0, 0.0, 0.0 );
    mRotation   = new PVector( 0.0, 0.0, 0.0 );
    mScale      = new PVector( 1.0, 1.0, 1.0 );
    // Initialize properties
    mColor      = color( 255, 255, 255 );
    mSideLength = 1.0;
  }
  
  NodeGeom(PVector iPosition, PVector iRotation, PVector iScale) {
    // Initialize base class (NodeBase)
    super();
    // Initialize transformations
    mPosition   = iPosition.get();
    mRotation   = iRotation.get();
    mScale      = iScale.get();
    // Initialize properties
    mColor      = color( 255, 255, 255 );
    mSideLength = 1.0;
  }

  void draw() {  
    // Draw node if visible
    if( getVisibility() ) {
      // Enter node's transformation matrix
      pushMatrix();
      // Perform transformations
      translate( mPosition.x, mPosition.y, mPosition.z );
      scale( mScale.x, mScale.y, mScale.z );
      rotateX( mRotation.x );
      rotateY( mRotation.y );
      rotateZ( mRotation.z );
      // Draw node contents
      // For testing purposes, we'll just draw a rectangle
      noStroke();
      fill( mColor );
      rect( -mSideLength/2.0, -mSideLength/2.0, mSideLength, mSideLength );
      // Draw children
      int tChildCount = getChildCount();
      for(int i = 0; i < tChildCount; i++) {
        getChild(i).draw();
      }
      // Exit node's transformation matrix
      popMatrix();
    }
  }
  
  PVector getPosition() { 
    return mPosition;
  }
  
  PVector getRotation() { 
    return mRotation;
  }
  
  PVector getScale() { 
    return mScale;
  }
  
  void setPosition(PVector iValue) { 
    mPosition.set( iValue );
  }
  
  void setRotation(PVector iValue) { 
    mRotation.set( iValue );
  }
  
  void setScale(PVector iValue) { 
    mScale.set( iValue );
  }
  
  color getColor() {
    return mColor;
  }
  
  void setColor(color iColor) {
    mColor = iColor;
  }
  
  float getSideLength() {
    return mSideLength;
  }
  
  void setSideLength(float iLength) {
    mSideLength = iLength;
  }
}
