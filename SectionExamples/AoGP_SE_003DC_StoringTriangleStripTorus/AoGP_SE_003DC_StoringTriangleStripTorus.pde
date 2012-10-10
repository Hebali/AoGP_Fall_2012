// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: D (Part C)
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriStripContainer   torusContainer;

float               mProfileRadius, mTorusRadius;
int                 subdivisionsU, subdivisionsV;

float               deltaThetaU, deltaThetaV;
int                 currU, currV, highV;
boolean             goRight, stepA, reachedEnd;

PVector             mCamEye, mCamDir;
float               mCamRadiusMult;

void reset() {
  // Reset torus construction state variables
  reachedEnd = false;
  goRight    = true;
  stepA      = true;
  currU      = 0;
  currV      = 0;
  highV      = currV;

  // Compute the angle between each vertex in a profile
  deltaThetaU = TWO_PI/subdivisionsU;
  
  // Compute the angle between each profile
  deltaThetaV = TWO_PI/subdivisionsV;

  // Clear the container, in case it contained any previous points
  torusContainer.clear();

  // Set initial camera position and viewing direction
  mCamEye = new PVector( mTorusRadius * mCamRadiusMult, 0.0, 0.0 );
  mCamDir = new PVector( 0.0, 0.0, 0.0 );
}

void setup() {
  // In the previous example, we rolled the triangle strip mesh's U axis around
  // a circular profile to create a cylinder. We extend this concept into the V
  // axis to create a torus. This will be a bit trickier because, unlike the
  // cylinder, the circular profiles of a torus are not parallel to one another.
  // Therefore, while we iterate the vertices of each profile around a circle
  // using sine and cosine, we also have to rotate each profile around the center
  // of the torus. We'll use a method called rotateAroundAxis() to achieve this.
  // See below.
  
  size( 800, 600, OPENGL );
  
  // Set the number of subdivisions around each circular profile
  subdivisionsU  = 10;
  // Set the number of profiles in the torus
  subdivisionsV  = 40;
  
  // Set the radius of each profile
  mProfileRadius = 100.0;
  // Set the radius of the torus' profile centers
  mTorusRadius   = 500.0;
  
  // Set the camera's radius multiplier
  mCamRadiusMult = 2.0;

  // Initialize triangle strip container and construction variables
  torusContainer = new TriStripContainer();
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
  camera( mCamEye.x, mCamEye.y, mCamEye.z, mCamDir.x, mCamDir.y, mCamDir.z, 0.0, 1.0, 0.0 );

  // Draw origin tri-axis
  strokeWeight(3);
  stroke(255, 0, 0);
  line( 0.0, 0.0, 0.0, 100.0, 0.0, 0.0 );
  stroke(0, 255, 0);
  line( 0.0, 0.0, 0.0, 0.0, 100.0, 0.0 );
  stroke(0, 0, 255);
  line( 0.0, 0.0, 0.0, 0.0, 0.0, 100.0 );

  // Draw mesh
  torusContainer.draw();

  println("Index " + (currV*subdivisionsU + currU) + ":\t {" + currU + "," + currV + "}\t Direction: " + (goRight?"Right":"Left") + "\t Step: " + (stepA?"A":"B") );

  // If we've reached the end of our mesh, as determined below, reset program.
  if( reachedEnd ) {
    println("_____");
    reset();
  }
  
  // For general notes on triangle mesh construction, see AoGP_SE_003DA.

  // We find our position along the circumference of the current profile by
  // multiplying the angle of a single step in the circular profile by the current index in the U axis (radial axis).
  float thetaU = deltaThetaU * currU;
  float thetaV = deltaThetaV * currV;
  
  // Calculate the current position along the circumference of the torus, this will be the center point of the current profile
  PVector currProfileCenter = new PVector( mTorusRadius * cos( thetaV ), 0.0, mTorusRadius * sin( thetaV ) );
  // Compute the vector between the next profile center point and the current one
  PVector dirToNextCenter = currProfileCenter.get();
  dirToNextCenter.sub(new PVector( mTorusRadius * cos( thetaV+deltaThetaV ), 0.0, mTorusRadius * sin( thetaV+deltaThetaV ) ));
  dirToNextCenter.normalize();
  // Get the up axis for the plane upon which the current profile resides.
  // We can find this by taking the cross product of our vector between profiles centers and a vector traveling along the y-axis, 
  // which in our case, is the axis of rotation for the placement of profile centers.
  PVector upVec = dirToNextCenter.cross(new PVector(0.0,1.0,0.0));
  upVec.normalize();
  upVec.mult(mProfileRadius);  
  // Compute the position of the current vertex on the profile plane.
  // We can think of the rotateAroundAxis() function as being somewhat like a clock:
  // upVec represents the direction of the hour hand is pointing.
  // dirToNextCenter represents the center peg, which holds the clock's hand in place.
  // When we turn this center peg, the hour hand rotates around the face of the clock.
  PVector currVert = rotateAroundAxis( upVec, dirToNextCenter, thetaU );
  // Now we need position the current vertex in relation to the current profile's center point.
  currVert.add(currProfileCenter);
  // Add the current vertex to the triangle strip container
  // Notice, we are not sharing vertices here. We'll need to address this issue in a later implementation! (See note in 003DA)
  torusContainer.addVertex( currVert );
  
  // Set camera position
  if(currV > highV) {
    highV = currV;
  }
  float camThetaV = deltaThetaV * (highV+1);
  mCamEye = new PVector( cos(camThetaV), 0.0, sin(camThetaV) );
  mCamEye.normalize();
  mCamEye.mult( mTorusRadius * mCamRadiusMult );
  mCamEye.y -= 300.0;

  // Handle row endings when necessary:
  // We need to determine whether we are at the last column in the row given the direction we're traveling.
  // There are two V values that will be enumerated for the final currU, we want the second of these value, step B.
  if( !stepA && ( (goRight && currU == subdivisionsU) || (!goRight && currU == 0) ) ) {
    // When turning around, we add the last point again as a pivot and reverse normal.
    torusContainer.addVertex( currVert );
    torusContainer.addVertex( currVert );
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
