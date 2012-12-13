// One key component of using shaders is the ability to pass variables into a bound shader.
// In GLSL, there are "uniform" and "attribute" variables. Only uniforms are supported below, but attributes could be added too.
// Both uniforms and attributes could also be connected with EaseFloat-based instead of Float-based types in the code below.
// The key challenge in building a data structure to manage the runtime usage of a shader is
// that various shaders may take an assortment of variable types as inputs: int, float, vec2, vec3, vec4, etc.
// Fortunately, a Java HashMap can store generic objects types. 
// Even more importantly, Java makes it very easy to check an object's type with something like: tObj.getClass()
// This means that we can store a bunch of different variable types in the same container
// and when we run the shader in the draw() routine of some mesh, calling setAllUniforms() will 
// iterate the HashMap, checking the type of each object and routing it to the appropriate GLGraphics uniform setting function.
// This concept of inspecting an object's type is generally called "reflection." Different languages support reflection to different
// extents. Converting this class in a literal manner to C++ would be challenging. Java's reflection capabilities are much more
// straight-forward than those of C++. However, in C++ you might approach the problem through different mechanisms, taking better advantage
// of that language's natural strengths.
// Back to our Processing implementation, there's one small hitch... 
// In general, we've been storing 2d vector data in PVector objects whose z values are 0.
// We also have been working without the Processing equivalent of GLSL's vec4.
// We now need to distinguish the GLSL types vec2, vec3 and vec4, so PVector isn't a suitable under-the-hood abstraction here.
// To handle these types within the shader manager, there are some baseline Vec2, Vec3 and Vec4 classes described below.
// As you'll see, these types don't need to be exposed to the outside world. For instance, 
// the method addUniform(String iName, float iX, float iY, float iZ, float iW) takes 4 float inputs and routes them into our
// under-the-hood Vec4 type. When setAllUniforms() is called, the Vec4 will be decomposed back into 4 floats and passed into
// a GLGraphics function which expects 4 floats.
// We could handle texture uniforms in several ways here. Since our TMesh class automatically binds it's member texture
// to the GPU texture unit 0, we get the first texture for free. I leave it to you to workout more elaborate implementations.
// Additional GLSL types can also be added. See:
// http://glgraphics.sourceforge.net/reference/codeanticode/glgraphics/GLSLShader.html

// Please note that this class provides high-level abstraction of shader uniforms
// and is therefore slower than a custom integration of a specific shader.
// Object reflection and HashMap iteration both come with some overhead.

class Vec2 {
  Vec2(float X, float Y) { x = X; y = Y; }
  float x,y;
}

class Vec3 {
  Vec3(float X, float Y, float Z) { x = X; y = Y; z = Z; }
  float x,y,z;
}

class Vec4 {
  Vec4(float X, float Y, float Z, float W) { x = X; y = Y; z = Z; w = W; }
  float x,y,z,w;
}

class ShaderWrapper {
  ShaderWrapper(PApplet iApplet, String iShaderName, String iVertPath, String iFragPath) {
    mApplet     = iApplet;
    mShaderName = iShaderName;
    mVertPath   = iVertPath;
    mFragPath   = iFragPath;
    mUniforms   = new HashMap();
    mShader     = new GLSLShader( mApplet, mVertPath, mFragPath );
  }
  
  void addUniform(String iName, int iX) {
    mUniforms.put( iName, new Integer( iX ) );
  }
  void addUniform(String iName, float iX) {
    mUniforms.put( iName, new Float( iX ) );
  }
  void addUniform(String iName, float iX, float iY) {
    mUniforms.put( iName, new Vec2( iX, iY ) );
  }
  void addUniform(String iName, float iX, float iY, float iZ) {
    mUniforms.put( iName, new Vec3( iX, iY, iZ ) );
  }
  void addUniform(String iName, float iX, float iY, float iZ, float iW) {
    mUniforms.put( iName, new Vec4( iX, iY, iZ, iW ) );
  }
  
  void addTextureUniform(String iName, short iUnit) {
    mUniforms.put( iName, new Short( iUnit ) );
  }
 
