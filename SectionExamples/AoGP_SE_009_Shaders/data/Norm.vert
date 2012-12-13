varying vec3 mColor;

void main() {
	vec3 temp = normalize(gl_NormalMatrix * gl_Normal);
    mColor = temp.zyx + temp.xyz / 2.0;
    
    gl_Position = ftransform();
}
