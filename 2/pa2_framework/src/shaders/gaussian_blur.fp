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
	//if(Axis != 0){Axis = 1;}
	//for(int i = -KernelWidth; i<KernelWidth; i++){
	//	vec3 cur_color = texture2D(SourceTexture, gl_FragCoord.xy+vec2(float(i))).rbg;
	//	color += weight(float(i)) * cur_color;
	//}

   // gl_FragColor = vec4(color,1.0);


    vec4 color = vec4(0.0);
    
    float h = (float(KernelWidth) - 1.0);
    for(float i = -h; i <= h; i++){

    	vec4 tex = vec4(0.0);

    	if(Axis == 0){
    		
    		tex = texture2D(SourceTexture, gl_TexCoord[0].xy + vec2(i, 0.0));
    	}else{

			tex = texture2D(SourceTexture, gl_TexCoord[0].xy + vec2(0.0, i));
    	}

    	color = color + tex * exp(-(i * i) / (2.0 * KernelVariance));



    }

//color /= KernelWidth *2.0;
    gl_FragColor = color;
}