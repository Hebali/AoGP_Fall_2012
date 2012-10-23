// Art of Graphics Programming
// Section Example 005: "Optimizing Geometries"
// Example Stage: A
// Course Materials by Patrick Hebron

// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://glgraphics.sourceforge.net
import codeanticode.glgraphics.*;

TMesh   mesh;
Globals globals;

void setup() {
  // In this stage, we add the GLGraphics library, which provides easy access to some of OpenGL's more advanced
  // features and optimizations. This will require several changes throughout the code. In essence,
  // GLGraphics is circumventing Processing's standard render to provide easier access to more optimized
  // but also more complex tools within OpenGL. In previous examples, we've been computing the vertex
  // positions once, storing these values on the CPU side (in RAM) and then passing them to the graphics card
  // via OpenGL each frame. In this example, we compute the vertex positions once and then immediately pass
  // them into GPU memory by way of a GLGraphics object called a GLModel. In other OpenGL-based application
  // frameworks such as OpenFrameworks and Cinder, we might call GLModel a wrapper class for a particular type
  // of OpenGL storage unit known as a Vertex Buffer Object (VBO). A VBO stores vertex data within GPU memory, allowing
  // us to construct a rendering pipeline in which we only copy geometric data to the GPU once within the lifecycle
  // of the application. Later, when we add the ability to animate vertex positions within a mesh, we'll need to revise
  // our approach slightly, but can still prevent excessive CPU-to-GPU data transfers.
  // See TMesh and particularly the initModelAcceleration() method of TMeshFactory for additional notes.
  
  // We now initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":
  size( 800, 600, GLConstants.GLGRAPHICS );
  
  // GLGraphics requires lower-level access to some of the PApplet's properties,
  // namely the OpenGL renderer. To provide this to each node, we'll create a globals
  // class that gets passed to each node when it is initialized. 
  globals = new Globals( this );
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 100;
  int meshPointsV = 100;
  // Choose a size for the mesh
  float meshRadius = 300.0;
  
  // Create new mesh factory
  TMeshFactory meshFactory = new TMeshFactory( globals );
  
  // Create terrain
  mesh = meshFactory.createSphere( meshPointsU, meshPointsV, meshRadius );
  // Center the mesh in window
  mesh.setPosition( new PVector( width/2.0, height/2.0, -200.0 ) );
  mesh.setRotation( new PVector( PI, 0.0, 0.0 ) );
  // Set mesh texture
  mesh.setTexture( "world32k.jpg" );
}

void draw() {
  // Enter scene:
  // Since GLGraphics is circumventing Processing's usual renderer,
  // we need to tell the renderer where to begin. 
  globals.mRenderer.beginGL();
    
  // Clear window
  background( 0 );
  // Set colors
  stroke( 255, 0, 0 );
  fill( 0, 255, 0 );
  
  // Draw the mesh
  mesh.draw();
  
  // Exit scene:
  // We also need to tell the GLGraphics render where to end.
  globals.mRenderer.endGL();
}
