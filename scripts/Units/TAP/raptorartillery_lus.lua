--
-- Creator: MaDDoX
-- Date: 11/11/22
-- Time: 11:38AM
--

local root_x = piece 'rig_Raptor_Artillery_root_x'
local c_thigh_b_r = piece 'rig_Raptor_Artillery_c_thigh_b_r'
local thigh_stretch_r = piece 'rig_Raptor_Artillery_thigh_stretch_r'
local leg_stretch_r = piece 'rig_Raptor_Artillery_leg_stretch_r'
local foot_r = piece 'rig_Raptor_Artillery_foot_r'
local leg_twist_r = piece 'rig_Raptor_Artillery_leg_twist_r'
local thigh_twist_r = piece 'rig_Raptor_Artillery_thigh_twist_r'
local c_thigh_b_dupli_001_l = piece 'rig_Raptor_Artillery_c_thigh_b_dupli_001_l'
local thigh_stretch_dupli_001_l = piece 'rig_Raptor_Artillery_thigh_stretch_dupli_001_l'
local leg_stretch_dupli_001_l = piece 'rig_Raptor_Artillery_leg_stretch_dupli_001_l'
local foot_dupli_001_l = piece 'rig_Raptor_Artillery_foot_dupli_001_l'
local leg_twist_dupli_001_l = piece 'rig_Raptor_Artillery_leg_twist_dupli_001_l'
local thigh_twist_dupli_001_l = piece 'rig_Raptor_Artillery_thigh_twist_dupli_001_l'
local c_thigh_b_dupli_001_r = piece 'rig_Raptor_Artillery_c_thigh_b_dupli_001_r'
local thigh_stretch_dupli_001_r = piece 'rig_Raptor_Artillery_thigh_stretch_dupli_001_r'
local leg_stretch_dupli_001_r = piece 'rig_Raptor_Artillery_leg_stretch_dupli_001_r'
local foot_dupli_001_r = piece 'rig_Raptor_Artillery_foot_dupli_001_r'
local leg_twist_dupli_001_r = piece 'rig_Raptor_Artillery_leg_twist_dupli_001_r'
local thigh_twist_dupli_001_r = piece 'rig_Raptor_Artillery_thigh_twist_dupli_001_r'
local c_tail_00_x = piece 'rig_Raptor_Artillery_c_tail_00_x'
local c_tail_01_x = piece 'rig_Raptor_Artillery_c_tail_01_x'
local c_tail_02_x = piece 'rig_Raptor_Artillery_c_tail_02_x'
local c_tail_03_x = piece 'rig_Raptor_Artillery_c_tail_03_x'
local c_tail_04_x = piece 'rig_Raptor_Artillery_c_tail_04_x'
local c_thigh_b_dupli_002_l = piece 'rig_Raptor_Artillery_c_thigh_b_dupli_002_l'
local thigh_stretch_dupli_002_l = piece 'rig_Raptor_Artillery_thigh_stretch_dupli_002_l'
local leg_stretch_dupli_002_l = piece 'rig_Raptor_Artillery_leg_stretch_dupli_002_l'
local foot_dupli_002_l = piece 'rig_Raptor_Artillery_foot_dupli_002_l'
local leg_twist_dupli_002_l = piece 'rig_Raptor_Artillery_leg_twist_dupli_002_l'
local thigh_twist_dupli_002_l = piece 'rig_Raptor_Artillery_thigh_twist_dupli_002_l'
local c_thigh_b_dupli_002_r = piece 'rig_Raptor_Artillery_c_thigh_b_dupli_002_r'
local thigh_stretch_dupli_002_r = piece 'rig_Raptor_Artillery_thigh_stretch_dupli_002_r'
local leg_stretch_dupli_002_r = piece 'rig_Raptor_Artillery_leg_stretch_dupli_002_r'
local foot_dupli_002_r = piece 'rig_Raptor_Artillery_foot_dupli_002_r'
local leg_twist_dupli_002_r = piece 'rig_Raptor_Artillery_leg_twist_dupli_002_r'
local thigh_twist_dupli_002_r = piece 'rig_Raptor_Artillery_thigh_twist_dupli_002_r'
local cc_wing_L = piece 'rig_Raptor_Artillery_cc_wing_L'
local cc_wing_R = piece 'rig_Raptor_Artillery_cc_wing_R'
local c_thigh_b_l = piece 'rig_Raptor_Artillery_c_thigh_b_l'
local thigh_stretch_l = piece 'rig_Raptor_Artillery_thigh_stretch_l'
local leg_stretch_l = piece 'rig_Raptor_Artillery_leg_stretch_l'
local foot_l = piece 'rig_Raptor_Artillery_foot_l'
local leg_twist_l = piece 'rig_Raptor_Artillery_leg_twist_l'
local thigh_twist_l = piece 'rig_Raptor_Artillery_thigh_twist_l'

VFS.Include("scripts/include/springtweener.lua")

