function widget:GetInfo()
	return {
		name = "Sensor Ranges Radar Preview",
		desc = "Raytraced Radar Range Coverage on building Radar (GL4)",
		author = "Beherith",
		date = "2021.07.12",
		license = "Lua: GPLv2, GLSL: (c) Beherith (mysterme@gmail.com)",
		layer = 0,
		enabled = true
	}
end
--- WIP: Being upgraded to show ore towers buildrange (ie. collection range)

------- GL4 NOTES -----
-- There is regular radar and advanced radar, assumed to have identical ranges!
local pulseEffect = true

local SHADERRESOLUTION = 16 -- THIS SHOULD MATCH RADARMIPLEVEL!

local smalloretowerrange = 330	-- updates to 'armrad' value
local largeoretowerrange = 480	-- updates to 'armarad' value

local cmdidtoradarsize = {}
local radaremitheight = {}

-- Functions shortcuts
local spGetSpectatingState = Spring.GetSpectatingState
local spGetUnitIsActive = Spring.GetUnitIsActive
local spGetUnitDefID = Spring.GetUnitDefID
local spGetUnitPosition = Spring.GetUnitPosition
local spIsGUIHidden = Spring.IsGUIHidden

-- Globals
local chobbyInterface
local mousepos = { 0, 0, 0 }
local spGetActiveCommand = Spring.GetActiveCommand


local luaShaderDir = "LuaUI/Widgets/Include/"
local LuaShader = VFS.Include(luaShaderDir .. "LuaShader.lua")
VFS.Include(luaShaderDir .. "instancevbotable.lua")

local radarTruthShader = nil

local smallradVAO = nil
local largeradVAO = nil
local selectedOreTowerUnitID = false

for unitDefID, unitDef in pairs(UnitDefs) do
	if unitDef.name == 'armuwadvms' then
		largeoretowerrange = unitDef.buildDistance or largeoretowerrange
	end
	if unitDef.name == 'armmstor' then
		smalloretowerrange = unitDef.buildDistance or smalloretowerrange
	end
	if unitDef.name == 'armmstor' then
		cmdidtoradarsize[-1 * unitDefID] = "small"
	end
	if unitDef.name == 'cormstor' then
		cmdidtoradarsize[-1 * unitDefID] = "small"
	end
	if unitDef.name == 'coruwadvms' then
		cmdidtoradarsize[-1 * unitDefID] = "large"
	end
	if unitDef.name == 'armuwadvms' then
		cmdidtoradarsize[-1 * unitDefID] = "large"
	end
end

local vsSrc = [[
#version 420
#line 10000

//__DEFINES__

layout (location = 0) in vec2 xyworld_xyfract;
uniform vec4 radarcenter_range;  // x y z range
uniform float resolution;  // how many steps are done

uniform sampler2D heightmapTex;

out DataVS {
	vec4 worldPos; // pos and radius
	vec4 centerposrange;
	vec4 blendedcolor;
	float worldscale_circumference;
};

//__ENGINEUNIFORMBUFFERDEFS__

#line 11009

float heightAtWorldPos(vec2 w){
	vec2 uvhm =   vec2(clamp(w.x,8.0,mapSize.x-8.0),clamp(w.y,8.0, mapSize.y-8.0))/ mapSize.xy;
	return max(0.0, textureLod(heightmapTex, uvhm, 0.0).x);
}

void main() {
	// transform the point to the center of the radarcenter_range

	vec4 pointWorldPos = vec4(0.0);

	vec3 radarMidPos = radarcenter_range.xyz + vec3(16.0, 0.0, 16.0);
	pointWorldPos.xz = (radarcenter_range.xz +  (xyworld_xyfract.xy * radarcenter_range.w)); // transform it out in XZ
	pointWorldPos.y = heightAtWorldPos(pointWorldPos.xz); // get the world height at that point

	vec3 toradarcenter = vec3(radarcenter_range.xyz - pointWorldPos.xyz);
	float dist_to_center = length(toradarcenter.xyz);

	// get closer to the center in N mip steps, and if that point is obscured at any time, remove it

	vec3 smallstep =  toradarcenter / resolution;
	float obscured = 0.0;

	//for (float i = 0.0; i < mod(timeInfo.x/3,resolution); i += 1.0 ) {
	for (float i = 0.0; i < resolution; i += 1.0 ) {
		vec3 raypos = pointWorldPos.xyz + (smallstep) * i;
		float heightatsample = heightAtWorldPos(raypos.xz);
		obscured = max(obscured, heightatsample - raypos.y);
		if (obscured >= 2.0)	break;
	}

	worldscale_circumference = 1.0; //startposrad.w * circlepointposition.z * 5.2345;
	worldPos = vec4(pointWorldPos);
	blendedcolor = vec4(0.0);
	blendedcolor.a = 0.5;
	//if (dist_to_center > radarcenter_range.w) blendedcolor.a = 0.0;  // do this in fs instead

	blendedcolor.g = 1.0-clamp(obscured*0.5,0.0,1.0);

	blendedcolor.a = min(blendedcolor.g,blendedcolor.a);
	blendedcolor.g = 1.0;

	pointWorldPos.y += 0.1;
	worldPos = pointWorldPos;
	gl_Position = cameraViewProj * vec4(pointWorldPos.xyz, 1.0);
	centerposrange = vec4(radarMidPos, radarcenter_range.w);
}
]]


