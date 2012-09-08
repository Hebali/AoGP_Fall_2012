// Class: NodeBase
// Description: A basic scenegraph object.
// Purpose: It is easy enough to keep track of a few objects within a simple program architecture. 
// As we build increasingly complex 3D scenes, however, it will become more difficult to manage objects
// and the relationships between them. Therefore, it is important to establish a data structure that can
// encapsulate some of this complexity. One common design pattern, used in modeling environments such as
// Maya as well as games and visualizations, is the "scenegraph." In this hierarchical pattern, 
// each object (or "node") can have upto one parent and an unlimited number of children. 
// Nodes that have no parent are called "root" nodes. Nodes can be set to inherit properties from 
// their parents or perform operations on their children, allowing operations to be easily cascaded
// down a scenegraph. For example, a spine object could be established as a root node, with leg objects
// as its children. Each leg would have 5 toe children. When the user moves the spine object in 3D space,
// the legs and toes will move with it automatically. If the user instead moved one of the legs, only its 
// toes would move with it. This hierarchical structure allows us to greatly reduce the complexity 
// of interacting with the scene.

class NodeBase { 
  // Scenegraph properties:
  String              mName;
  NodeBase            mParent;
  ArrayList<NodeBase> mChildren;
  // Rendering properties: 
  boolean             mVisibility;
  
  NodeBase() {
    // Initialize default name
    mName       = "untitled";
    // Initialize default visibility
    mVisibility = true;
    // Set default parent to null (no parent)
    mParent     = null;
    // Initialize child list
    mChildren   = new ArrayList();
  }
  
  void setName(String iName) {
    // Set node's name from input string
    mName = iName;
  }
  
  String getName() {
    // Return node's name
    return mName;
  }
  
  void addChild(NodeBase iChild) {
    // Set child's parent to be this node
    iChild.setParent( this );
    // Add input node to list of children
    mChildren.add( iChild );
  }
  
  void removeChild(int iIndex) {
    // Make sure that the input index is within the arraylist bounds
    if( iIndex >= 0 && iIndex < mChildren.size() ) {
      // Remove the parent reference from child node at the given index
      mChildren.get( iIndex ).setParent( null );
      // Remove the node at the given index from child list
      mChildren.remove( iIndex );
    }
  }
  
  NodeBase getChild(int iIndex) {
    // Make sure that the input index is within the arraylist bounds
    if( iIndex >= 0 && iIndex < mChildren.size() ) {
      // Return the child node at the given index
      return mChildren.get( iIndex );
    }
    // Otherwise return null (no object)
    return null;
  }
  
  int getChildCount() {
    // Return the number of children under current node
    return mChildren.size();
  }
  
  void setParent(NodeBase iParent) {
    // Set the parent reference to a given node
    mParent = iParent;
  }
  
  NodeBase getParent() {
    // Get a reference to the node's parent
    return mParent;
  }
  
  boolean isRootNode() {
    // Return whether the node is a root node
    // A root node is one that does not have a parent
    return (mParent == null);
  }
  
  NodeBase getRootNode() {
    // If node is a root, return it
    if( isRootNode() ) {
      return this;
    }
    // Otherwise, climb up scenegraph until we reach a root
    return mParent.getRootNode();
  }
  
  boolean getVisibility() {
    // Return the node's visibility
    return mVisibility;
  }
  
  boolean getParentVisibility() {
    // If node is a root, return its visibility
    if( isRootNode() ) {
      return mVisibility;
    }
    // The mVisibility of both current node and its parent (and grandparent, etc) must be true for current to be visible
    return (mParent.getVisibility() && mVisibility);
  }
  
  void setVisibility(boolean iVisibility) {
    // Set the node's visibility from input
    mVisibility = iVisibility;
  }
  
  void toggleVisibility() {
    // Toggle visibility boolean
    mVisibility = !mVisibility;
  }

  void print(int iIndent) {
    if( getVisibility() ) {
      // Format indentation string
      String indent = "  ";
      int    len = indent.length() * iIndent;
      String indentStr = new String(new char[len]).replace( "\0", indent );
      // Print node info string
      println( indentStr + mName );
      // Print children
      int tChildCount = getChildCount();
      for(int i = 0; i < tChildCount; i++) {
        mChildren.get( i ).print( iIndent + 1 );
      }
    }
  }
  
  void draw() {
    // Stub method.
  }
  
}
