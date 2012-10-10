// Class: Vert
// Description: A container object storing data relevant to the representation of an individual vertex.
// Purpose: In order to assist the creation and intuitive manipulation of geometries, there are 
// several points of information that we should store for each vertex in addition to its position.
// This includes the 2D UV coordinates used in mesh initialization and texture mapping.
// We also store a list of the triangles of which the vertex is a member. This will help us manipulate polygons
// in a more straight-forward manner. As we add additional functionality to the TMesh class, we will add new 
// features to the Vert class as well.

import java.util.Set;

class Vert {
  PVector   mPosition;
  PVector   mUV;
  
  Set<Tri>  mTriangleSet;
    
  Vert() {
    mPosition    = new PVector( 0.0, 0.0, 0.0 );
    mUV          = new PVector( 0.0, 0.0 );
    mTriangleSet = new HashSet();
  }
  
  void addTriangleRef(Tri iTriangle) {
    // Store references to the triangles that
    // contain this vertex
    mTriangleSet.add( iTriangle );
  }
  
  void setPosition(PVector iPosition) {
    mPosition.set( iPosition );
  }
  
  PVector getPosition() {
    return mPosition;
  }
  
  void setUV(float iU, float iV) {
    // Set the 2D UV coordinate
    mUV.set( iU, iV, 0.0 );
  }
  
  PVector getUV() {
    return mUV;
  }
}
