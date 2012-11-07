// Class: TMeshFactory
// Description: A helper class for the construction of geometric primitives.
// Purpose: Building on the SE_003 example stages, the TMeshFactory class
// encapsulates mesh, terrain, cylinder, cone, torus, and sphere generators
// in a straight-forward API. (Cube coming soon) Each method returns a pre-built
// TMesh object based on the input specifications. In addition to UV and vertex positioning,
// TMeshFactory also handles the automatic generation of vertex normals. For some primitives,
// this is done using Vert's computeNormal() method and in other cases a simpler, less 
// computationally-heavy approach is taken. In the initMesh() method, we've reconfigured the
// vertex order for the triangles within each rectangular subdivision.

class TMeshFactory {
  Globals mGlobals;
  
  TMeshFactory(Globals iGlobals) {
    mGlobals = iGlobals;
  }
  
  TMesh createMesh(int iDimU, int iDimV, float iLengthU, float iLengthV) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    // Center the mesh about the TMesh's origin
    float halfLenU = iLengthU/2.0;
    float halfLenV = iLengthV/2.0;
    
    // Set vertex positions and normals
    int vCount = tMesh.mVertices.size();
    for(int i = 0; i < vCount; i++) {
      PVector currUV = tMesh.mVertices.get(i).getUV();
      tMesh.mVertices.get(i).setPosition( new PVector( currUV.x * iLengthU - halfLenU, currUV.y * iLengthV - halfLenV, 0.0 ) );
      tMesh.mVertices.get(i).setNormal( new PVector( 0.0, 0.0, 1.0 ) );
    }
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createTerrain(int iDimU, int iDimV, float iLengthU, float iLengthV, float iMinHeight, float iMaxHeight, int iOctaves, float iFalloff) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    // Center the mesh about the TMesh's origin
    float halfLenU = iLengthU/2.0;
    float halfLenV = iLengthV/2.0;
    
    // Set perlin noise properties
    noiseDetail( iOctaves, iFalloff );
    
    // Set vertex positions
    int vCount = tMesh.mVertices.size();
    for(int i = 0; i < vCount; i++) {
      PVector currUV  = tMesh.mVertices.get(i).getUV();
      float tHeight   = map( noise( currUV.x,  currUV.y ), 0.0, 1.0, iMinHeight, iMaxHeight );
      PVector currPos = new PVector( currUV.x * iLengthU - halfLenU, tHeight , currUV.y * iLengthV - halfLenV );
      tMesh.mVertices.get(i).setPosition( currPos );
    }
    // Compute normals
    for(int i = 0; i < vCount; i++) {
      tMesh.mVertices.get(i).computeNormal();
    }
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createCylinder(int iDimU, int iDimV, float iProfileRadius, float iLength) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    int vCount = tMesh.getVertexCount();
    for(int i = 0; i < vCount; i++) {
      // Get current UV
      PVector currUV = tMesh.mVertices.get(i).getUV();
      
      // We find our position along the circumference of the current profile by
      // lerping the U coordinate (radial axis) in the range 0.0 .. 2PI
      float thetaU = TWO_PI * currUV.x;
      
      // Using thetaU, we find the coordinates of the current point in relation to the center of the current profile
      // and then multiply these coordinates by the profile radius to size it appropriately.
      // Here we are thinking of the current profile as a circle inscribed in a plane spanning the X and Y axes.
      float x = iProfileRadius * cos(thetaU);
      float y = iProfileRadius * sin(thetaU);
    
      // We find the z-value of the current vertex by computing the length of one cylinder segment
      // and then multiplying this by current index in the V axis (non-radial axis) of our mesh.
      // Also, subtract half the cylinder's length to center about the origin.
      float z = iLength * currUV.y - iLength/2.0;

      // Set vertex position
      tMesh.mVertices.get(i).setPosition( new PVector( x, y, z ) );
      
      // Set vertex normal
      PVector currNorm = new PVector( x, y, 0.0 );
      currNorm.normalize();
      tMesh.mVertices.get(i).setNormal( currNorm );
    }
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createCone(int iDimU, int iDimV, float iBaseRadius, float iLength) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    // A cone is much like a cylinder, except that its radius tapers to zero as we move down its length.
    
