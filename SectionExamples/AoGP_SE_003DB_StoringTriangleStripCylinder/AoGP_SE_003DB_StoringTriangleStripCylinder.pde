// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: D (Part B)
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriStripContainer   cylinderContainer;

float               mProfileRadius, mCylinderLen;
int                 subdivisionsU, subdivisionsV;

float               deltaThetaU;
int                 currU, currV;
boolean             goRight, stepA, reachedEnd;

PVector             mCamEye;
float               mCamProfileRadiusMult;

void reset() {
  // Reset cylinder construction state variables
  reachedEnd = false;
  goRight    = true;
  stepA      = true;
  currU      = 0;
  currV      = 0;

  // Compute the angle between each vertex in a profile
  deltaThetaU = TWO_PI/subdivisionsU;

  // Clear the container, in case it contained any previous points
  cylinderContainer.clear();

  // Set initial camera position
  mCamEye = new PVector( mProfileRadius * mCamProfileRadiusMult, 0.0, 0.0 );
}

void setup() {
  // Now that we have a technique for generating a 2D triangle strip mesh, we can
  // extend the method to other geometries such as the cylinder, cone, torus and sphere.
  // We use the same logic in UV space as we did for the 2D mesh, but we now add the
  // additional step of mapping UV space coordinates onto 3D XYZ vertex coordinates. 
  // To produce a cylinder, we simply need to roll the flat mesh around a circular 
  // profile in one axis. We'll use the same sine and cosine technique to position 
  // vertices as we did in the n-sided polygon example. 
  
  size( 800, 600, OPENGL );
  
  // Set the radius of the cylinder
  mProfileRadius = 100.0;
  // Set the length of the cylinder
  mCylinderLen   = 200.0;

  // Set the number of subdivisions around each circular profile
  subdivisionsU  = 40;
  // Set the number of profiles in the cylinder
  subdivisionsV  = 10;

  // Set the camera's radius multiplier
  mCamProfileRadiusMult = 5.0;

  // Initialize triangle strip container and construction variables
  cylinderContainer = new TriStripContainer();
  reset();
}

void draw() {
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  pushMatrix();
  // We'll look more closely at how cameras work in a later section example
  beginCamera();
  camera( mCamEye.x, mCamEye.y-200.0, mCamEye.z, 0.0, mCamEye.y, 0.0, 0.0, 1.0, 0.0 );

  // Draw origin tri-axis
  strokeWeight(3);
  stroke(255, 0, 0);
  line( 0.0, 0.0, 0.0, 100.0, 0.0, 0.0 );
  stroke(0, 255, 0);
  line( 0.0, 0.0, 0.0, 0.0, 100.0, 0.0 );
  stroke(0, 0, 255);
  line( 0.0, 0.0, 0.0, 0.0, 0.0, 100.0 );

  // Draw mesh
  cylinderContainer.draw();

  println("Index " + (currV*subdivisionsU + currU) + ":\t {" + currU + "," + currV + "}\t Direction: " + (goRight?"Right":"Left") + "\t Step: " + (stepA?"A":"B") );

  // If we've reached the end of our mesh, as determined below, reset program.
  if( reachedEnd ) {
    println("_____");
    reset();
  }
  
  // For general notes on triangle mesh construction, see AoGP_SE_003DA.
  
  // To create a 3D cylinder, we will associate the U axis of the 2D mesh with the circumference of 
  // each of the cylinder's circular profiles and associate the V axis with the cylinder's length.
  // We could easily turn this into a cone by varying the radius of each profile in accordance with our
  // current position along the V axis.

  // We find our position along the circumference of the current profile by multiplying the angle of a 
  // single step in the circular profile by the current index in the U axis (radial axis).
  float thetaU = deltaThetaU * currU;

  // Using thetaU, we find the coordinates of the current point in relation to the center of the current profile
  // and then multiply these coordinates by the profile radius to size it appropriately.
  // Here we are thinking of the current profile as a circle inscribed in a plane spanning the X and Z axes.
  float x = mProfileRadius * cos( thetaU );
  float z = mProfileRadius * sin( thetaU );

  // We find the y-value of the current vertex by computing the length of one cylinder segment
  // and then multiplying this by current index in the V axis (non-radial axis) of our mesh.
  float y = ( mCylinderLen / subdivisionsV ) * currV;

  // Set camera position
  mCamEye.x = x * mCamProfileRadiusMult;
  mCamEye.z = z * mCamProfileRadiusMult;
  if(y > mCamEye.y) {
    mCamEye.y = y;
  }

  // Add the current vertex to the triangle strip container
  // Notice, we are not sharing vertices here. We'll need to address this issue in a later implementation! (See note in 003DA)
  PVector currVert = new PVector( x, y, z );
  cylinderContainer.addVertex( currVert );

  // Handle row endings when necessary:
  // We need to determine whether we are at the last column in the row given the direction we're traveling.
  // There are two V values that will be enumerated for the final currU, we want the second of these value, step B.
  if( !stepA && ( (goRight && currU == subdivisionsU) || (!goRight && currU == 0) ) ) {
    // When turning around, we add the last point again as a pivot and reverse normal.
    cylinderContainer.addVertex( currVert );
    cylinderContainer.addVertex( currVert );
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

  endCamera();
  popMatrix();
}

