-- nanoharvest

return {
  ["nanoharvest"] =
  {
      bitmapmuzzleflame = {
          air                = true,
          class              = [[CBitmapMuzzleFlame]],
          count              = 1,
          ground             = true,
          underwater         = 1,
          water              = true,
          properties = {
              colormap           = [[0.5 0.7 0.6 0.01   0.2 0.9 0.5 0.01   0 0 0 0.01]],
              dir                = [[dir]],
              frontoffset        = 0.05,
              fronttexture       = [[empty]],
              length             = 2, --10, --60
              sidetexture        = [[flashside2]],
              size               = 3, --3
              sizegrowth         = 0.5,          ---[[0.2 r0.3]] | 1.2
              ttl                = 1, --10
          },
      },
      --waterball = {
      --    air                = false,
      --    class              = [[CSimpleParticleSystem]],
      --    count              = 1,
      --    ground             = true,
      --    underwater         = 1,
      --    water              = true,
      --    properties = {
      --        airdrag            = 0.75,
      --        colormap           = [[0 0 0 0    0.25 0.25 0.25 .01    0 0 0 0.01]],
      --        directional        = true,
      --        emitrot            = -180,
      --        emitrotspread      = 6,
      --        emitvector         = [[dir]],
      --        gravity            = [[0.0, 0.1, 0.0]],
      --        numparticles       = 2,
      --        particlelife       = 10,
      --        particlelifespread = 25,
      --        particlesize       = 0.8,
      --        particlesizespread = 1.2,
      --        particlespeed      = [[1 r2 i-0.05]],
      --        particlespeedspread = 3.5,
      --        pos                = [[0 r-12 r12, 5 r15, 0 r-12 r12]],
      --        sizegrowth         = 0.02,
      --        sizemod            = 1.0,
      --        texture            = [[dirt]],
      --        useairlos          = true,
      --    },
      --},
  },
}

