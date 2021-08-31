if gl.CreateShader == nil then
	return
end

function widget:GetInfo()
	return {
		name	  = "FXAA",
		desc	  = "Spring port of FXAA",
		author	  = "ivand",
		layer	  = 2000,
		enabled   = false, --true,
	}
end

-- Shameless port from https://gist.github.com/martymcmodding/30304c4bffa6e2bd2eb59ff8bb09d135

-----------------------------------------------------------------
-- Constants
-----------------------------------------------------------------

local GL_RGBA8 = 0x8058

local version = 1.01

-----------------------------------------------------------------
-- Lua Shortcuts
-----------------------------------------------------------------

local glTexture		 = gl.Texture
local glTexRect		 = gl.TexRect
local glCallList		= gl.CallList
local glCopyToTexture   = gl.CopyToTexture

-----------------------------------------------------------------
-- File path Constants
-----------------------------------------------------------------

local luaShaderDir = "LuaUI/Widgets/Include/"

-----------------------------------------------------------------
-- Shader Sources
-----------------------------------------------------------------

local vsFXAA = [[
#version 150 compatibility

void main() {
	gl_Position = gl_Vertex;
}
]]

local fsFXAA = [[
#version 150 compatibility
#line 20054

uniform sampler2D screenCopyTex;

const float FXAA_SPAN_MAX = 8.0;
const float FXAA_REDUCE_MUL = 1.0/8.0;
const float FXAA_REDUCE_MIN = 1.0/128.0;

vec3 FXAAPass(vec2 fragCoord){
	vec2 screenSize = vec2(textureSize(screenCopyTex, 0));
	vec2 offset = 1.0 / screenSize;
	vec2 uv = fragCoord.xy / screenSize;

	vec3 nw = texture(screenCopyTex, uv + vec2(-1.0, -1.0) * offset).rgb;
	vec3 ne = texture(screenCopyTex, uv + vec2( 1.0, -1.0) * offset).rgb;
	vec3 sw = texture(screenCopyTex, uv + vec2(-1.0,  1.0) * offset).rgb;
	vec3 se = texture(screenCopyTex, uv + vec2( 1.0,  1.0) * offset).rgb;
	vec3 m  = texture(screenCopyTex, uv).rgb;

	const vec3 luma = vec3(0.333, 0.333, 0.334);

	float lumaNW = dot(nw, luma);
	float lumaNE = dot(ne, luma);
	float lumaSW = dot(sw, luma);
	float lumaSE = dot(se, luma);
	float lumaM  = dot(m,  luma);

	float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
	float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));
	vec2 dir = vec2(
		-((lumaNW + lumaNE) - (lumaSW + lumaSE)),
		((lumaNW + lumaSW) - (lumaNE + lumaSE)));

	float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) * (0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);
	float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
	dir = min(vec2(FXAA_SPAN_MAX), max(vec2(-FXAA_SPAN_MAX), dir * rcpDirMin)) * offset;

	vec3 rgbA = 0.5 * (texture(screenCopyTex, uv + dir * (1.0 / 3.0 - 0.5)).xyz + texture(screenCopyTex, uv + dir * (2.0 / 3.0 - 0.5)).xyz);
	vec3 rgbB = rgbA * 0.5 + 0.25 * (texture(screenCopyTex, uv + dir * -0.5).xyz + texture(screenCopyTex, uv + dir * 0.5).xyz);
	float lumaB = dot(rgbB, luma);

	if (lumaB < lumaMin || lumaB > lumaMax)
		return rgbA;

	return rgbB;
}

void main() {
	gl_FragColor = vec4(FXAAPass(gl_FragCoord.xy), 1.0);
}
]]

-----------------------------------------------------------------
-- Global Variables
-----------------------------------------------------------------

local LuaShader = VFS.Include(luaShaderDir.."LuaShader.lua")

local vsx, vsy, vpx, vpy
local screenCopyTex
local fxaaShader

local fullTexQuad

-----------------------------------------------------------------
-- Local Functions
-----------------------------------------------------------------


-----------------------------------------------------------------
-- Widget Functions
-----------------------------------------------------------------


function widget:Initialize()

	if gl.CreateShader == nil then
		Spring.Echo("FXAA: createshader not supported, removing")
		widgetHandler:RemoveWidget(self)
		return
	end

	vsx, vsy, vpx, vpy = Spring.GetViewGeometry()

	local commonTexOpts = {
		target = GL_TEXTURE_2D,
		border = false,
		min_filter = GL.NEAREST,
		mag_filter = GL.NEAREST,

		wrap_s = GL.CLAMP_TO_EDGE,
		wrap_t = GL.CLAMP_TO_EDGE,
	}

	commonTexOpts.format = GL_RGBA8
	screenCopyTex = gl.CreateTexture(vsx, vsy, commonTexOpts)

	fxaaShader = LuaShader({
		vertex = vsFXAA,
		fragment = fsFXAA,
		uniformInt = {
			screenCopyTex = 0,
		},
	}, ": FXAA")
	fxaaShader:Initialize()

	fullTexQuad = gl.CreateList( function ()
		gl.DepthTest(false)
		gl.Blending(false)
		gl.TexRect(-1, -1, 1, 1, false, true) --false, true
		gl.Blending(true)
	end)
end

function widget:Shutdown()
	gl.DeleteTexture(screenCopyTex)
	fxaaShader:Finalize()
	gl.DeleteList(fullTexQuad)
end

function widget:ViewResize()
	widget:Shutdown()
	widget:Initialize()
end

function widget:DrawScreenEffects()
	glCopyToTexture(screenCopyTex, 0, 0, vpx, vpy, vsx, vsy)
	glTexture(0, screenCopyTex)
	fxaaShader:Activate()
		glCallList(fullTexQuad)
	fxaaShader:Deactivate()
	glTexture(0, false)
end