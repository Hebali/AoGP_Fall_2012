// Art of Graphics Programming
// Section Example 001: "Basic Scenegraph: Node trees and nested matrices"
// Example Stage: B
// Course Materials by Patrick Hebron

import processing.opengl.*;

NodeGeom root;

void setup() {
  // In this example, we've extended the scenegraph node object to include a few basic geometric properties (see NodeGeom tab).
  // Most importantly, we've added the geometric transformations - translate, rotate and scale. 
  
  // To test the scenegraph system, we'll use the same node hierarchy as the last example,
  // but use NodeGeom's transformation properties to visualize the nodes as squares of varied size, location and color.
  // We'll again periodically toggle the visibility of a particular branch of the scenegraph (see below).
  
  // At this stage, NodeGeom only draws squares. After this, we'll look at how a variety of geometries are created, stored and drawn
  // in OpenGL, leading towards a generic geometry container based on NodeGeom.
  
  size( 500, 500, OPENGL );
  
  root = new NodeGeom();
  root.setName( "root" );
  root.setColor( color( 255, 255, 255 ) );
  root.setPosition( new PVector( 0.0, 0.0, 0.0 ) );
  root.setSideLength( 50.0 );
  
  NodeGeom childA = new NodeGeom();
  childA.setName( "childA" );
  childA.setColor( color( 255, 0, 0 ) );
  childA.setPosition( new PVector( -100.0, 0.0, 0.0 ) );
  childA.setSideLength( 25.0 );
  root.addChild( childA );
  
  NodeGeom childB = new NodeGeom();
  childB.setName( "childB" );
  childB.setColor( color( 0, 255, 0 ) );
  childB.setPosition( new PVector( 0.0, 100.0, 0.0 ) );
  childB.setSideLength( 25.0 );
  root.addChild( childB );
  
  NodeGeom childC = new NodeGeom();
  childC.setName( "childC" );
  childC.setColor( color( 0, 0, 255 ) );
  childC.setPosition( new PVector( 100.0, 0.0, 0.0 ) );
  childC.setSideLength( 25.0 );
  root.addChild( childC );
  
  NodeGeom childA1 = new NodeGeom();
  childA1.setName( "childA1" );
  childA1.setColor( color( 255, 128, 0 ) );
  childA1.setPosition( new PVector( -50.0, 0.0, 0.0 ) );
  childA1.setSideLength( 12.5 );
  childA.addChild( childA1 );
  
  NodeGeom childA2 = new NodeGeom();
  childA2.setName( "childA2" );
  childA2.setColor( color( 255, 0, 128 ) );
  childA2.setPosition( new PVector( 0.0, 50.0, 0.0 ) );
  childA2.setSideLength( 12.5 );
  childA.addChild( childA2 );
  
  NodeGeom childB1 = new NodeGeom();
  childB1.setName( "childB1" );
  childB1.setColor( color( 0, 255, 128 ) );
  childB1.setPosition( new PVector( 0.0, 50.0, 0.0 ) );
  childB1.setSideLength( 12.5 );
  childB.addChild( childB1 );
  
  NodeGeom childC1 = new NodeGeom();
  childC1.setName( "childC1" );
  childC1.setColor( color( 0, 128, 255 ) );
  childC1.setPosition( new PVector( 50.0, 0.0, 0.0 ) );
  childC1.setSideLength( 12.5 );
  childC.addChild( childC1 );
  
  NodeGeom childA1A = new NodeGeom();
  childA1A.setName( "childA1A" );
  childA1A.setColor( color( 255, 128, 128 ) );
  childA1A.setPosition( new PVector( -25.0, 0.0, 0.0 ) );
  childA1A.setSideLength( 6.25 );
  childA1.addChild( childA1A );
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( width/2, height/2, 0.0 );
  // Draw the scenegraph
  root.draw();
  // Increment the root node's rotation
  // The root's children will rotate with it
  root.getRotation().z += 0.01;
  
  if( frameCount % 60 == 0 ) {
    println("-----------------");
    // Print the scenegraph
    root.print( 0 );
    // Toggle childA's visibility
    NodeGeom childA = (NodeGeom)root.getChild( 0 );
    // NodeGeom's getChild() method will safely prevent invalid array access,
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
