// Art of Graphics Programming
// Section Example 007: "Basic Lights"
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
  // In this example, we add a class to represent lights within our environment.
  // In OpenGL, lights come in four basic forms: "ambient", "directional", "point" and "spotlight"
  
  // An "ambient" light is one whose light is scattered in all directions within a scene. Though ambient lights have a position parameter,
  // they act more as ubiquitous lighting. In this sense, ambient lights can be analogized to sunlight.
  
  // A "directional" light casts light that travels in a specified direction, but not from any particular point source. We can think of
  // this as a wall of light traveling in some direction. Directional lights are somewhat analogous to light emanating from a soft box
  // or bounced by a reflection card.
  
  // A "point" light emanates in all directions from a single point source and is analogous to a bare, unfocused lightbulb.
  
  // A "spotlight" is a focused point source whose rays are traveling towards a specific target. This form is analogous to the real world
  // light by the same name. Given their position and direction properties, spotlights fit a similar model to the eye/target model we use
  // in specifying cameras. One key distinction, however, is that cameras use an actual point in space as their targets whereas spotlights
  // only specify a target direction (that is, a normalization of the relationship between eye and target). For this reason, the NodeLight
  // class contains a lookAt() method that performs the necessary normalizations, allowing a spotlight to be positioned and directed in
  // much the same manner as a camera.
 
  // In addition to position and direction properties, lights also come with a few additional parameters:
 
  // OpenGL allows us to specify the light's color as well as it's specular color. The mColor parameter determines the primary quality
  // of the light, while mSpecularColor specifies the color of light reflected by an object's highlights. For example, the white dot
  // reflected by a human eye or a shiny sphere of any kind can be called a "specular highlight."
  
  // Spotlights come with two additional parameters: an angle parameter to specify the angle at which light spreads out from its source
  // and a concentration parameter which specifies the percentage of light directed at the center of the target.
  
  // A key consideration in integrating lights into an OpenGL environment is that due to performance limitations, OpenGL only provides
  // allocation for 8 lights at a time. As a result, the SceneController class has be designed to incorporate a fixed array of 8 lights.
  // Rather than allocating and deallocating lights, all 8 are initialized (but not given the necessary parameters to generate light) within
  // SceneController's setup() method. These lights can be swapped and repurposed as much as necessary during runtime, but you can never
  // use more than 8 at a time. The disable() method within the NodeLight class allows you to turn off a particular light, even though
  // SceneController does not actually delete it. You can access any light with mScene.getLight( INDEX ), where INDEX >= 0 and <= 7.
  
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
  int numMeshes     = 20;
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
  
  // Setup camera
  mScene.mCamera.setEye( new PVector( 0.0, 0.0, 800.0 ) );
  mScene.mCamera.setTarget( new PVector( 0.0, 0.0, 0.0 ) );
  
  // Setup a few lights
  mScene.getLight(0).createAmbient( 50, 0, 0, new PVector( 0.0, 0.0, 0.0 ) );
  mScene.getLight(1).createDirectional( 0, 250, 250, new PVector( 0.0, 1.0, 0.0 ) );
  // Spotlight position and direction will be updated in draw(), so we won't worry about their values here...
  mScene.getLight(2).createSpotlight( 250, 250, 250, new PVector( 0.0, 0.0, 0.0 ), new PVector( 0.0, 0.0, 0.0 ), radians(45.0), 100.0 );
}

void draw() {
  float currTime = (float)frameCount/25.0;
  
  // Move spotlight
  PVector tSpotEye  = new PVector( sceneRadius * cos( currTime ), sceneRadius * sin( currTime ), 800.0 );
  PVector tSpotTarg = new PVector( sceneRadius * -cos( currTime ), sceneRadius * -sin( currTime ), 0.0 );
  mScene.getLight(2).setLookAt( tSpotEye, tSpotTarg );
  
  // Draw scene
  mScene.draw();
  
  println("fps: " + frameRate);
}

void keyReleased() {
  if( key == 'd' ) { mScene.toggleDebugMode(); }
}
