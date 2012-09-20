// Art of Graphics Programming
// Section Example 003: "Storing Geometries: Efficient, easy-to-use or both"
// Example Stage: D (Part A)
// Course Materials by Patrick Hebron

import processing.opengl.*;

TriStripContainer  triStripContainer;

float              subdivLengthU, subdivLengthV;
int                subdivisionsU, subdivisionsV;

int                currU, currV;
boolean            goRight, stepA, reachedEnd;

PFont              mFont;

void reset() {
  // Reset construction state variables
  reachedEnd = false;
  goRight    = true;
  stepA      = true;
  currU      = 0;
  currV      = 0;
  triStripContainer.clear();
}

void setup() {
  // Here's another method of producing triangle-based meshes: triangle strips. 
  // In the previous stage, we drew quad ABCD with triangles ABD and BCD.
  // This is somewhat inefficient because line BD gets drawn twice. With triangle strips, 
  // we define the vertices of triangle DAC and then add vertex B to define triangle ACB. 
  // Each additional vertex added to the strip will define another triangle.
  // As we'll see in a moment, this construction imposes certain restrictions on the
  // geometry. First, we can not represent a series of unattached triangles using a single
  // triangle strip. By definition, all triangles in the strip will be connected in sequence.
  // Also, triangle strips require us to enter triangle vertices in a particular
  // order (sometimes called the "winding order"). There is more than one viable pattern for
  // winding vertices, but each technique must be executed in precisely the right manner or
  // the strip will not render as expected. Below, we'll look at one approach to creating a 
  // triangle strip mesh using a zig-zag iteration of the rows and columns.
  
  // The technique used below is not completely optimal. As we zig-zag between vertices,
  // we touch most of the vertices more than once and create a new PVector for each instance of the
  // given vertex. Therefore, there are redundancies in the TriStripContainer's vertex list.
  // We will eventually fix this problem by using an approach similar to the technique developed
  // in the StoringBetterLinkedTriangles example. That is, the TriStripContainer should store
  // separate, cross-referenced lists of vertices and triangle strip indices. For
  // section example 003D, we'll ignore this limitation while we get a better sense of how
  // triangle strips can be applied to different geometries. We'll come back to it when we finally
  // build our generalized geometry container.
      
  // As a side note, up to this point, we've been calling our axes "X" and "Y." This makes sense
  // in a two-dimensional context. This might get confusing, however, if we wanted to create a
  // mesh that spans the X and Z axes. So, from here on, we will refer to the coordinate axes
  // of our 2D mesh as "U" and "V" in order to distinguish surface coordinates from scene coordinates.
  // This will be helpful as we move towards three-dimensional geometries, which use UV coordinates 
  // to map 2D textures onto 3D figures. 
  
  size( 500, 500, OPENGL );
  
  mFont = createFont( "Helvetica", 12 );
  textFont( mFont );
  textAlign( CENTER ); 
  
  // Set the length of a segment in each axis
  subdivLengthU = 100.0;
  subdivLengthV = 100.0;
  // Set the number of subdivisions per axis
  subdivisionsU = 5;
  subdivisionsV = 5;
  
  // Initialize triangle strip container and construction variables
  triStripContainer = new TriStripContainer();
  reset();
}

void draw() {
  // Clear window
  background( 0 );
  // Translate to center of screen
  translate( 0.0, 0.0, -40.0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  // Draw mesh
  triStripContainer.draw();
  
  // Draw the info text label
  pushMatrix();
  translate( width/2.0, -10.0, 0.0 );
  String label = ("Vertex Index: " + (currV*subdivisionsU + currU) + "\t\t Coordinate: (" + currU + "," + currV + ")\t\t Direction: " + (goRight?"Right":"Left") + "\t\t Step: " + (stepA?"A":"B") );
  text( label, 0.0, -00 );
  popMatrix();
  
  // Update animation
  if(frameCount % 30 == 0) {
    // If we've reached the end of our mesh, as determined below, reset program.
    if( reachedEnd ) {
      reset();
    }
    
    // Based on the construction technique described at:
    // http://dan.lecocq.us/wordpress/2009/12/25/triangle-strip-for-grids-a-construction
    
    // Triangle strips are, as the name suggests, a continuous strip of triangles. Each triangle
    // in the strip must pick up where the last one left off. In examples 003A-003C, we iterate
    // over each column in a given row, moving from left to right. At the end of each row,
    // we go to the first column of the next row. This method will not work for a triangle strip
    // because the end of a row does not leave off where the next row begins. If we modify this
    // pattern so that at the end of the first row, we move to the last column of the next row
    // and then iterate columns backwards, the strip will remain continuous. Then, at the end of
    // the second row, we move to the third row and again iterate the columns in a forward direction.
    // That is, in even numbered rows, we iterate columns in rightward manner and in odd 
    // numbered rows, we iterate leftward. Within each row, we need to create two triangles
    // for every rectangular subdivision of the grid. This is achieved with a repeated two step
    // process. In stepA, we move forward by one row increment. In stepB (aka !stepA), 
    // we move back by one row increment and move forward or back by one column depending on whether
    // the current row is a rightward or leftward one.
    
    // For rightward rows (goingRight):
    //   A  C
    //   | /
    //   B
    
    // For leftward rows (!goingRight):
    //   C  A
    //    \ |
    //      B
    
    // In stepA, we go from A to B. In stepB, we go from B to C.
    // Then, vertex C becomes the "A" in the next iteration of the pattern and we repeat until the end of the row.
    
    // When we reach the end of a row, we need to pivot back in the opposite direction.
    // To do this, we add the last vertex of the previous row twice. These "degenerate triangles"
    // will act as a pivot, reversing the direction in which the strip is traveling and correcting
    // the normal orientation for the next row. (We'll look at normals more closely in a later example)
    
    // Add the current vertex to the triangle strip container
    // Notice, we are not sharing vertices here. We'll need to address this issue in a later implementation! (See note above)
    PVector currVert = new PVector( subdivLengthU * currU, subdivLengthV * currV, 0.0 ); 
    triStripContainer.addVertex( currVert );
   
    // Handle row endings when necessary:
    // We need to determine whether we are at the last column in the row given the direction we're traveling.
    // There are two Y values that will be enumerated for the final currU, we want the second of these value, step B.
    if( !stepA && ( (goRight && currU == subdivisionsU) || (!goRight && currU == 0) ) ) {
      // When turning around, we add the last point again as a pivot and reverse normal.
      triStripContainer.addVertex( currVert );
      triStripContainer.addVertex( currVert );
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
  }
 
}


