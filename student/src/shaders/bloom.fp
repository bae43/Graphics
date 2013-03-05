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

// TODO PA3 Prereq (Optional): Fill this in if you like bloom.
void main()
{
    float acc;
    for (int i = -KernelWidth; i <= KernelWidth; i++) {
    for (int j = -KernelWidth; j <= KernelWidth; j++) {
    	vec4 c = texture2DRect(FinalSceneBuffer, gl_FragCoord.xy + vec2(float(i), float(j)));
    	float brightness = step(Threshold, (c.x+c.y+c.z)/3.0);
    	acc += brightness* exp(-(pow(float(i), 2.0) + pow(float(j), 2.0))/(2.0 * KernelVariance));
    }
    }
    acc = acc /(2.0*3.1415926*KernelVariance);
    gl_FragColor =  texture2DRect(FinalSceneBuffer, gl_FragCoord.xy) + vec4(vec3(acc), 0);
}