local scriptEnv = { root_x = root_x,
                    c_thigh_b_r = c_thigh_b_r,
                    thigh_stretch_r = thigh_stretch_r,
                    leg_stretch_r = leg_stretch_r,
                    foot_r = foot_r,
                    leg_twist_r = leg_twist_r,
                    thigh_twist_r = thigh_twist_r,
                    c_thigh_b_dupli_001_l = c_thigh_b_dupli_001_l,
                    thigh_stretch_dupli_001_l = thigh_stretch_dupli_001_l,
                    leg_stretch_dupli_001_l = leg_stretch_dupli_001_l,
                    foot_dupli_001_l = foot_dupli_001_l,
                    leg_twist_dupli_001_l = leg_twist_dupli_001_l,
                    thigh_twist_dupli_001_l = thigh_twist_dupli_001_l,
                    c_thigh_b_dupli_001_r = c_thigh_b_dupli_001_r,
                    thigh_stretch_dupli_001_r = thigh_stretch_dupli_001_r,
                    leg_stretch_dupli_001_r = leg_stretch_dupli_001_r,
                    foot_dupli_001_r = foot_dupli_001_r,
                    leg_twist_dupli_001_r = leg_twist_dupli_001_r,
                    thigh_twist_dupli_001_r = thigh_twist_dupli_001_r,
                    c_tail_00_x = c_tail_00_x,
                    c_tail_01_x = c_tail_01_x,
                    c_tail_02_x = c_tail_02_x,
                    c_tail_03_x = c_tail_03_x,
                    c_tail_04_x = c_tail_04_x,
                    c_thigh_b_dupli_002_l = c_thigh_b_dupli_002_l,
                    thigh_stretch_dupli_002_l = thigh_stretch_dupli_002_l,
                    leg_stretch_dupli_002_l = leg_stretch_dupli_002_l,
                    foot_dupli_002_l = foot_dupli_002_l,
                    leg_twist_dupli_002_l = leg_twist_dupli_002_l,
                    thigh_twist_dupli_002_l = thigh_twist_dupli_002_l,
                    c_thigh_b_dupli_002_r = c_thigh_b_dupli_002_r,
                    thigh_stretch_dupli_002_r = thigh_stretch_dupli_002_r,
                    leg_stretch_dupli_002_r = leg_stretch_dupli_002_r,
                    foot_dupli_002_r = foot_dupli_002_r,
                    leg_twist_dupli_002_r = leg_twist_dupli_002_r,
                    thigh_twist_dupli_002_r = thigh_twist_dupli_002_r,
                    cc_wing_L = cc_wing_L,
                    cc_wing_R = cc_wing_R,
                    c_thigh_b_l = c_thigh_b_l,
                    thigh_stretch_l = thigh_stretch_l,
                    leg_stretch_l = leg_stretch_l,
                    foot_l = foot_l,
                    leg_twist_l = leg_twist_l,
                    thigh_twist_l = thigh_twist_l,
                    ---
					rad = math.rad,
					x_axis = x_axis,
					y_axis = y_axis,
					z_axis = z_axis,
					Turn = Turn,
					Move = Move,
					WaitForMove = WaitForMove,
					WaitForTurn = WaitForTurn,
					Sleep = Sleep,
					Show = Show,
					Hide = Hide,
					initTween = initTween,
					---
					Rand = math.random,
					Explode = Spring.UnitScript.Explode,
					sfxShatter = SFX.SHATTER,
					sfxFall = SFX.FALL,
					sfxFire = SFX.FIRE,
					sfxSmoke = SFX.SMOKE,
					sfxExplodeOnHit = SFX.EXPLODE_ON_HIT,
					---
					--stdNanoPieces = pointer,
					--advNanoPieces = advpointer,
					--standardOnlyPieces = { right_arm, left_arm, right_head, left_head },
					--upgradeOnlyPieces = { right_arm_advanced, left_arm_advanced, right_head_advanced, left_head_advanced,
					--					  left_pointer1, left_pointer2, right_pointer1, right_pointer2, antenna_upgrade,
					--					  upgradeR, upgradeL, upgradeR_door, upgradeL_door },
					--explodePartsDefault = { right_arm, left_arm },
					--explodePartsStandard = { left_head, right_head, antenna_axis },
					--explodePartsAdvanced = { upgradeR, upgradeL, upgradeR_door, upgradeL_door },
	--
					ipairs = ipairs,
					unitID = unitID,
					unitDefName = UnitDefs[unitDefID].name,
					UnitScript = UnitScript,
					Spring = Spring,
					COB = COB,
					SFX = SFX,
}

local PlayAnimation = VFS.Include("scripts/animations/raptorartillery_anim.lua", scriptEnv)
--scriptEnv.PlayAnimation = PlayAnimation
--script_create, script_activate, script_deactivate, script_killed, MorphUp, MorphUp2, MorphUp3 = VFS.Include("scripts/include/factory_base.lua", scriptEnv)

local function create()
    Signal(1) -- Kill any other copies of this thread
    SetSignalMask(1) -- Allow this thread to be killed by fresh copies
    PlayAnimation.create()
end

function script.Create()
    --StartThread(function ()
    --    initTween({veryLastFrame=36,
    --               [antenna_base]={
    --                   [1]={cmd="move", axis=z_axis, targetValue=15.000000, firstFrame=0, lastFrame=36,},
    --               }
    --    })
    --end)
    StartThread(create)
end

function script.Activate()
    --initTween({veryLastFrame=36,
    --           [antenna_base]={
    --               [1]={cmd="move", axis=z_axis, targetValue=15.000000, firstFrame=0, lastFrame=36,},
    --           }
    --})
    StartThread(create)
end

function script.Deactivate()
    --initTween({veryLastFrame=20,
    --           [antenna_base]={
    --               [1]={cmd="move", axis=z_axis, targetValue=0.000000, firstFrame=0, lastFrame=20,},
    --           }
    --})
	--script_deactivate()
end

--function script.Killed(recentDamage, maxHealth)
--	script_killed(recentDamage, maxHealth)
--end

-- Assign the desired buildpiece to the variable above
--function script.QueryBuildInfo()
--	if buildPiece then
--		return buildPiece
--	else
--		return base
--	end
--end
