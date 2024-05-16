--//=============================================================================

Panel = Control:Inherit{
  classname= "panel",
  defaultWidth  = 100,
  defaultHeight = 100,
  padding         = {7, 7, 7, 7}, --left, top, right, bottom
  noFont = true,
}

local this = Panel
local inherited = this.inherited

--//=============================================================================
