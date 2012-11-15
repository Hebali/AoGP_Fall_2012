#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/GlslProg.h"
#include "cinder/gl/Texture.h"
#include "cinder/ImageIo.h"
#include "cinder/Capture.h"

using namespace ci;
using namespace ci::app;
using namespace std;

#define CAM_W  640
#define CAM_H  480

#define STRINGIFY(s) #s

static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
    void main() {
        gl_FrontColor = gl_Color;
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_Position = ftransform();
    }
);

static const string GLSL_FRAG_IMGPROC = STRINGIFY(
      uniform sampler2D   texture;
      uniform float       width;
      uniform float       height;
      
      void main(void) {
          float w = 1.0/width;
          float h = 1.0/height;
          
          vec2 texCoord  = gl_TexCoord[0].st;
          
          vec4 n[9];
          n[0] = texture2D(texture, texCoord + vec2( -w, -h));
          n[1] = texture2D(texture, texCoord + vec2(0.0, -h));
          n[2] = texture2D(texture, texCoord + vec2(  w, -h));
          n[3] = texture2D(texture, texCoord + vec2( -w, 0.0));
          n[4] = texture2D(texture, texCoord);
          n[5] = texture2D(texture, texCoord + vec2(  w, 0.0));
          n[6] = texture2D(texture, texCoord + vec2( -w, h));
          n[7] = texture2D(texture, texCoord + vec2(0.0, h));
          n[8] = texture2D(texture, texCoord + vec2(  w, h));
          
          //SOBEL EDGE
          vec4 sobel_horizEdge = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
          vec4 sobel_vertEdge  = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8]);
          vec3 sobel = sqrt((sobel_horizEdge.rgb * sobel_horizEdge.rgb) + (sobel_vertEdge.rgb * sobel_vertEdge.rgb));

          gl_FragColor = vec4( sobel, 1.0 );
      }
);

class Aogp_Shader_BasicApp : public AppBasic {
  public:
	void prepareSettings( Settings *settings );
	void setup();
	void mouseDown( MouseEvent event );
	void keyDown( KeyEvent event );
	void resize( ResizeEvent event );
	void update();
	void draw();

    Capture		 mCapture;
    
	gl::GlslProg mShader;
    gl::Texture  mTexture;
};

void Aogp_Shader_BasicApp::prepareSettings( Settings *settings ) {
	settings->setFrameRate( 60.0f );
	settings->setWindowSize( 1024, 768 );
}

void Aogp_Shader_BasicApp::setup() {
    // Initialize shader:
	try {
		mShader = gl::GlslProg( GLSL_VERT_PASSTHROUGH.c_str(), GLSL_FRAG_IMGPROC.c_str() );
	}
    catch( gl::GlslProgCompileExc &exc ) {
		console() << "Cannot compile shader: " << exc.what() << std::endl;
		exit(1);
	}
    catch( Exception &exc ){
		console() << "Cannot load shader: " << exc.what() << std::endl;
		exit(1);
	}
    
    // Initialize camera:
    try {
		mCapture = Capture( CAM_W, CAM_H );
		mCapture.start();
	}
	catch(...) { console() << "Failed to initialize camera." << endl; }
}

void Aogp_Shader_BasicApp::mouseDown( MouseEvent event ) {
}

void Aogp_Shader_BasicApp::keyDown( KeyEvent event ) {
}

void Aogp_Shader_BasicApp::resize( ResizeEvent event ) {
}

void Aogp_Shader_BasicApp::update() {
    if( mCapture && mCapture.checkNewFrame() ) {
		mTexture = gl::Texture( mCapture.getSurface() );
        mTexture.setWrap(GL_CLAMP, GL_CLAMP);
		mTexture.setMinFilter(GL_NEAREST);
		mTexture.setMagFilter(GL_NEAREST);
	}
}

void Aogp_Shader_BasicApp::draw() {
	gl::clear( Color::black() );
	
    if( mTexture ) {
        mTexture.bind( 0 );
        mShader.bind();
        mShader.uniform( "texture", 0 );
        mShader.uniform( "width", (float)CAM_W );
        mShader.uniform( "height", (float)CAM_H );
        gl::drawSolidRect( getWindowBounds() );
        mShader.unbind();
        mTexture.unbind();
    }
}

CINDER_APP_BASIC( Aogp_Shader_BasicApp, RendererGl(0) )
