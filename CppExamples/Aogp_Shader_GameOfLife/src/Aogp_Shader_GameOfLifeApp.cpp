#include "cinder/app/AppBasic.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Fbo.h"
#include "cinder/gl/GlslProg.h"
#include "cinder/ImageIo.h"
#include "cinder/Utilities.h"
#include "cinder/Perlin.h"

using namespace ci;
using namespace ci::app;
using namespace std;

#define FBO_WIDTH   1920
#define FBO_HEIGHT   768

#define STRINGIFY(s) #s

// SHADER STRINGS:
#pragma mark -
#pragma mark GOL_SHADER
// (pragma mark simply creates an easy-to-find bookmark within a code file)

// The GOL vertex shader is a simple pass-through:
static const string GLSL_VERT_PASSTHROUGH = STRINGIFY(
    void main() {
        gl_FrontColor  = gl_Color;
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_Position    = ftransform();
    }
);

// The GOL fragment shader 
static const string GLSL_FRAG_GOL = STRINGIFY(
    uniform float       width;
    uniform float       height;
    uniform sampler2D   texture;                                                  
    
    void main(void) {
        // Get current position within rect:
        vec2 texCoord	= gl_TexCoord[0].xy;
        
        // Determine the ratio dimension of a single pixel:
        float w			= 1.0/width;
        float h			= 1.0/height;
        
        // Get the value of the current pixel:
        // (Since GOL uses binary states black/white, we only need one color channel)
        float texColor	= texture2D( texture, texCoord ).r;

        // Get neighbor positions:
        vec2 offset[8];
        offset[0] = vec2(  -w,  -h );
        offset[1] = vec2( 0.0,  -h );
        offset[2] = vec2(   w,  -h );
        offset[3] = vec2(  -w, 0.0 );
        offset[4] = vec2(   w, 0.0 );
        offset[5] = vec2(  -w,   h );
        offset[6] = vec2( 0.0,   h );
        offset[7] = vec2(   w,   h );
        
        // Determine the number of active neighbors:
        int sum = 0;
        for(int i = 0; i < 8; i++) {
            if( texture2D( texture, texCoord + offset[i] ).r > 0.5 ) { sum++; }
        }
        
        // Determine pixel value based on the GOL rules:
        float outVal = 0.0;
        if     ( ( texColor >= 0.5 ) && (sum == 2 || sum == 3) ) { outVal = 1.0; }
        else if( ( texColor <  0.5 ) && (sum == 3) )             { outVal = 1.0; }
        
        // Set final pixel value:
        gl_FragColor = vec4( outVal, outVal, outVal, 1.0 );
    }
);

// APPLICATION AND SHADER BOILERPLATE:
#pragma mark -
#pragma mark GOL_APP
// (pragma mark simply creates an easy-to-find bookmark within a code file)

class Aogp_Shader_GameOfLifeApp : public AppBasic {
  public:
    void            prepareSettings(Settings *settings);
	void            setup();
	void            keyDown(KeyEvent event);
	void            update();
	void            draw();
    void            reset();
    
    int				mCurrentFBO;
	int				mOtherFBO;
	gl::Fbo			mFBOs[2];
	gl::GlslProg	mShader;
	gl::Texture		mTexture;
};

void Aogp_Shader_GameOfLifeApp::prepareSettings(Settings *settings) {
	settings->setWindowSize( FBO_WIDTH, FBO_HEIGHT );
	settings->setFrameRate( 60.0f );
}

void Aogp_Shader_GameOfLifeApp::setup() {
    // Initialize framebuffers:
    gl::Fbo::Format format;
	mCurrentFBO = 0;
	mOtherFBO   = 1;
	mFBOs[0]    = gl::Fbo( FBO_WIDTH, FBO_HEIGHT, format );
	mFBOs[1]    = gl::Fbo( FBO_WIDTH, FBO_HEIGHT, format );
	
    // Initialize the GOL shader:
	mShader = gl::GlslProg( GLSL_VERT_PASSTHROUGH.c_str(), GLSL_FRAG_GOL.c_str() );
    
    // Initialize board:
	reset();
	
    // Set texture GL parameters:
    // Texture should REPEAT so that the GOL environment wraps around the texture edges.
    // Texture should use NEAREST interpolation to prevent value blending (though GL_LINEAR works too).
	mTexture.setWrap( GL_REPEAT, GL_REPEAT );
	mTexture.setMinFilter( GL_NEAREST );
	mTexture.setMagFilter( GL_NEAREST );
	mTexture.bind( 1 );
}

