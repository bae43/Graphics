/**
 * bloom.fp
 * 
 * Fragment shader for the bloom post-processing algorithm.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics).
 * Copyright (c) 2013, Computer Science Department, Cornell University.
 * 
 * @author Sean Ryan (ser99)
 * @date 2013-01-31
 */

/* Sampler for the final scene in the GBuffer. */
uniform sampler2DRect FinalSceneBuffer;

uniform float KernelVariance;
uniform int KernelWidth;
uniform float Threshold;

// DONE PA2: Implement the bloom shader.

void main()
{
    vec4 pixel = texture2DRect(FinalSceneBuffer, gl_FragCoord.xy);
    
    float h = (float(KernelWidth) - 1.0);
    for(float i = -h; i <= h; i++){
    	for(float j = -h; j <= h; j++){
    	
			vec4 t = texture2DRect(FinalSceneBuffer, gl_FragCoord.xy + vec2(i, j));
			if(length(t.rgb) < Threshold){
				t = vec4(0.0);
			} else {
				t = normalize(t);
			}
			
			pixel = pixel + t * exp(-(i * i + j * j) / (2.0 * KernelVariance));
    	}
    }
    
    gl_FragColor = pixel;
}