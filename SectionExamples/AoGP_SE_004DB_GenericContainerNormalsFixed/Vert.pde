// Class: Vert
// Description: A container object storing data relevant to the representation of an individual vertex.
// Purpose: In order to assist the creation and intuitive manipulation of geometries, there are 
// several points of information that we should store for each vertex in addition to its position.
// This includes the 2D UV coordinates used in mesh initialization and texture mapping. We also store a list of the 
// triangles of which the vertex is a member as well as a normal vector, which represents the "orientation" 
// of the vertex and is necessary for proper lighting calculations. Since a single point in space, by definition,
// has no dimension, its orientation is a bit of an abstraction. We determine the vertex normal by aggregating
// the surface normals of the triangles of which the vertex is a component. For this reason, it is important
// that we've already cross-referenced vertices with mTriangleSet. To further simplify calculations of this kind,
// we've added computeNormal() and getConnectedVertices().

import java.util.Set;

class Vert {
  PVector   mPosition;
  PVector   mNormal;
  PVector   mUV;
  
  Set<Tri>  mTriangleSet;
    
  Vert() {
    mPosition    = new PVector( 0.0, 0.0, 0.0 );
    mNormal      = new PVector( 0.0, 0.0, 0.0 );
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
  
  Set<Vert> getConnectedVertices() {
    // Return the set of vertices that are connected
    // to this one by one or more triangles in mTriangleSet
    Set<Vert> tConnected = new HashSet();
    Iterator it = mTriangleSet.iterator();
    while( it.hasNext() ) {
      Tri currTri = (Tri)it.next();
      for(int i = 0; i < 3; i++) {
        tConnected.add( currTri.getVertex(i) );
      }
    } 
    return tConnected;
  }
  
  void computeNormal() {
    // For the 2D and 3D primitives, it is generally straight-forward to compute the vertex normal.
    // For a sphere, each vertex normal can be computed as the normalized vector between the sphere's center and the given vertex position.
    // With many complex geometries, such as our Perlin terrain, vertex normals are harder to compute.
    // First we get the surface normal for every triangle of which the current vertex is a part.
    // (TMeshFactory inserts the necessary connections into mTriangleSet when the geometry is initialized.)
    // We sum all connected surface normals
    PVector tNormal = new PVector( 0.0, 0.0, 0.0 );
    Iterator it = mTriangleSet.iterator();
    while( it.hasNext() ) {
      Tri currTri = (Tri)it.next();
      tNormal.add( currTri.getSurfaceNormal() );
    } 
    // Then normalize this sum and set the normal value
    tNormal.normalize();
    mNormal.set(tNormal);
    // We could use this function with all of our TMeshFactory methods, 
    // but when normal value is obvious, it is more efficient to skip this process.
  }
  
  void reverseNormal() {
    mNormal.mult( -1.0 );
  }
  
  void setNormal(PVector iNormal) {
    mNormal.set( iNormal );
  }
  
  PVector getNormal() {
    return mNormal;
  }
  
  void setUV(float iU, float iV) {
    // Set the 2D UV coordinate
    mUV.set( iU, iV, 0.0 );
  }
  
  PVector getUV() {
    return mUV;
  }
}
