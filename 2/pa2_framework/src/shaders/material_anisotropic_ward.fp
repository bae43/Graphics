/**
 * material_anisotropic_ward.fp
 * 
 * Fragment shader which writes material information needed for Anisotropic Ward shading to
 * the gbuffer.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics).
 * Copyright (c) 2012, Computer Science Department, Cornell University.
 * 
 * @author Asher Dunn (ad488), Sean Ryan (ser99), Ivo Boyadzhiev (iib2)
 * @date 2013-01-30
 */

/* ID of Anisotropic Ward material, so the lighting shader knows what material
 * this pixel is. */
const int ANISOTROPIC_WARD_MATERIAL_ID = 6;

/* Material properties passed from the application. */
uniform vec3 DiffuseColor;
uniform vec3 SpecularColor;
uniform float AlphaX;
uniform float AlphaY;

/* Textures and flags for whether they exist. */
uniform sampler2D DiffuseTexture;
uniform sampler2D SpecularTexture;
uniform sampler2D AlphaXTexture;
uniform sampler2D AlphaYTexture;

uniform bool HasDiffuseTexture;
uniform bool HasSpecularTexture;
uniform bool HasAlphaXTexture;
uniform bool HasAlphaYTexture;

/* Fragment position and normal, and texcoord, from vertex shader. */
varying vec3 EyespacePosition;
varying vec3 EyespaceNormal;
varying vec2 TexCoord;

/* Tangent and BiTangent vectors (in eyespace) from vertex shader */
varying vec3 EyespaceTangent;
varying vec3 EyespaceBiTangent;

/* Encodes a normalized vector as a vec2. See Renderer.java for more info. */
vec2 encode(vec3 n)
{
	return normalize(n.xy) * sqrt(0.5 * n.z + 0.5);
}

void main()
{
	//DONE PA1: Copy over old code 
		
	 vec3 DColor = DiffuseColor;
	 vec3 SColor = SpecularColor;
	 float AX = AlphaX;
	 float AY = AlphaY;
	
	if(HasDiffuseTexture){
		vec4 texDiffuse = texture2D(DiffuseTexture, TexCoord);
		DColor = DiffuseColor * texDiffuse.rgb;
	}
	
	if(HasSpecularTexture){
		vec4 texSpecular = texture2D(SpecularTexture, TexCoord);
		SColor = SpecularColor * texSpecular.xyz;
	}
	
	if(HasAlphaXTexture){
		vec4 texAlphaX = texture2D(AlphaXTexture, TexCoord);
		AX = texAlphaX.x;
	}
	
	if(HasAlphaYTexture){
		vec4 texAlphaY = texture2D(AlphaYTexture, TexCoord);
		AY = texAlphaY.x;
	}
	
	/* Store:
	 *	Diffuse			3
	 *	Position		3
	 *	Specular		3
	 *	Material_ID		1
	 *		& Bitangent Sign
	 *	ENC Normal		2 <= (3)
	 *	ENC Tangent		2 <= (3)
	 *	AlphaX			1
	 *	AlphaY			1
	 					= 16
	 */
	 
	 /* Encode. */
	vec2 enc_N = encode(normalize(EyespaceNormal));
	vec2 enc_T = encode(normalize(EyespaceTangent));
	
	vec3 Bi_Cross = cross(normalize(EyespaceNormal), normalize(EyespaceTangent));
	
	float ID = float(ANISOTROPIC_WARD_MATERIAL_ID);
	if(dot(Bi_Cross, EyespaceBiTangent) < 0){
		ID = -1.0 * ID;
	}
	
	gl_FragData[0] = vec4(DColor, enc_N.x);
	gl_FragData[1] = vec4(EyespacePosition, enc_N.y);
	gl_FragData[2] = vec4(ID, AX, AY, enc_T.x);
	gl_FragData[3] = vec4(SColor, enc_T.y);
}
