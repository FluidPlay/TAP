return {
    --{
    --    ['time'] = 1,
    --    ['commands'] = {
    --        {['c']='turn',['p']=NWRoot, ['a']=y_axis, ['t']=rad(-120), ['s']=nil},
    --        {['c']='turn',['p']=NERoot, ['a']=y_axis, ['t']=rad(120), ['s']=nil},
    --        ---
            {['c']='turn',['p']=SolarLeafBotS, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
            {['c']='turn',['p']=SolarLeafBotNE, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
            {['c']='turn',['p']=SolarLeafBotNW, ['a']=x_axis, ['t']=-0.051759, ['s']=0.388195},
            {['c']='turn',['p']=SolarLeafBotNETip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
            {['c']='turn',['p']=SolarLeafBotNETip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
            {['c']='turn',['p']=SolarLeafBotNETip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
            {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
            {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
            {['c']='turn',['p']=SolarLeafBotNWTip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
            {['c']='turn',['p']=SolarLeafBotSTip, ['a']=x_axis, ['t']=0.013818, ['s']=0.103638},
            {['c']='turn',['p']=SolarLeafBotSTip, ['a']=y_axis, ['t']=0.000618, ['s']=0.004637},
            {['c']='turn',['p']=SolarLeafBotSTip, ['a']=z_axis, ['t']=0.000618, ['s']=0.004637},
    --    }
    --},
    {
        ['time'] = 0,
        ['commands'] = {
            --{['c']='move',['p']=Scene, ['a']=y_axis, ['t']=45},
            --{['c']='turn',['p']=Scene, ['a']=x_axis, ['t']=rad(90)}, --, ['s']=0.0
            --{['c']='turn',['p']=Scene, ['a']=y_axis, ['t']=rad(180)},
        }
    },
    {
        ['time'] = 1,
        ['commands'] = {
            --{['c']='turn',['p']=paperplane, ['a']=x_axis, ['t']=rad(90)}, --, ['s']=0.0
            --{['c']='turn',['p']=paperplane, ['a']=y_axis, ['t']=rad(-180)},
            --
            {['c']='turn',['p']=paperplane, ['a']=x_axis, ['t']=rad(-60), ['s']=0.537024},   --x in Blender, reversed signal
            {['c']='turn',['p']=paperplane, ['a']=y_axis, ['t']=rad(30), ['s']=0.537024},     --z in Blender, same signal
            {['c']='turn',['p']=paperplane, ['a']=z_axis, ['t']=rad(60), ['s']=0.537024},   --y in Blender, same signal


            --{['c']='turn',['p']=paperplane, ['a']=x_axis, ['t']=0.698132, ['s']=0.537024},
            ----{['c']='turn',['p']=paperplane, ['a']=y_axis, ['t']=0.523599, ['s']=0.537024},
            --{['c']='turn',['p']=paperplane, ['a']=z_axis, ['t']=-0.698132, ['s']=0.537024},
        }
    },
}