    int vCount = tMesh.getVertexCount();
    for(int i = 0; i < vCount; i++) {
      // Get current UV
      PVector currUV = tMesh.mVertices.get(i).getUV();
      
      // We find our position along the circumference of the current profile by
      // lerping the U coordinate (radial axis) in the range 0.0 .. 2PI
      float thetaU = TWO_PI * currUV.x;
      
      // Using thetaU, we find the coordinates of the current point in relation to the center of the current profile
      // and then multiply these coordinates by the profile radius to size it appropriately.
      // Here we are thinking of the current profile as a circle inscribed in a plane spanning the X and Y axes.
      // Taper the radius of each profile based on our position along the V axis
      float x = (iBaseRadius * currUV.y) * cos(thetaU);
      float y = (iBaseRadius * currUV.y) * sin(thetaU);
    
      // We find the z-value of the current vertex by computing the length of one cylinder segment
      // and then multiplying this by current index in the V axis (non-radial axis) of our mesh.
      // Also, subtract half the cylinder's length to center about the origin.
      float z = iLength * currUV.y - iLength/2.0;

      // Set vertex position
      tMesh.mVertices.get(i).setPosition( new PVector( x, y, z ) );
    }
    // Compute normals
    for(int i = 0; i < vCount; i++) {
      tMesh.mVertices.get(i).computeNormal();
    }
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createTorus(int iDimU, int iDimV, float iProfileRadius, float iTorusRadius) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    // This method of building a torus will center the geometry about the origin.
    
    int vCount = tMesh.getVertexCount();
    for(int i = 0; i < vCount; i++) {
      // Get current UV
      PVector currUV = tMesh.mVertices.get(i).getUV();
      
      // We find our position along the circumference of the current profile by
      // multiplying the angle of a single step in the circular profile by the current index in the U axis (radial axis).
      float thetaU  = TWO_PI * currUV.x;
      float thetaV  = TWO_PI * currUV.y;
      
      float thetaUn = TWO_PI * (currUV.x * (tMesh.dimensionU - 1) + 1.0) / (tMesh.dimensionU - 1);
      float thetaVn = TWO_PI * (currUV.y * (tMesh.dimensionV - 1) + 1.0) / (tMesh.dimensionV - 1);
      
      // Calculate the current position along the circumference of the torus, this will be the center point of the current profile
      PVector currProfileCenter = new PVector( iTorusRadius * cos(thetaV), iTorusRadius * sin(thetaV), 0.0 );
      // Compute the vector between the next profile center point to the current one
      PVector dirToNextCenter = currProfileCenter.get();
      dirToNextCenter.sub(new PVector( iTorusRadius * cos(thetaVn), iTorusRadius * sin(thetaVn), 0.0 ));
      dirToNextCenter.normalize();
      
      // Get the up axis for the plane upon which the current profile resides.
      // We can find this by taking the cross product of our vector between profiles centers and a vector traveling along the z-axis, 
      // which is the axis of rotation for the placement of profile centers.
      PVector upVec = dirToNextCenter.cross(new PVector(0.0,0.0,1.0));
      upVec.normalize();
      upVec.mult(iProfileRadius);  
      
      // Compute the position of the current vertex on the profile plane.
      // We can think of the rotateAroundAxis() function as being somewhat like a clock:
      // upVec represents the direction of the hour hand is pointing.
      // dirToNextCenter represents the center peg, which holds the clock's hand in place.
      // When we turn this center peg, the hour hand rotates around the face of the clock.
      PVector currPoint = rotateAroundAxis( upVec, dirToNextCenter, thetaU );
      
      // Set normal
      PVector currNorm = currPoint.get();
      currNorm.normalize();
      tMesh.mVertices.get(i).setNormal( currNorm );
      // Now we need position the current vertex in relation to the current profile's center point.
      currPoint.add(currProfileCenter);
      // Set vertex position
      tMesh.mVertices.get(i).setPosition( currPoint );
    }
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createSphere(int iDimU, int iDimV, float iRadius) {
    // Initialize a basic mesh
    TMesh tMesh = initMesh( iDimU, iDimV );
    
    // This method of building a sphere will center the geometry about the origin.
    
    int vCount = tMesh.getVertexCount();
    for(int i = 0; i < vCount; i++) {
      // Get current UV
      PVector currUV = tMesh.mVertices.get(i).getUV();
      
      // Find the current angle within the current longitudinal profile
      float thetaU  = TWO_PI * currUV.x;
      // Find the current angle within the latitudinal arc, 
      // offseting by a quarter circle (HALF_PI) so that we start at the pole
      // rather than the equator
      float thetaV  = PI * currUV.y - HALF_PI;
      
      // Compute the current position on the surface of the sphere
      float x = iRadius * cos(thetaV) * cos(thetaU);
      float y = iRadius * cos(thetaV) * sin(thetaU);
      float z = iRadius * sin(thetaV);
      tMesh.mVertices.get(i).setPosition( new PVector( x, y, z ) );
      
      // Set normal
      PVector currNorm = new PVector( x, y, z );
      currNorm.normalize();
      tMesh.mVertices.get(i).setNormal( currNorm );
    }
    
    // Compute bounding box for mesh geometry
    tMesh.computeBounds();
    // Initialize accelerated model
    initModelAcceleration( tMesh );
    // Return the geometry
    return tMesh;
  }
  
