package cs5625.deferred.materials;

import javax.media.opengl.GL2;
import javax.vecmath.Color3f;

import cs5625.deferred.misc.OpenGLException;
import cs5625.deferred.rendering.ShaderProgram;

/**
 * CookTorranceMaterial.java
 * 
 * Implements the Cook-Torrance shading model.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics).
 * Copyright (c) 2013, Computer Science Department, Cornell University.
 * 
 * @author Asher Dunn (ad488), Sean Ryan (ser99)
 * @date 2013-01-29
 */
public class CookTorranceMaterial extends Material
{
	/* Cook-Torrance material properties. */
	private Color3f mDiffuseColor = new Color3f(1.0f, 1.0f, 1.0f);
	private Color3f mSpecularColor = new Color3f(1.0f, 1.0f, 1.0f);
	private float mMVal = 0.5f;
	private float mNVal = 1.4f;
	
	/* Optional textures for texture parameterized rendering. */
	private Texture2D mDiffuseTexture = null;
	private Texture2D mSpecularTexture = null;
	private Texture2D mMTexture = null;
	private Texture2D mNTexture = null;
	
	/* Optional texture for environment mapping (can be static or dynamic) */
	private TextureCubeMap mCubeMapTexture = null;
	
	/* Uniform locations for the shader. */
	private int mDiffuseUniformLocation = -1;
	private int mSpecularUniformLocation = -1;
	private int mMUniformLocation = -1;
	private int mNUniformLocation = -1;
	private int mHasDiffuseTextureUniformLocation = -1;
	private int mHasSpecularTextureUniformLocation = -1;
	private int mHasMTextureUniformLocation = -1;
	private int mHasNTextureUniformLocation = -1;
	
	private int mCubeMapIndexUniformLocation = -1;
	
	public CookTorranceMaterial()
	{
		/* Default constructor */
	}
	
	public CookTorranceMaterial(Color3f diffuse)
	{
		mDiffuseColor = diffuse;
	}
	
	public Color3f getDiffuseColor()
	{
		return mDiffuseColor;
	}
	
	public void setDiffuseColor(Color3f diffuse)
	{
		mDiffuseColor = diffuse;
	}

	public Color3f getSpecularColor()
	{
		return mSpecularColor;
	}
	
	public void setSpecularColor(Color3f specular)
	{
		mSpecularColor = specular;
	}
	
	public float getM()
	{
		return mMVal;
	}
	
	public void setM(float m)
	{
		mMVal = m;
	}
	
	public float getN()
	{
		return mNVal;
	}
	
	public void setN(float n)
	{
		mNVal = n;
	}

	public Texture2D getDiffuseTexture()
	{
		return mDiffuseTexture;
	}
	
	public void setDiffuseTexture(Texture2D texture)
	{
		mDiffuseTexture = texture;
	}

	public Texture2D getSpecularTexture()
	{
		return mSpecularTexture;
	}
	
	public void setSpecularTexture(Texture2D texture)
	{
		mSpecularTexture = texture;
	}
	
	public Texture2D getMTexture()
	{
		return mMTexture;
	}
	
	public void setMTexture(Texture2D texture)
	{
		mMTexture = texture;
	}
	
	public Texture2D getNTexture()
	{
		return mNTexture;
	}
	
	public void setNTexture(Texture2D texture)
	{
		mNTexture = texture;
	}
	
	public TextureCubeMap getCubeMapTexture() 
	{
		return mCubeMapTexture;
	}
	
	public void setCubeMapTexture(TextureCubeMap cubeMapTexture) 
	{
		mCubeMapTexture = cubeMapTexture;
	}

	@Override
	public String getShaderIdentifier()
	{
		return "shaders/material_cooktorrance";
	}
		
