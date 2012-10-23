// Art of Graphics Programming
// Section Example 005: "Optimizing Geometries"
// Example Stage: B
// Course Materials by Patrick Hebron

// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://sourceforge.net/projects/glgraphics/
import codeanticode.glgraphics.*;

SceneController mScene;

void setup() {
  // In this stage, we add a few more items to help streamline our platform's pipeline and API.
  // Namely, we add a SceneController class to wrap some of the functionality we've been placing
  // in our main setup() routine. SceneController will act as the scene's root node, 
  // store globals and eventually also store things like cameras and lights. As we look towards
  // animation properties in the next example, our program will need to handle even more data than before.
  // Therefore, we should be sure to streamline the platform's efficiency as well as its API methods
  // as much as possible to reduce complexity.
  
  // With the settings below:
  // Total UVs per model: 300 x 300 = 90,000
  // Number of Models: 30
  // 90,000 * 30 = 2.7 million vertices
 
  // It takes a moment to generate all of these geometries, but once setup() is complete,
  // we easily reach 60fps while rendering 2.7 million vertices. This is a huge performance
  // boost from our previous approach to storing and rendering geometries.
 
  // Press the 'd' key to draw debug view. Notice that the relative inefficiency of 
  // the non-VBO debugDraw() routine greatly reduces the framerate.
  
  // We now initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":
  size( 800, 600, GLConstants.GLGRAPHICS );
  
  // Initialize the SceneController. The controller will need access to the PApplet
  // object and the renderer contained within it, so we pass the PApplet in here.
  mScene = new SceneController( this );
  
  // Choose the number of UVs in the mesh
  int meshPointsU = 300;
  int meshPointsV = 300;
  // Choose a size for the mesh
  float meshRadius = 20.0;
  
  // Create some spheres by adding them as children of the scene
  int numMeshes     = 30;
  float theta       = TWO_PI/(float)numMeshes;
  float sceneRadius = 380.0;
  
  for(int i = 0; i < numMeshes; i++) {
    TMesh mesh = mScene.addSphere( meshPointsU, meshPointsV, meshRadius );
    // Center the mesh in window
    mesh.setPosition( new PVector( sceneRadius * cos(i*theta), sceneRadius* sin(i*theta), 0.0 ) );
    mesh.setRotation( new PVector( PI, 0.0, 0.0 ) );
    // Set mesh texture
    mesh.setTexture( "world32k.jpg" );
  }
}

void draw() {
  translate( width/2.0, height/2.0, -200.0 );
  rotateZ(frameCount/5.0);
  mScene.draw();
  println("fps: " + frameRate);
}

void keyReleased() {
  if( key == 'd' ) { mScene.toggleDebugMode(); }
}