void Aogp_Shader_GameOfLifeApp::keyDown(KeyEvent event) {
    // The 'r' key resets framebuffers:
    if( event.getChar() == 'r' ) { reset(); }
}

void Aogp_Shader_GameOfLifeApp::update() {
    // Choose the next framebuffer (ping-pong):
	mCurrentFBO = ( mCurrentFBO + 1 ) % 2;
	mOtherFBO   = ( mCurrentFBO + 1 ) % 2;
	
    // Bind the current framebuffer:
	mFBOs[ mCurrentFBO ].bindFramebuffer();
    
    // Bind the current texture:
	mFBOs[ mOtherFBO ].bindTexture();
    
    // Set GL texture parameters:
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
	glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
    
    // Bind GOL shader:
	mShader.bind();
	mShader.uniform( "texture", 0 );
	mShader.uniform( "width", (float)FBO_WIDTH );
	mShader.uniform( "height", (float)FBO_HEIGHT );
	
	// Draw shader onto a rectangle of the appropriate dimension:
    gl::drawSolidRect( mFBOs[ mCurrentFBO ].getBounds() );
	
    // Unbind GOL shader:
	mShader.unbind();
    
    // Unbind the current texture:
	mFBOs[ mOtherFBO ].unbindTexture();
	
    // Unbind the current framebuffer:
    mFBOs[ mCurrentFBO ].unbindFramebuffer();
}

void Aogp_Shader_GameOfLifeApp::draw() {
    // Clear the draw context:
	gl::clear( Color( 0, 0, 0 ) );
    
    // Set viewport and matrices based on framebuffer dimension:
	gl::setMatricesWindow( mFBOs[0].getSize(), false );
	gl::setViewport( mFBOs[0].getBounds() );
    
    // Draw the current framebuffer texture:
	gl::draw( mFBOs[mCurrentFBO].getTexture(), getWindowBounds() );
}

void Aogp_Shader_GameOfLifeApp::reset() {
    // Allocate a pixel array to store the initial board state:
	unsigned char* data = new unsigned char[FBO_WIDTH*FBO_HEIGHT];
    
    // Generate the initial board state using Perlin noise:
	Perlin perlin       = Perlin(8,rand());
	float xOffset       = 0.0;
	float incr          = 0.01;
	for(int x = 0; x < FBO_WIDTH; x++) {
		xOffset += incr;
		float yOffset = 0.0;
		for(int y = 0; y < FBO_HEIGHT; y++) {
			yOffset += incr;
			data[ y * FBO_WIDTH + x ] = ( (perlin.fBm( xOffset, yOffset ) + 0.5 >= 0.5) ? (255) : (0) );
		}
	}
    
    // Create a b&w (luminence) texture from pixel array:
	mTexture = gl::Texture( data, GL_LUMINANCE, FBO_WIDTH, FBO_HEIGHT );
    
    // Free pixel array memory:
    delete [] data;
    
    // Set viewport and matrices based on framebuffer dimension:
    gl::setMatricesWindow( mFBOs[0].getSize(), false );
	gl::setViewport( mFBOs[0].getBounds() );
    
    // Load the texture into both framebuffers:
    mTexture.bind( 0 );
    for(int i = 0; i < 2; i++) {
        mFBOs[i].bindFramebuffer();
        gl::draw( mTexture, mFBOs[i].getBounds() );
        mFBOs[i].unbindFramebuffer();
    }
    mTexture.unbind();
}

CINDER_APP_BASIC( Aogp_Shader_GameOfLifeApp, RendererGl )
