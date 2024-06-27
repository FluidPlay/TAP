-- meteor_tag

return {
  ["alien-shot"] = {
    glow = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      underwater         = 0,
      water              = false, --true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[1.0 1.0 1.0 0.5  0.5 0.5 0.5 0.01  0.5 0.5 0.5 0.005]],
        directional        = true,
        emitrot            = 0,
        --emitrotspread      = [[20 r-20 r20]],
        emitvector         = [[dir]], ---[[0,1,0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 1,
        particlelife       = 2, --1800,
        particlelifespread = 2,
        particlesize       = 8, --7,
        particlesizespread = 1,
        particlespeed      = 0.75, --18,  ---[[6 i0.95]],
        particlespeedspread = 0.1,
        animParams         = [[4,1,8]], --x, y, dur
        --rotParams          = [[0, 0, -60 r120]],  --- [[0, 0, -180 r360]], --- [[-60 r120, -30 r60, -180 r360]],
        pos                = [[0, 0, 0]],
        --sizegrowth         = [[-0.25 r0.25]],  ---0.21,
        sizemod            = 1.0,
        texture            = [[alien-shot]],
        useairlos          = true,
        alwaysvisible      = true,
      },
    },
    trail = {
      class              = [[CExpGenSpawner]],
      count              = 1,
      nounit             = 1,
      properties = {
        delay              = [[0]],
        dir                = [[dir]],
        explosiongenerator = [[custom:alien_trail]],
        pos                = [[0, 0, 0]],
      },
    },
  },

  ["alien_trail"] = {
    usedefaultexplosions = false,
    fire = {
      air = true,
      class = [[CSimpleParticleSystem]],
      count = 1,
      ground = true,
      water = true,
      properties = {
        airdrag = 0.9,
        alwaysvisible = true,
        colormap = [[0.01 0.01 0.01 0.015  0.1 0.1 0.1 0.4  0 0 0 0.01]],
        directional = true,
        emitrot = 0,
        emitrotspread = 5,
        emitvector = [[dir]],
        gravity = [[0, -1.05, 0]],
        numparticles = 1,
        particlelife = 13,
        particlelifespread = 5,
        particlesize = 2, --4,
        particlesizespread = 0.5, --4,
        particlespeed = 20, --25,
        particlespeedspread = 6,
        pos = [[0, 0, 0]],
        --sizegrowth = [[-0.25 r0.25]],  --1.9
        sizemod = 1,
        texture = [[fireball]],
      },
    },
  }

}