  TMesh createCube(int dimW, int dimH, int dimD, float lengthW, float lengthH, float lengthD) {
    return null; // TODO!!
  }
  
  TMesh initMesh(int iDimensionU, int iDimensionV) {
    TMesh tMesh = new TMesh( mGlobals );
    
    // Initialize the mesh for the given UV dimensions
    // Notice that we do not set vertex positions within this method.
    // We setup our UV coordinates and create the connections necessary
    // to access data in vertex, triangle or triangle strip format.
    
    // Mesh must have at least 2 points per axis
    iDimensionU = max(iDimensionU,2);
    iDimensionV = max(iDimensionV,2);
    // Set mesh dimensions
    tMesh.dimensionU = iDimensionU;
    tMesh.dimensionV = iDimensionV;
    
    // Initialize vertices and setup the mesh UV coordinates
    for(int v = 0; v < iDimensionV; v++) {
      for(int u = 0; u < iDimensionU; u++) {
        Vert cVert = new Vert();
        cVert.setUV( (float)u/(iDimensionU - 1), (float)v/(iDimensionV - 1) );  
        tMesh.mVertices.add( cVert );
      }
    }
    
    // Setup subdivisions (triangles and triangle strip)
    for(int v = 0; v < iDimensionV - 1; v++) {
      // Determine the direction of the current row
      boolean goingRight = (v % 2 == 0);
      
      // Find the indices for the first and last column of the row
      int firstCol = 0;
      int lastCol  = iDimensionU - 1;
      
      // Get the current column index, direction dependent
      int u = ( goingRight ) ? ( firstCol ) : ( lastCol );
      
      // Iterate over each column in the row
      boolean rowComplete = false;
      while( !rowComplete ) {
        // For each column, determine the indices of the current rectangular subdivision
        // This depends on whether we're going right or left in the current row
        int iA, iB, iC, iD;
        if( goingRight ) {
          // Rightward triangles cba, bcd:
          // a   c
          // 
          // b   d
          //
          // Note the vertex order abc/cba and bcd/dcb is important for correct surface normal orientation
        
          // Get the four indices of the current subdivision
          iA = (v) * (iDimensionU) + (u);
          iB = (v + 1) * (iDimensionU) + (u);
          iC = (v) * (iDimensionU) + (u + 1);
          iD = (v + 1) * (iDimensionU) + (u + 1);
          
          // Add the two triangles of the current subdivision
          Tri iCBA = new Tri( tMesh.mVertices.get( iC ), tMesh.mVertices.get( iB ), tMesh.mVertices.get( iA ), iC, iB, iA );
          tMesh.mTriangles.add( iCBA );
          Tri iBCD = new Tri( tMesh.mVertices.get( iB ), tMesh.mVertices.get( iC ), tMesh.mVertices.get( iD ), iB, iC, iD );
          tMesh.mTriangles.add( iBCD );
        }
        else {
          // Leftward triangles abc, dcb
          // c   a
          // 
          // d   b
          //
          // Note the vertex order abc/cba and bcd/dcb is important for correct surface normal orientation
          
          // Get the four indices of the current subdivision
          iA = (v) * (iDimensionU) + (u);
          iB = (v + 1) * (iDimensionU) + (u);
          iC = (v) * (iDimensionU) + (u - 1);
          iD = (v + 1) * (iDimensionU) + (u - 1);
          
          // Add the two triangles of the current subdivision
          Tri iABC = new Tri( tMesh.mVertices.get( iA ), tMesh.mVertices.get( iB ), tMesh.mVertices.get( iC ), iA, iB, iC );
          tMesh.mTriangles.add( iABC );
          Tri iDCB = new Tri( tMesh.mVertices.get( iD ), tMesh.mVertices.get( iC ), tMesh.mVertices.get( iB ), iD, iC, iB );
          tMesh.mTriangles.add( iDCB );          
        }
        
        // Add the four indices of current subdivision to triangle strip
        tMesh.mTriStrip.add( iA );
        tMesh.mTriStrip.add( iB );
        tMesh.mTriStrip.add( iC );
        tMesh.mTriStrip.add( iD );
        
        // Iterate through each column in the row, direction dependent 
        if( goingRight ) {
          u++;
        }
        else {
          u--;
        }
        
        // Check whether we've reached the end of the row
        if( ( goingRight && u == lastCol ) || ( !goingRight && u == firstCol ) ) {
          // At the end of the row, add last index of current subdivision
          // two more times to create "degenerate triangles"
          tMesh.mTriStrip.add( iD );
          tMesh.mTriStrip.add( iD );
          // Prepare to exit row
          rowComplete = true;
        }
      }
    }
    return tMesh;
  }
  
