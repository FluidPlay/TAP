--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function widget:GetInfo()
    return {
        name      = "Gfx - Set Nanos",
        desc      = "Sets nano particles rotation parameters",
        author    = "MaDDoX",
        date      = "Aug 2021",
        license   = "GNU GPL, v2 or later",
        version   = 1,
        layer     = -100,
        enabled   = true  --  loaded by default?
    }
end

local math_random = math.random

function widget:Initialize()
    if not Spring.SetNanoProjectileParams then --checking if it has support for the command
        widgetHandler:RemoveWidget(self)
    end
    -- 1st ver - Spring.SetNanoProjectileParams(math_random(0,359), 0, 0.5)  -- startRot, accel, speed |deg, deg/s2, deg/s|
    --SetNanoProjectileParams(startRotation, rotationSpeed, rotationAcceleration, startRotationRng, rotationSpeedRng, rotationAccelerationRng)
    Spring.SetNanoProjectileParams(1, 60, 5, 120, 300, 550)
end

--function widget:Update()
--        --Spring.Echo("Setting Nano Projectile rotation Params")
--        Spring.SetNanoProjectileParams(math_random(0,359), 0, 0.5)  -- startRot, accel, speed |deg, deg/s2, deg/s|
--        --rotVal0, rotVel0, rotAcc
--end



