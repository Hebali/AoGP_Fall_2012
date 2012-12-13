// From: http://www.yaldex.com/open-gl/ch12lev1sec3.html

varying vec3 DiffuseColor;

void main() {
    gl_FragColor = vec4(DiffuseColor, 1.0);
}
