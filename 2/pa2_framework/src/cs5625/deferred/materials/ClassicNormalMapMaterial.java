package cs5625.deferred.materials;

import javax.media.opengl.GL2;
import javax.vecmath.Color3f;

import cs5625.deferred.misc.OpenGLException;
import cs5625.deferred.rendering.ShaderProgram;

/**
 * ClassicNormapMapMaterial.java
 * 
 * Implements the Blinn-Phong shading model with the option for a classic normal
 * map.
 * 
 * Written for Cornell CS 5625 (Interactive Computer Graphics). Copyright (c)
 * 2013, Computer Science Department, Cornell University.
 * 
 * @author Asher Dunn (ad488), John DeCorato (jd537)
 * @date 2013-02-12
 */
public class ClassicNormalMapMaterial extends Material {
	/* Blinn-Phong material properties. */
	private Color3f mDiffuseColor = new Color3f(1.0f, 1.0f, 1.0f);
	private Color3f mSpecularColor = new Color3f(1.0f, 1.0f, 1.0f);
	private float mPhongExponent = 50.0f;

	/* Optional textures for texture parameterized rendering. */
	private Texture2D mDiffuseTexture = null;
	private Texture2D mSpecularTexture = null;
	private Texture2D mExponentTexture = null;

	/* Normal map */
	private Texture2D mNormalTexture = null;

	/* Uniform locations for the shader. */
	private int mDiffuseUniformLocation = -1;
	private int mSpecularUniformLocation = -1;
	private int mExponentUniformLocation = -1;

	private int mHasDiffuseTextureUniformLocation = -1;
	private int mHasSpecularTextureUniformLocation = -1;
	private int mHasExponentTextureUniformLocation = -1;
	private int mHasNormalTextureUniformLocation = -1;

	public ClassicNormalMapMaterial() {

	}

	public ClassicNormalMapMaterial(Color3f diffuseColor,
			Texture2D normalTexture) {
		mDiffuseColor = diffuseColor;
		mNormalTexture = normalTexture;
	}

	public Color3f getDiffuseColor() {
		return mDiffuseColor;
	}

	public void setDiffuseColor(Color3f diffuse) {
		mDiffuseColor = diffuse;
	}

	public Color3f getSpecularColor() {
		return mSpecularColor;
	}

	public void setSpecularColor(Color3f specular) {
		mSpecularColor = specular;
	}

	public Texture2D getDiffuseTexture() {
		return mDiffuseTexture;
	}

	public void setDiffuseTexture(Texture2D texture) {
		mDiffuseTexture = texture;
	}

	public Texture2D getSpecularTexture() {
		return mSpecularTexture;
	}

	public void setSpecularTexture(Texture2D texture) {
		mSpecularTexture = texture;
	}

	public Texture2D getExponentTexture() {
		return mExponentTexture;
	}

	public void setExponentTexture(Texture2D texture) {
		mExponentTexture = texture;
	}

	public Texture2D getNormalTexture() {
		return mNormalTexture;
	}

	public void setNormalTexture(Texture2D texture) {
		mNormalTexture = texture;
	}

	@Override
	public void bind(GL2 gl) throws OpenGLException {

		
		/* Bind shader and any textures, and update uniforms. */
		getShaderProgram().bind(gl);
		
		// DONE PA2 (D): Set shader uniforms and bind any textures.
		gl.glUniform3f(mDiffuseUniformLocation, mDiffuseColor.x, mDiffuseColor.y, mDiffuseColor.z);
		gl.glUniform3f(mSpecularUniformLocation, mSpecularColor.x, mSpecularColor.y, mSpecularColor.z);
		gl.glUniform1f(mExponentUniformLocation, mPhongExponent);

		
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
		
		if(mExponentTexture != null){
			gl.glUniform1f(mHasExponentTextureUniformLocation, 1.0f);
			mExponentTexture.bind(gl, 2);
		} else {
			gl.glUniform1f(mHasExponentTextureUniformLocation, 0.0f);
		}
		
		if(mNormalTexture != null){
			gl.glUniform1f(mHasNormalTextureUniformLocation, 1.0f);
			mNormalTexture.bind(gl, 3);
		} else {
			gl.glUniform1f(mHasNormalTextureUniformLocation, 0.0f);
		}
	}

	@Override
	protected void initializeShader(GL2 gl, ShaderProgram shader) {
		/* Get locations of uniforms in this shader. */
		mDiffuseUniformLocation = shader.getUniformLocation(gl, "DiffuseColor");
		mSpecularUniformLocation = shader.getUniformLocation(gl,
				"SpecularColor");
		mExponentUniformLocation = shader.getUniformLocation(gl,
				"PhongExponent");

		mHasDiffuseTextureUniformLocation = shader.getUniformLocation(gl,
				"HasDiffuseTexture");
		mHasSpecularTextureUniformLocation = shader.getUniformLocation(gl,
				"HasSpecularTexture");
		mHasExponentTextureUniformLocation = shader.getUniformLocation(gl,
				"HasExponentTexture");
		mHasNormalTextureUniformLocation = shader.getUniformLocation(gl,
				"HasNormalTexture");

		/* These are only set once, so set them here. */
		shader.bind(gl);
		gl.glUniform1i(shader.getUniformLocation(gl, "DiffuseTexture"), 0);
		gl.glUniform1i(shader.getUniformLocation(gl, "SpecularTexture"), 1);
		gl.glUniform1i(shader.getUniformLocation(gl, "ExponentTexture"), 2);
		gl.glUniform1i(shader.getUniformLocation(gl, "NormalTexture"), 3);
		shader.unbind(gl);
	}

	@Override
	public void unbind(GL2 gl) {
		/* Unbind anything bound in bind(). */
		getShaderProgram().unbind(gl);

		// DONE PA2 (D): Unbind any used textures.
		if (mNormalTexture != null) {
			mNormalTexture.unbind(gl);
		}
		if (mDiffuseTexture != null) {
			mDiffuseTexture.unbind(gl);
		}
		
		if (mExponentTexture != null) {
			mExponentTexture.unbind(gl);
		}
		
		if (mSpecularTexture != null) {
			mSpecularTexture.unbind(gl);
		}

	}

	@Override
	public String getShaderIdentifier() {
		return "shaders/material_classic_normal_map";
	}
}
