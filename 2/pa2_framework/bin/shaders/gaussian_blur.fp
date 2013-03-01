/**
 * gaussian_blur.fp
 * 
 * 1D Gaussian blur shader, that can be used to blur a given texture.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics).
 * Copyright (c) 2012, Computer Science Department, Cornell University.
 * 
 * @author Ivaylo Boyadzhiev (iib2)
 * @date 2013-02-13
 */

/* Uniform inputs */
uniform sampler2D SourceTexture;
uniform float TextureSize;

/* Width and variance of the filter kernel */
uniform float KernelVariance;
uniform int KernelWidth;

/* horizontal axis is 0, vertical axis is non-zero */
uniform int Axis;

// TODO PA2: Implement a 1D Gaussian blur in the given direction
// Hint: The interpolated texture coordinates can be accessed
// through  gl_TexCoord[0]. TextureSize should be set to the width,
// for horizontal, and the height, for vertical Gaussian blur. 


float weight(float d){
	return exp(-(d*d)/(2.0 * KernelVariance));
} 

void main()
{
	if(Axis != 0){Axis = 1;}
	//for(int i = -KernelWidth; i<KernelWidth; i++){
	//	vec3 cur_color = texture2D(SourceTexture, gl_FragCoord.xy+vec2(float(i))).rbg;
	//	color += weight(float(i)) * cur_color;
	//}

   // gl_FragColor = vec4(color,1.0);

   float j = 0.0;
    vec4 color = texture2D(SourceTexture, gl_TexCoord[0].xy);
    
    float h = (float(KernelWidth) - 1.0);
    for(float i = -h/2; i <= h/2; i++){

    	
			vec4 t = texture2D(SourceTexture, gl_TexCoord[0].xy + vec2(i*(1.0-Axis)/TextureSize, i * Axis/TextureSize));

			color += t * exp(-(i * i + j * j) / (2.0 * KernelVariance));

    }
    color /= h;
    
    gl_FragColor = color;
}