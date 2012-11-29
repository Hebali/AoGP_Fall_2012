// Art of Graphics Programming
// Section Example 007: "Basic Lights"
// Course Materials by Patrick Hebron

// Processing OpenGL
import processing.opengl.*;
// Raw OpenGL handle
import javax.media.opengl.*;
// GLGraphics: http://sourceforge.net/projects/glgraphics/
import codeanticode.glgraphics.*;
// Easing: http://jesusgollonet.com/processing/pennerEasing/robert-penner-easing-processing-lib.zip
import penner.easing.*;

SceneController  mScene;

TMesh mesh;

void setup() {
  // In this example, we add the ability to animate lights, cameras, mesh vertices as well as the position, rotation and scale of a mesh.
  // ADDITIONAL NOTES COMING SOON. See component classes of this example for more info. 
  
  // We now initialize the renderer with "GLConstants.GLGRAPHICS" rather than "OPENGL":
  size( 800, 600, GLConstants.GLGRAPHICS );
  
  // Initialize the SceneController. The controller will need access to the PApplet
  // object and the renderer contained within it, so we pass the PApplet in here.
  mScene = new SceneController( this );
    
  // Choose the number of UVs in the mesh
  int meshPointsU = 100;
  int meshPointsV = 100;
  // Choose a size for the mesh
  float meshRadius = 300.0;
  
  mesh = mScene.addCone( meshPointsU, meshPointsV, meshRadius, 100.0 );
  mesh.setRotation( new PVector( PI/2.0, 0.0, 0.0 ) );
  mesh.setRotationVelocity( new PVector( 0.0, 0.0, 0.01 ) );
  mesh.setTexture( "world32k.jpg" );
  mesh.createDefaultState();
  
  TMesh target = mScene.mMeshFactory.createCylinder( meshPointsU, meshPointsV, meshRadius, 500.0 );
  target.setRotation( new PVector( PI/2.0, 0.0, 0.0 ) );
  target.setRotationVelocity( new PVector( 0.0, 0.0, 0.01 ) );
  target.setTexture( "world32k.jpg" );

  mesh.createTargetState( "Cylinder_State", target );
  mesh.goToState( "Cylinder_State", 5.0 );
  
  // Setup camera
  mScene.mCamera.setEye( new PVector( 0.0, -200.0, 800.0 ) );
  mScene.mCamera.setTarget( new PVector( 0.0, 0.0, 0.0 ) );
  mScene.mCamera.setWorldUp( new PVector( 0.0, 1.0, 0.0 ) );
  
  println( mScene.mCamera.getEye() );
  
  // Setup a few lights
  mScene.getLight(0).createAmbient( 200, 200, 200, new PVector( 0.0, 0.0, 0.0 ) );
  mScene.getLight(1).createDirectional( 100, 250, 250, new PVector( 0.0, 1.0, 0.0 ) );
}

void draw() {
  float currTime = (float)frameCount/25.0;
  
  // Draw scene
  mScene.draw();
  
  println("fps: " + frameRate);
}

void keyReleased() {
  if( key == 'd' )      { mScene.toggleDebugMode(); }
  else if( key == '1' ) { mesh.goToState( "default", 5.0 ); }
  else if( key == '2' ) { mesh.goToState( "Cylinder_State", 5.0 ); }
}
