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
// we will build up NodeGeom's capabilities further through the TMesh class.

// Define NodeGeom as a sub-class of NodeBase
class NodeGeom extends NodeBase { 
  // Geometric properties:
  PVector mPosition, mRotation, mScale;

  NodeGeom() {
    // Initialize base class (NodeBase)
    super();
    // Initialize transformations
    mPosition   = new PVector( 0.0, 0.0, 0.0 );
    mRotation   = new PVector( 0.0, 0.0, 0.0 );
    mScale      = new PVector( 1.0, 1.0, 1.0 );
  }
  
  NodeGeom(PVector iPosition, PVector iRotation, PVector iScale) {
    // Initialize base class (NodeBase)
    super();
    // Initialize transformations
    mPosition   = iPosition.get();
    mRotation   = iRotation.get();
    mScale      = iScale.get();
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
      drawContents();
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
}
