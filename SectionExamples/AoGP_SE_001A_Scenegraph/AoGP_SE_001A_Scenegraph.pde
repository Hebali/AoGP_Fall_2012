// Art of Graphics Programming
// Section Example 001: "Basic Scenegraph: Node trees and nested matrices"
// Example Stage: A
// Course Materials by Patrick Hebron

NodeBase root;

void setup() {
  // In this example, we'll build a basic scenegraph node object (see NodeBase tab).
  // This first version of a node will contain the barebones necessities of a scenegraph. 
  // We'll add the ability to store geometric properties later.
  
  // To test the scenegraph system, we'll add a few nodes and then print their names
  // to the console in an indent-delineated hierarchy. We'll also periodically toggle 
  // the visibility of a particular branch of the scenegraph (see below).
  
  root = new NodeBase();
  root.setName( "root" );
  
  NodeBase childA = new NodeBase();
  childA.setName( "childA" );
  root.addChild( childA );
  
  NodeBase childB = new NodeBase();
  childB.setName( "childB" );
  root.addChild( childB );
  
  NodeBase childC = new NodeBase();
  childC.setName( "childC" );
  root.addChild( childC );
  
  NodeBase childA1 = new NodeBase();
  childA1.setName( "childA1" );
  childA.addChild( childA1 );
  
  NodeBase childA2 = new NodeBase();
  childA2.setName( "childA2" );
  childA.addChild( childA2 );
  
  NodeBase childB1 = new NodeBase();
  childB1.setName( "childB1" );
  childB.addChild( childB1 );
  
  NodeBase childC1 = new NodeBase();
  childC1.setName( "childC1" );
  childC.addChild( childC1 );
  
  NodeBase childA1A = new NodeBase();
  childA1A.setName( "childA1A" );
  childA1.addChild( childA1A );
}

void draw() {
  if( frameCount % 60 == 0 ) {
    println("-----------------");
    // Print the scenegraph
    root.print( 0 );
    // Toggle childA's visibility
    NodeBase childA = root.getChild( 0 );
    // NodeBase's getChild() method will safely prevent invalid array access,
    // but if a child does not exist at the given index 0, the parent will return null.
    // So before operating on the child, we need to make sure the returned object is valid.
    if( childA != null ) {
      // Notice that when childA's visibility is turned off, all of its children and grandchildren
      // become invisible as well. Without a scenegraph, we would have needed to toggle each
      // descendant node individually.
      childA.toggleVisibility();
    }
  }
}