  void setAllUniforms() {
    Iterator i = mUniforms.keySet().iterator();
    while (i.hasNext()) {
      String tName = (String)i.next();
      Object tObj  = mUniforms.get( tName );

      if( tObj.getClass().isAssignableFrom(Short.class) ) {
        mShader.setTexUniform( tName, (Short)tObj );
      }
      else if( tObj.getClass().isAssignableFrom(Integer.class) ) {
        mShader.setFloatUniform( tName, (Integer)tObj );
      }
      else if( tObj.getClass().isAssignableFrom(Float.class) ) {
        mShader.setFloatUniform( tName, (Float)tObj );
      }
      else if( tObj.getClass().isAssignableFrom(Vec2.class) ) {
        mShader.setVecUniform( tName, ((Vec2)tObj).x, ((Vec2)tObj).y );
      }
      else if( tObj.getClass().isAssignableFrom(Vec3.class) ) {
        mShader.setVecUniform( tName, ((Vec3)tObj).x, ((Vec3)tObj).y, ((Vec3)tObj).z );
      }
      else if( tObj.getClass().isAssignableFrom(Vec4.class) ) {
        mShader.setVecUniform( tName, ((Vec4)tObj).x, ((Vec4)tObj).y, ((Vec4)tObj).z, ((Vec4)tObj).w );
      }
    }
  }
  
  PApplet      mApplet;
  GLSLShader   mShader;
  HashMap      mUniforms;
  String       mShaderName, mVertPath, mFragPath;
}

class ShaderManager {
  PApplet mApplet;
  HashMap mShaders;  
  
  ShaderManager(PApplet iApplet) {
    mApplet = iApplet;
    // Initialize shader map
    mShaders = new HashMap();   
    // Preload built-in shaders:
    initDefaultShaders();
  }
  
  void initDefaultShaders() {
    // Normal mapping shader:
    addShader( "Normals", "Norm.vert", "Norm.frag" );
    // Add a toon shader:
    addShader( "Toon", "Toon.vert", "Toon.frag" );
    // Add a "spherical harmonics" shader, 
    // which performs a sort of pre-baked environment mapping effect:
    addShader( "OldTownSquare", "OldTownSquare.vert", "OldTownSquare.frag" );
    // We can also add a uniform:
    getShaderWrapper( "OldTownSquare" ).addUniform( "ScaleFactor", 0.8 );
    // Add brick shader:
    addShader( "Brick", "Brick.vert", "Brick.frag" );
    getShaderWrapper( "Brick" ).addUniform( "LightPosition", 0.5, 0.5, 0.5 );
    getShaderWrapper( "Brick" ).addUniform( "BrickColor", 0.8, 0.1, 0.1 );
    getShaderWrapper( "Brick" ).addUniform( "MortarColor", 0.7, 0.7, 0.7 );
    getShaderWrapper( "Brick" ).addUniform( "BrickSize", 20.0, 20.0 );
    getShaderWrapper( "Brick" ).addUniform( "BrickPct", 0.8, 0.8 );
    // Add phong shader:
    addShader( "Phong", "Phong.vert", "Phong.frag" );
    // Add hatch shader:
    addShader( "Hatch", "Hatch.vert", "Hatch.frag" );
    getShaderWrapper( "Hatch" ).addUniform( "frequency", 0.6 );
    getShaderWrapper( "Hatch" ).addUniform( "edgew", 0.1 );
    getShaderWrapper( "Hatch" ).addUniform( "Lightness", 0.9 );
    getShaderWrapper( "Hatch" ).addUniform( "HatchDirection", 0.3, 0.3, 0.3 );
  }
  
  void addShader(String iShaderName, String iVertPath, String iFragPath) {
    // If the shader name is unique, add it to map
    if( !mShaders.containsKey( iShaderName ) ) {
      ShaderWrapper tShader = new ShaderWrapper( mApplet, iShaderName, iVertPath, iFragPath );   
      mShaders.put( iShaderName, tShader );
    }
  }
  
  GLSLShader getShader(String iShaderName) {
    // If the given shader exists in map, return it
    if( mShaders.containsKey( iShaderName ) ) {
      GLSLShader tShader = ((ShaderWrapper)mShaders.get( iShaderName )).mShader;
      return tShader;
    }
    return null;
  }
  
  ShaderWrapper getShaderWrapper(String iShaderName) {
    // If the given shader exists in map, return it
    if( mShaders.containsKey( iShaderName ) ) {
      ShaderWrapper tShader = (ShaderWrapper)mShaders.get( iShaderName );
      return tShader;
    }
    return null;
  }
}
