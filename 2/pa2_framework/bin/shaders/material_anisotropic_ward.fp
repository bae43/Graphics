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
	/* Standard vertex transform. */
	gl_Position = ftransform();
	
	/* DONE PA1: Transform stuff into eye space and store in varyings.
	 *           You must also construct the Bitangent from the VertexTangent attribute.
	 *           Note that VertexTangent.xyz is the tangent and VertexTangent.w is the handedness of the bitangent.
	 */
	
	/* Pass eyespace position and normal to the fragment shader. */
	EyespacePosition = vec3(gl_ModelViewMatrix * gl_Vertex);
	EyespaceNormal = normalize(gl_NormalMatrix * gl_Normal);
	
	/* As well as tangent and bitangent */
	vec3 bitangent = cross(gl_Normal, VertexTangent.xyz) * VertexTangent.w;
	
	EyespaceTangent = gl_NormalMatrix * VertexTangent.xyz;
	EyespaceBiTangent = gl_NormalMatrix * bitangent.xyz;
	
	TexCoord = vec2(gl_MultiTexCoord0);
}