  void initModelAcceleration(TMesh iMesh) {
    // Once the model's geomtric data has been prepared on the CPU side,
    // we can pass it into our GLModel object, which contains a special kind of pointer
    // to a Vertex Buffer Object that will live on the GPU. This will greatly reduce the
    // amount of computation and data transfer on the CPU side during draw() routines.
    // Notice below that as before, we can instatiate the mode in triangle-strip or triangle
    // mode (as well as others). We will still maintain a copy of the geometric data on the CPU side,
    // but this copy will not be regularly accessed within the draw() routine. However, when we add
    // the ability to animate and further manipulate the mesh geometry, maintaining this CPU side representation
    // will make the data easier to work with and will also prevent the high-cost operation of having to copy
    // geometric data back to the CPU from the GPU.
    
    int tVertCount = iMesh.getVertexCount();
    
    if( iMesh.mDrawMode == TRISTRIP_MODE ) {
      iMesh.mModel = new GLModel( mGlobals.mApplet, tVertCount, TRIANGLE_STRIP, GLModel.DYNAMIC);
    }
    else if( iMesh.mDrawMode == TRIANGLE_MODE ) {
      iMesh.mModel = new GLModel( mGlobals.mApplet, tVertCount, TRIANGLES, GLModel.DYNAMIC);
    }

    // Update vertices 
    iMesh.mModel.beginUpdateVertices();
    for(int i = 0; i < tVertCount; i++) {
      PVector cPos = iMesh.mVertices.get( i ).getPosition();
      iMesh.mModel.updateVertex( i, cPos.x, cPos.y, cPos.z );
    }
    iMesh.mModel.endUpdateVertices();
    // Update normals
    iMesh.mModel.initNormals();
    iMesh.mModel.beginUpdateNormals();
    for(int i = 0; i < tVertCount; i++) {
      PVector cNorm = iMesh.mVertices.get( i ).getNormal();
      iMesh.mModel.updateNormal( i, cNorm.x, cNorm.y, cNorm.z );
    }
    iMesh.mModel.endUpdateNormals();
    
    // Enable vertex coloring
    iMesh.mModel.initColors();
    iMesh.mModel.setColors(255);
    
    // Update texture coords (currently supports 1 texture per model)
    iMesh.mModel.initTextures(1);
    iMesh.mModel.setTexture( 0, iMesh.mTextureGl );
    
    // Update tex coords
    iMesh.mModel.beginUpdateTexCoords(0);
    for(int i = 0; i < tVertCount; i++) {
      PVector cUV = iMesh.mVertices.get( i ).getUV();
      iMesh.mModel.updateTexCoord( i, cUV.x, cUV.y );
    }
    iMesh.mModel.endUpdateTexCoords();
      
    // Generate triangle strip
    if( iMesh.mDrawMode == TRISTRIP_MODE ) {
      int tsIndexCount = iMesh.getTriangleStripIndexCount();
      int[] tsIndexArr = new int[tsIndexCount];
      for(int i = 0; i < tsIndexCount; i++) {
        tsIndexArr[i] = iMesh.mTriStrip.get(i);
      }
      iMesh.mModel.initIndices( tsIndexCount );
      iMesh.mModel.updateIndices( tsIndexArr );
    }
    // Generate triangles
    else if( iMesh.mDrawMode == TRIANGLE_MODE ) {
      int triCount = iMesh.getTriangleCount();
      int[] triIndexArr = new int[triCount * 3];
      for(int i = 0; i < triCount; i++) {
        Tri currTri = iMesh.mTriangles.get(i);
        for(int j = 0; j < 3; j++) {
          triIndexArr[i * 3 + j] = currTri.getVertexIndex(j);
        }
      }
      iMesh.mModel.initIndices( triCount * 3 );
      iMesh.mModel.updateIndices( triIndexArr );
    }
  }
  
  PVector rotateAroundAxis(PVector vec, PVector a, float t) {
    float s = sin(t);
    float c = cos(t);
    PVector u = new PVector(a.x*vec.x,a.x*vec.y,a.x*vec.z);
    PVector v = new PVector(a.y*vec.x,a.y*vec.y,a.y*vec.z);
    PVector w = new PVector(a.z*vec.x,a.z*vec.y,a.z*vec.z);
    PVector out = new PVector(a.x * (u.x + v.y + w.z) + (vec.x * (a.y * a.y + a.z * a.z) - a.x * (v.y + w.z)) * c + (v.z - w.y) * s,
  		              a.y * (u.x + v.y + w.z) + (vec.y * (a.x * a.x + a.z * a.z) - a.y * (u.x + w.z)) * c + (w.x - u.z) * s,
  			      a.z * (u.x + v.y + w.z) + (vec.z * (a.x * a.x + a.y * a.y) - a.z * (u.x + v.z)) * c + (u.y - v.x) * s);
    return out;       
  }
}
