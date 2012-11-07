// Art of Graphics Programming
// Section Example 006: "Basic Cameras"
// Course Materials by Patrick Hebron

// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://sourceforge.net/projects/glgraphics/
import codeanticode.glgraphics.*;

SceneController  mScene;

float sceneRadius = 300.0;

void setup() {
  // In this example, we add a class to represent cameras within our environment.
  // In OpenGL, cameras come in two basic forms: "orthographic" and "perspective"
  
  // A "perspective projection" camera will produce an image similar to that of a physical pinhole camera.
  // In this model, rays converge upon a single point in space (the eye), causing depth diminishment to occur as an object
  // moves further from the camera.
  
  // An "orthographic" camera uses a non-convergent model and therefore does not represent depth diminishment.
  // Since depth diminishment has the effect of skewing an object's perceived contour, an orthographic model can
  // be useful for diagrammatic purposes in which accurate measurement of lengths within the depicted space is more important
  // to the viewer than is the depiction of depth.
  
  // For both camera forms, OpenGL uses the metaphors of an "eye", a "target" and the "up axis": 
  
  // The "eye" position specifies the location of the camera itself.
  
  // The "target" position specifies the point towards which the camera is looking.
  
  // The "up axis" specifies the (normalized) direction in which the top of the camera is pointed.
  // If the ground plane were running along XZ, then the appropriate up axis for the depiction of a level horizon would be Y or ( 0, 1, 0 ).
 
  // In addition to these three properties, OpenGL provides three other camera parameters:
  
  // "Fov" (field-of-view) is a perspective camera's angle of convergence. These values should always be > 0 and < PI.
  // Low numbers will be equivalent to a camera like that found in a cell phone while high numbers will be equivalent to something
  // more like an IMAX lens.
  // It is important to note, however, that OpenGL cameras primarily employ the mathematics of a pinhole camera
  // and therefore do not truly represent the optical properties of a lens. As such, lens-like effects such as depth of field
  // require more complex tools, which can be imitated through GLSL vertex shaders or realistically modeled with 
  // non-scanline techniques such as raytracing.
  // Fov does not apply to orthographic cameras.
  
  // "Near plane" specifies the camera's minimum viewing distance. This value must be > 0, but should generally be approaching 0.
  
  // "Far plane" specifies the camera's maximum viewing distance. Though there is generally no explicit max beyond the limits
  // of a numeric data type, extremely large values will slow rendering as a much larger space must be factored into rasterization.
  
  // (Sorry this example is so nauseating).
  
  // We now initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":
  size( 800, 600, GLConstants.GLGRAPHICS );
  
  // Initialize the SceneController. The controller will need access to the PApplet
  // object and the renderer contained within it, so we pass the PApplet in here.
  mScene = new SceneController( this );
    
  // Choose the number of UVs in the mesh
  int meshPointsU = 15;
  int meshPointsV = 15;
  // Choose a size for the mesh
  float meshRadius = 25.0;
  
  // Create some spheres by adding them as children of the scene
  int numMeshes     = 10;
  float theta       = TWO_PI/(float)numMeshes;
  
  for(int i = 0; i < numMeshes; i++) {
    TMesh mesh;
    if( i % 2 == 0 ) {
      mesh = mScene.addSphere( meshPointsU, meshPointsV, meshRadius );
    }
    else {
      mesh = mScene.addTorus( meshPointsU, meshPointsV, meshRadius/2.0, meshRadius );
    }
    // Center the mesh in window
    mesh.setPosition( new PVector( sceneRadius * cos(i*theta), sceneRadius* sin(i*theta), 0.0 ) );
    mesh.setRotation( new PVector( PI, 0.0, 0.0 ) );
    // Set mesh texture
    mesh.setTexture( "world32k.jpg" );
  }
}

void draw() {
  // Move camera
  float tCurrTime = (float)frameCount/25.0;
  float tCamZ = map( sin( tCurrTime ), -1.0, 1.0, -400.0, 800.0 );
  
  PVector tEye  = new PVector( sceneRadius * cos( tCurrTime ), sceneRadius * sin( tCurrTime ), tCamZ );
  PVector tTarg = new PVector( sceneRadius * sin( tCurrTime ), sceneRadius * cos( tCurrTime ), 0.0 );
  mScene.mCamera.setEye( tEye );
  mScene.mCamera.setTarget( tTarg );
  
  // Draw scene
  mScene.draw();
  
  println("fps: " + frameRate);
}

void keyReleased() {
  if( key == 'd' ) { mScene.toggleDebugMode(); }
}
