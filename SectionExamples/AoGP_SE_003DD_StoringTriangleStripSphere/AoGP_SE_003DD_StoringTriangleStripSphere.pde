// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: D (Part D)
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriStripContainer   sphereContainer;

float               mSphereRadius;
int                 subdivisionsU, subdivisionsV;

float               deltaThetaU, deltaThetaV;
int                 currU, currV, highV;
boolean             goRight, stepA, reachedEnd;

PVector             mCamEye, mCamDir;
float               mCamRadiusMult;

void reset() {
  // Reset sphere construction state variables
  reachedEnd = false;
  goRight    = true;
  stepA      = true;
  currU      = 0;
  currV      = 0;
  highV      = currV;
  
  // Compute the angle between each vertex in a profile (longitude)
  // Each longitudinal profile is a full circle, so as with earlier
  // examples we divide TWO_PI (360 degrees) into the number of subdivisions
  deltaThetaU = TWO_PI/subdivisionsU;
  
  // Compute the angle between each profile (latitude)
  // The arc from north pole to south pole is a half circle
  // So we divide PI (180 degrees) into the number of subdivisions
  deltaThetaV = PI/subdivisionsV;

  // Clear the container, in case it contained any previous points
  sphereContainer.clear();

  // Set initial camera position and viewing direction
  mCamEye = new PVector( 0.0, 0.0, 0.0 );
  mCamDir = new PVector( 0.0, 0.0, 0.0 );
}

void setup() {
  // Next we'll extend the technique used in previous stages to create
  // a sphere. We use the same UV construction method, but here we treat
  // the U axis as longitudinal points along a circular profile and treat
  // the V axis as latitudinal points between the sphere's poles.
  // In looking at each successive stage of the triangle strip example, it
  // is clear that the only difference between our mesh, cylinder, torus,
  // and sphere examples is the way in which we map UV to XYZ. We could
  // easily create other geometries such as cones, half spheres, etc, by
  // tweaking these mapping parameters further. As we approach building a 
  // generalized container in the next example, we should keep this in mind and 
  // try to simplify our geometry class by consolidating the shared elements 
  // of each process into generalized construction methods.
  
  size( 800, 600, OPENGL );
  
  // Set the number of points around each circular profile (longitude)
  subdivisionsU  = 30;
  // Set the number of profiles in the sphere (latitude)
  subdivisionsV  = 30;
  
  // Set the sphere's radius
  mSphereRadius  = 500.0;
  
  // Set the camera's radius multiplier
  mCamRadiusMult = 2.0;

  // Initialize triangle strip container and construction variables
  sphereContainer = new TriStripContainer();
  reset();
}

void draw() {
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );

  pushMatrix();
  // We'll look more closely at how cameras work in later examples.
  camera( mCamEye.x, mCamEye.y, mCamEye.z, mCamDir.x, mCamDir.y, mCamDir.z, 0.0, 0.0, 1.0 );

  // Draw origin tri-axis
  strokeWeight(3);
  stroke(255, 0, 0);
  line( 0.0, 0.0, 0.0, 100.0, 0.0, 0.0 );
  stroke(0, 255, 0);
  line( 0.0, 0.0, 0.0, 0.0, 100.0, 0.0 );
  stroke(0, 0, 255);
  line( 0.0, 0.0, 0.0, 0.0, 0.0, 100.0 );

  // Draw mesh
  sphereContainer.draw();

  println("Index " + (currV*subdivisionsU + currU) + ":\t {" + currU + "," + currV + "}\t Direction: " + (goRight?"Right":"Left") + "\t Step: " + (stepA?"A":"B") );

  // If we've reached the end of our mesh, as determined below, reset program.
  if( reachedEnd ) {
    println("_____");
    reset();
  }
  
  // For general notes on triangle mesh construction, see AoGP_SE_003DA.

  // Find the current angle within the current longitudinal profile
  float thetaU = deltaThetaU * currU;
  // Find the current angle within the latitudinal arc, 
  // offseting by a quarter circle (HALF_PI) so that we start at the pole
  // rather than the equator
  float thetaV = deltaThetaV * currV - HALF_PI;
  // Compute the current position on the surface of the sphere
  float x = mSphereRadius * cos( thetaV ) * cos( thetaU );
  float y = mSphereRadius * cos( thetaV ) * sin( thetaU );
  float z = mSphereRadius * sin( thetaV );
  PVector currVert = new PVector( x, y, z );

  // Add the current vertex to the triangle strip container
  // Notice, we are not sharing vertices here. We'll need to address this issue in a later implementation! (See note in 003DA)
  sphereContainer.addVertex( currVert );
  
  // Set camera position
  if(currV > highV) {
    highV = currV;
  }
  float camThetaV = deltaThetaV * highV - HALF_PI;
  mCamEye = new PVector( mSphereRadius * mCamRadiusMult * cos( thetaU ),
                         mSphereRadius * mCamRadiusMult * sin( thetaU ),
                         mSphereRadius * mCamRadiusMult * -cos( camThetaV + 2.0 ) );
                                                  
  // Handle row endings when necessary:
  // We need to determine whether we are at the last column in the row given the direction we're traveling.
  // There are two V values that will be enumerated for the final currU, we want the second of these value, step B.
  if( !stepA && ( (goRight && currU == subdivisionsU) || (!goRight && currU == 0) ) ) {
    // When turning around, we add the last point again as a pivot and reverse normal.
    sphereContainer.addVertex( currVert );
    sphereContainer.addVertex( currVert );
    // Reset to step type A
    stepA   = true;
    // Alternate between row types
    goRight = !goRight;
    // If we are at the end of a row on a step B move in the final column,
    // then we've added the last vertex in the mesh.
    reachedEnd = (currV == subdivisionsV);
  }
  
  // In step A, we always move forward one row (V axis).
  // In step B, we always move back a row.
  // In step B, we also move one column (U axis) forward for a rightward row or one column back for a leftward row.
  if( goRight ) {
    if(stepA) {
      currV++;
    }
    else {
      currU++;
      currV--;
    }
  }
  else {
    if(stepA) {
      currV++;
    }
    else {
      currU--;
      currV--;
    }
  }
  // Alternate between step types
  stepA = !stepA;

  popMatrix();
}
