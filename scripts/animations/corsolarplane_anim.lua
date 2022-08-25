return {
    --{
    --    ['time'] = 1,
    --    ['commands'] = {
    --        {['c']='turn',['p']=NWRoot, ['a']=y_axis, ['t']=rad(-120), ['s']=nil},
    --        {['c']='turn',['p']=NERoot, ['a']=y_axis, ['t']=rad(120), ['s']=nil},
    --        ---
    --        {['c']='turn',['p']=SolarLeafBotS, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
    --        {['c']='turn',['p']=SolarLeafBotNE, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
    --        {['c']='turn',['p']=SolarLeafBotNW, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
    --        {['c']='turn',['p']=SolarLeafBotNETip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
    --        {['c']='turn',['p']=SolarLeafBotNETip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
    --        {['c']='turn',['p']=SolarLeafBotNETip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
    --        {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
    --        {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
    --        {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
    --        {['c']='turn',['p']=SolarLeafBotSTip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
    --        {['c']='turn',['p']=SolarLeafBotSTip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
    --        {['c']='turn',['p']=SolarLeafBotSTip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
    --    }
    --},
    {
        ['time'] = 1,
        ['commands'] = {
            {['c']='turn',['p']=paperplane, ['a']=x_axis, ['t']=0.698132, ['s']=0.537024},
            {['c']='turn',['p']=paperplane, ['a']=z_axis, ['t']=-0.698132, ['s']=0.537024},
        }
    },
}

--function constructSkeleton(unit, piece, offset)
--    if (offset == nil) then
--    offset = {0,0,0};
--    end
--
--    local bones = {};
--    local info = Spring.GetUnitPieceInfo(unit,piece);
--
--    for i=1,3 do
--        info.offset[i] = offset[i]+info.offset[i];
--    end
--
--    bones[piece] = info.offset;
--    local map = Spring.GetUnitPieceMap(unit);
--    local children = info.children;
--
--    if (children) then
--        for i, childName in pairs(children) do
--            local childId = map[childName];
--            local childBones = constructSkeleton(unit, childId, info.offset);
--            for cid, cinfo in pairs(childBones) do
--                bones[cid] = cinfo;
--            end
--        end
--    end
--    return bones;
--end
--
--function script.Create()
--    local map = Spring.GetUnitPieceMap(unitID);
--    local offsets = constructSkeleton(unitID,map.Scene, {0,0,0});
--
--    for a,anim in pairs(Animations) do
--        for i,keyframe in pairs(anim) do
--            local commands = keyframe.commands;
--            for k,command in pairs(commands) do
--                -- commands are described in (c)ommand,(p)iece,(a)xis,(t)arget,(s)peed format
--                -- the t attribute needs to be adjusted for move commands from blender's absolute values
--                if (command.c == "move") then
--                    local adjusted =  command.t - (offsets[command.p][command.a]);
--                    Animations[a][i]['commands'][k].t = command.t - (offsets[command.p][command.a]);
--                end
--            end
--        end
--    end
--end

--local animCmd = {['turn']=Turn,['move']=Move};
--
--function PlayAnimation(animname, x_axis, y_axis, z_axis)
--    local anim = Animations[animname];
--    for i = 1, #anim do
--        local commands = anim[i].commands;
--        for j = 1,#commands do
--            local cmd = commands[j];
--            Spring.Echo("Has cmd # "..j..": "..(cmd and "yes" or "no").." | c,p,a,t,s: "..(cmd.c or "nil").." "
--                    ..(cmd.p or "nil").." "..(cmd.a or "nil").." "..(cmd.t or "nil").." "..(cmd.s or "nil"))
--            animCmd[cmd.c](cmd.p,cmd.a,cmd.t,cmd.s);
--        end
--        if(i < #anim) then
--            local t = anim[i+1]['time'] - anim[i]['time'];
--            Sleep(t*33); -- sleep works on milliseconds
--        end
--    end
--end