	@Override
	public void bind(GL2 gl) throws OpenGLException
	{
		/* Bind shader and any textures, and update uniforms. */
		getShaderProgram().bind(gl);
		
		// DONE PA1: Set shader uniforms and bind any textures.
		
		gl.glUniform3f(mDiffuseUniformLocation, mDiffuseColor.x, mDiffuseColor.y, mDiffuseColor.z);
		gl.glUniform3f(mSpecularUniformLocation, mSpecularColor.x, mSpecularColor.y, mSpecularColor.z);
		gl.glUniform1f(mMUniformLocation,mMVal);
		gl.glUniform1f(mNUniformLocation,mNVal);
		
		if(mDiffuseTexture != null){
			gl.glUniform1f(mHasDiffuseTextureUniformLocation, 1.0f);
			mDiffuseTexture.bind(gl, 0);
		} else {
			gl.glUniform1f(mHasDiffuseTextureUniformLocation, 0.0f);
		}
		
		if(mSpecularTexture != null){
			gl.glUniform1f(mHasSpecularTextureUniformLocation, 1.0f);
			mSpecularTexture.bind(gl, 1);
		} else {
			gl.glUniform1f(mHasSpecularTextureUniformLocation, 0.0f);
		}
		
		if(mMTexture != null){
			gl.glUniform1f(mHasMTextureUniformLocation, 1.0f);
			mMTexture.bind(gl, 2);
		} else {
			gl.glUniform1f(mHasMTextureUniformLocation, 0.0f);
		}
		
		if(mNTexture != null){
			gl.glUniform1f(mHasNTextureUniformLocation, 1.0f);
			mNTexture.bind(gl, 3);
		} else {
			gl.glUniform1f(mHasNTextureUniformLocation, 0.0f);
		}
		
		if(mCubeMapTexture != null){
			gl.glUniform1i(mCubeMapIndexUniformLocation, mCubeMapTexture.getCubeMapIndex());
		}
//		if(mCubeMapTexture != null){
//			gl.glUniform1f(mCubeMapIndexUniformLocation, 1.0f);
//			mCubeMapTexture.bind(gl, 1);
//		} else {
//			gl.glUniform1f(mCubeMapIndexUniformLocation, 0.0f);
//		}
	}
	
	@Override
	protected void initializeShader(GL2 gl, ShaderProgram shader)
	{
		/* Get locations of uniforms in this shader. */
		mDiffuseUniformLocation = shader.getUniformLocation(gl, "DiffuseColor");
		mSpecularUniformLocation = shader.getUniformLocation(gl, "SpecularColor");
		mMUniformLocation = shader.getUniformLocation(gl, "M");
		mNUniformLocation = shader.getUniformLocation(gl, "N");
		
		mHasDiffuseTextureUniformLocation = shader.getUniformLocation(gl, "HasDiffuseTexture");
		mHasSpecularTextureUniformLocation = shader.getUniformLocation(gl, "HasSpecularTexture");
		mHasMTextureUniformLocation = shader.getUniformLocation(gl, "HasMTexture");
		mHasNTextureUniformLocation = shader.getUniformLocation(gl, "HasNTexture");
		
		mCubeMapIndexUniformLocation = shader.getUniformLocation(gl, "CubeMapIndex");
		
		/* These are only set once, so set them here. */
		shader.bind(gl);
		gl.glUniform1i(shader.getUniformLocation(gl, "DiffuseTexture"), 0);
		gl.glUniform1i(shader.getUniformLocation(gl, "SpecularTexture"), 1);
		gl.glUniform1i(shader.getUniformLocation(gl, "MTexture"), 2);
		gl.glUniform1i(shader.getUniformLocation(gl, "NTexture"), 3);
		shader.unbind(gl);
	}

	@Override
	public void unbind(GL2 gl)
	{
		/* Unbind everything bound in bind(). */
		getShaderProgram().unbind(gl);
		
		// DONE PA1: Unbind any used textures
		
		if(mDiffuseTexture != null){
			mDiffuseTexture.unbind(gl);
		}
		
		if(mSpecularTexture != null){
			mSpecularTexture.unbind(gl);
		}
		
		if(mMTexture != null){
			mMTexture.unbind(gl);
		}
		
		if(mNTexture != null){
			mNTexture.unbind(gl);
		}	
		if(mCubeMapTexture != null){
			mCubeMapTexture.unbind(gl);
		}	
	}
}
