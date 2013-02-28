/**
 * material_classic_normal_map.fp
 * 
 * Vertex shader shader which writes material information needed for Normal Map shading to
 * the gbuffer.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics).
 * Copyright (c) 2012, Computer Science Department, Cornell University.
 * 
 * @author Asher Dunn (ad488), John DeCorato (jd537)
 * @date 2013-02-2012
 */
 
 #version 110
 
 /* ID of Blinn-Phong material, since the normal map only effects things pre-color computation. */
const int BLINNPHONG_MATERIAL_ID = 3;

/* Material properties passed from the application. */
uniform vec3 DiffuseColor;
uniform vec3 SpecularColor;
uniform float PhongExponent;

/* Textures and flags for whether they exist. */
uniform sampler2D DiffuseTexture;
uniform sampler2D SpecularTexture;
uniform sampler2D ExponentTexture;
uniform sampler2D NormalTexture;

uniform bool HasDiffuseTexture;
uniform bool HasSpecularTexture;
uniform bool HasExponentTexture;
uniform bool HasNormalTexture;

varying vec3 EyespacePosition;
varying vec3 EyespaceNormal;
varying vec2 TexCoord;

/* Encodes a normalized vector as a vec2. See Renderer.java for more info. */
vec2 encode(vec3 n)
{
	return normalize(n.xy) * sqrt(0.5 * n.z + 0.5);
}

void main()
{
	// TODO PA2: Store diffuse color, position, encoded normal, material ID, and all other useful data in the g-buffer.
	//			 Use the normal map to get a new normal.
	
	vec3 DColor = DiffuseColor;
	vec3 SColor = SpecularColor;
	vec3 newNormal = EyespaceNormal;
	float PExponent = PhongExponent;
	
	if(HasDiffuseTexture){
		vec4 texDiffuse = texture2D(DiffuseTexture, TexCoord);
		DColor = DiffuseColor * texDiffuse.rgb;
	}
	
	if(HasSpecularTexture){
		vec4 texSpecular = texture2D(SpecularTexture, TexCoord);
		SColor = SpecularColor * texSpecular.xyz;
	}
	
	if(HasExponentTexture){
		vec4 texExponent = texture2D(ExponentTexture, TexCoord);
		PExponent = 255.0 * texExponent.x;
	}
	
	if(HasNormalTexture){
<<<<<<< HEAD
		vec3 norm_temp = (texture2D(NormalTexture, TexCoord).xyz);
		nrm = encode(normalize(norm_temp-0.5));
=======
		vec4 texNorm = texture2D(NormalTexture, TexCoord);
		newNormal = (texNorm.xyz - vec3(0.5));
>>>>>>> 094589c199db73ac0c6edd661fae1160105c763b
	}
	 
	/* Encode. */
	vec2 enc = encode(normalize(newNormal));
	
	gl_FragData[0] = vec4(DColor, enc.x);
	gl_FragData[1] = vec4(EyespacePosition, enc.y);
	gl_FragData[2] = vec4(float(BLINNPHONG_MATERIAL_ID), 0.0, 0.0, 0.0);
	gl_FragData[3] = vec4(SColor, PExponent);
}