local function goodbye(reason)
	Spring.Echo("radarTruthShader GL4 widget exiting with reason: " .. reason)
	widgetHandler:RemoveWidget()
end

local function initgl4()
	local fsSrc = [[
	#version 420

	#line 20000

	uniform vec4 radarcenter_range;  // x y z range
	uniform float resolution;  // how many steps are done

	uniform sampler2D heightmapTex;

	//__ENGINEUNIFORMBUFFERDEFS__

	//__DEFINES__
	in DataVS {
		vec4 worldPos; // w = range
		vec4 centerposrange;
		vec4 blendedcolor;
		float worldscale_circumference;
	};

	out vec4 fragColor;

	void main() {
		fragColor.rgba = blendedcolor.rgba;

		vec2 toedge = centerposrange.xz - worldPos.xz;

		float angle = atan(toedge.y/toedge.x);

		angle = (angle + 1.56)/3.14;

		float angletime = fract(angle - timeInfo.x* 0.033);

		angletime = 0.5; // no spinny for now

		angle = clamp(angletime, 0.2, 0.8);

		vec2 mymin = min(worldPos.xz,mapSize.xy - worldPos.xz);
		float inboundsness = min(mymin.x, mymin.y);
		fragColor.a = min(smoothstep(0,1,fragColor.a), 1.0 - clamp(inboundsness*(-0.1),0.0,1.0));


		if (length(worldPos.xz - radarcenter_range.xz) > radarcenter_range.w) fragColor.a = 0.0;

		fragColor.a = fragColor.a * angle * 0.85;
		//#if USE_STIPPLE > 0
			//fragColor.a *= 2.0 * sin(worldscale_circumference + timeInfo.x*0.2) ; // PERFECT STIPPLING!
		//#endif
	]]
	if pulseEffect then
		fsSrc = fsSrc .. [[
		float pulse = 1 + sin(-2.0 * sqrt(length(toedge)) + 0.033 * timeInfo.x);
		pulse *= pulse;
		fragColor.a = mix(fragColor.a, fragColor.a * pulse, 0.10);
	]]
	end
	fsSrc = fsSrc .. '}'

	local engineUniformBufferDefs = LuaShader.GetEngineUniformBufferDefs()
	vsSrc = vsSrc:gsub("//__ENGINEUNIFORMBUFFERDEFS__", engineUniformBufferDefs)
	fsSrc = fsSrc:gsub("//__ENGINEUNIFORMBUFFERDEFS__", engineUniformBufferDefs)
	radarTruthShader = LuaShader(
		{
			vertex = vsSrc:gsub("//__DEFINES__", "#define SHADERRESOLUTION " .. tostring(SHADERRESOLUTION + 0.0001)),
			fragment = fsSrc:gsub("//__DEFINES__", "#define USE_STIPPLE " .. tostring(usestipple)),
			--geometry = gsSrc, no geom shader for now
			uniformInt = {
				heightmapTex = 0,
			},
			uniformFloat = {
				radarcenter_range = { 2000, 100, 2000, 2000 },
				resolution = { 32 },
			},
		},
		"radarTruthShader GL4"
	)
	shaderCompiled = radarTruthShader:Initialize()
	if not shaderCompiled then
		goodbye("Failed to compile radarTruthShader GL4 ")
	end

	local smol, smolsize = makePlaneVBO(1, 1, smalloretowerrange / SHADERRESOLUTION)
	local smoli, smolisize = makePlaneIndexVBO(smalloretowerrange / SHADERRESOLUTION)
	smallradVAO = gl.GetVAO()
	smallradVAO:AttachVertexBuffer(smol)
	smallradVAO:AttachIndexBuffer(smoli)

	local larg, largsize = makePlaneVBO(1, 1, largeoretowerrange / SHADERRESOLUTION)
	local largi, largisize = makePlaneIndexVBO(largeoretowerrange / SHADERRESOLUTION)
	largeradVAO = gl.GetVAO()
	largeradVAO:AttachVertexBuffer(larg)
	largeradVAO:AttachIndexBuffer(largi)
end

function widget:RecvLuaMsg(msg, playerID)
	if msg:sub(1, 18) == 'LobbyOverlayActive' then
		chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
	end
end

function widget:Initialize()
	initgl4()
	WG.radarpreview = {
		getShowPulseEffect = function()
			return pulseEffect
		end,
		setShowPulseEffect = function(value)
			pulseEffect = value
			initgl4()
		end,
	}
end

function widget:Shutdown()
	WG.radarpreview = nil
end

function widget:TextCommand(command)
	if string.sub(command,1, 11) == "radarpulse" then
		WG.radarpreview.setShowPulseEffect(not pulseEffect)
		Spring.Echo('radar range preview: pulse effect: '..(pulseEffect and 'enabled' or 'disabled'))
	end
end

function widget:SelectionChanged(sel)
	selectedOreTowerUnitID = false
	if #sel == 1 and Spring.GetUnitDefID(sel[1]) then --and cmdidtoradarsize[-Spring.GetUnitDefID(sel[1])]
		selectedOreTowerUnitID = sel[1]
	end
end

function widget:DrawWorld()
	local cmdID
	if selectedOreTowerUnitID then
		cmdID = -Spring.GetUnitDefID(selectedOreTowerUnitID)
	else
		cmdID = select(2, spGetActiveCommand())
		if cmdID == nil or cmdID >= 0 then
			return
		end -- not build command
	end

    --TODO: Check if needed
	--if chobbyInterface or spIsGUIHidden() or (WG['topbar'] and WG['topbar'].showingQuit()) then
	--	return
	--end

	local whichradarsize = cmdidtoradarsize[cmdID]
	if whichradarsize == nil then
		return
	end
	if selectedOreTowerUnitID then
		mousepos = { Spring.GetUnitPosition(selectedOreTowerUnitID) }
	else
		local mx, my, lp, mp, rp, offscreen = Spring.GetMouseState()
		local _, coords = Spring.TraceScreenRay(mx, my, true)
		if coords then
			mousepos = { coords[1], coords[2], coords[3] }
		end
	end

	gl.DepthTest(false)
	gl.Culling(GL.BACK)
	gl.Texture(0, "$heightmap")
	radarTruthShader:Activate()
	radarTruthShader:SetUniform("radarcenter_range",
		math.floor((mousepos[1] + 8) / (SHADERRESOLUTION * 2)) * (SHADERRESOLUTION * 2),
		mousepos[2],
		math.floor((mousepos[3] + 8) / (SHADERRESOLUTION * 2)) * (SHADERRESOLUTION * 2),
		whichradarsize == "small" and smalloretowerrange or largeoretowerrange
	)
	if whichradarsize == "small" then
		smallradVAO:DrawElements(GL.TRIANGLES)
	elseif whichradarsize == "large" then
		largeradVAO:DrawElements(GL.TRIANGLES)
	end

	radarTruthShader:Deactivate()
	gl.Texture(0, false)

	gl.DepthTest(true)
end



function widget:GetConfigData(data)
	return {
		pulseEffect = pulseEffect,
	}
end

function widget:SetConfigData(data)
	if data.pulseEffect ~= nil then
		pulseEffect = data.pulseEffect
	end
end
