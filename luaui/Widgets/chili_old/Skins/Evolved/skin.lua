--//=============================================================================
--// Skin

local skin = {
  info = {
    name    = "Evolved",
    version = "0.3", -- "0.33" by MaDDoX (HiDPI version)
    author  = "jK",
  }
}

--//=============================================================================
--//


local defBackgroundColor = {0.66, 0.58, 0.20, 0.95}
local defFocusColor  = {0.70, 0.62, 0.20, 0.9}
local defBorderColor = {0.70, 0.62, 0.20, 0.15}
local defPressBackgroundColor = {0.62, 0.565, 0.14, 0.85}

local defTileScale = {0.1, 0.1}

skin.general = {
  focusColor  = defFocusColor, --{0.94, 0.50, 0.23, 1},
  borderColor = defBorderColor, --{1.0, 1.0, 1.0, 1.0},

  font = {
	font    = SKINDIR .. "fonts/GeogrotesqueCompMedium.otf", --n019003l.pfb",
    color        = {1,1,1,1},
    outlineColor = {0.05,0.05,0.05,0.9},
    outline = false,
    shadow  = true,
    size    = 16, --13
  },

  padding         = {7, 10, 7, 7}, --// padding: left, top, right, bottom
  --padding         = {14, 20, 14, 14}, --// padding: left, top, right, bottom
}


skin.icons = {
  imageplaceholder = ":cn:placeholder.png",
}

-- Main button colors
skin.button = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  --tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  --tiles = {254, 156, 254, 123},
  tiles = {127, 78, 127, 62},
  padding = {15, 15, 15, 15},

	--local skHorScale, skVertScale = unpack2(obj.tileScale)
  	--tileScale = {0.2, 0.2},

  --backgroundColor = {0.46, 0.38, 0.20, 0.95},
  --focusColor  = {0.50, 0.42, 0.20, 0.9},
  --borderColor = {0.50, 0.42, 0.20, 0.15},
  --pressBackgroundColor = {0.42, 0.365, 0.14, 0.85},

  backgroundColor = 		defBackgroundColor, 		--{0.66, 0.58, 0.20, 0.95},
  focusColor  = 			defFocusColor, 				--{0.70, 0.62, 0.20, 0.9},
  borderColor = 			defBorderColor, 			--{0.70, 0.62, 0.20, 0.15},
  pressBackgroundColor = 	defPressBackgroundColor, 	--{0.62, 0.565, 0.14, 0.85},

  DrawControl = DrawButton,
}


skin.button_tiny = {
  TileImageBK = ":cn:tech_button_bright_tiny_bk.png",
  TileImageFG = ":cn:tech_button_bright_tiny_fg.png",
  tiles = {65, 68, 62, 44},		--{6, 6, 6, 6}, --// tile widths: left,top,right,bottom
  padding = {10, 10, 10, 10},

  backgroundColor = 		defBackgroundColor,
  focusColor  = 			defFocusColor,
  borderColor = 			defBorderColor,
  pressBackgroundColor = 	defPressBackgroundColor,

  DrawControl = DrawButton,
}

skin.overlay_button = {
  TileImageBK = ":cn:tech_button_small_bk.png",
  TileImageFG = ":cn:tech_button_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor =	defBackgroundColor, -- {0, 0, 0, 0.7},
  focusColor  = 	defFocusColor, -- {0.94, 0.50, 0.23, 0.7},
  borderColor = 	defBorderColor, -- {1,1,1,0},

  DrawControl = DrawButton,
}

skin.overlay_button_tiny = {
  TileImageBK = ":cn:tech_button_tiny_bk.png",
  TileImageFG = ":cn:tech_button_tiny_fg.png",
  tiles = {6, 6, 6, 6}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor =	defBackgroundColor, -- {0, 0, 0, 0.7},
  focusColor  = 	defFocusColor, -- {0.94, 0.50, 0.23, 0.7},
  borderColor = 	defBorderColor, -- {1,1,1,0},

  DrawControl = DrawButton,
}

skin.button_square = {
  TileImageBK = ":cn:tech_button_action_bk.png",
  TileImageFG = ":cn:tech_button_action_fg.png",
  tiles = {11, 11, 11, 11}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor = 	defBackgroundColor, -- {0, 0, 0, 0.7},
  focusColor  = 		defFocusColor, -- {0.94, 0.50, 0.23, 0.7},
  borderColor = 		defBorderColor, -- {1,1,1,0},

  DrawControl = DrawButton,
}

skin.button_tab = {
  -- yes these are reverted, but also a lie (see images), only one is used
  TileImageFG = ":cn:tech_tabbaritem_fg.png",
  TileImageBK = ":cn:tech_tabbaritem_bk.png",
  tiles = {5, 5, 5, 0}, --// tile widths: left,top,right,bottom
  padding = {1, 1, 1, 2},
  -- since it's color multiplication, it's easier to control white color (1, 1, 1) than black color (0, 0, 0) to get desired results
  backgroundColor = {0, 0, 0, 1.0},
  -- actually kill this anyway
  --borderColor     = {0.46, 0.54, 0.68, 0.4},
  --focusColor      = {0.46, 0.54, 0.68, 1.0},
  focusColor  = 		defFocusColor,
  borderColor = 		defBorderColor,

  DrawControl = DrawButton,
}

skin.button_large = {
  TileImageBK = ":cn:tech_button_bk.png",
  TileImageFG = ":cn:tech_button_fg.png",
  tiles = {60, 30, 60, 30}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor = 	defBackgroundColor, -- {0, 0, 0, 0.7},
  focusColor  = 		defFocusColor, -- {0.94, 0.50, 0.23, 0.7},
  borderColor = 		defBorderColor, -- {1,1,1,0},

  DrawControl = DrawButton,
}

skin.button_highlight = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0.2, 0.25, 0.35, 0.7},
  --focusColor  = {0.3, 0.375, 0.525, 0.5},
  --borderColor = {1,1,1,0},

  backgroundColor = 	defBackgroundColor,
  focusColor  = 		defFocusColor,
  borderColor = 		defBorderColor,

  DrawControl = DrawButton,
}

skin.button_square = {
  TileImageBK = ":cn:tech_button_action_bk.png",
  TileImageFG = ":cn:tech_button_action_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0, 0, 0, 0.7},
  --focusColor  = {0.94, 0.50, 0.23, 0.4},
  --borderColor = {1,1,1,0},
  backgroundColor = 	defBackgroundColor,
  focusColor  = 		defFocusColor,
  borderColor = 		defBorderColor,

  DrawControl = DrawButton,
}

skin.action_button = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0.98, 0.48, 0.26, 0.65},
  --focusColor  = {0.98, 0.48, 0.26, 0.9},
  --borderColor = {0.98, 0.48, 0.26, 0.15},
  backgroundColor = 	defBackgroundColor,
  focusColor  = 		defFocusColor,
  borderColor = 		defBorderColor,

  DrawControl = DrawButton,
}

skin.option_button = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0.21, 0.53, 0.60, 0.65},
  --focusColor  = {0.21, 0.53, 0.60, 0.9},
  --borderColor = {0.21, 0.53, 0.60, 0.15},
  backgroundColor = 	defBackgroundColor,
  focusColor  = 		defFocusColor,
  borderColor = 		defBorderColor,

  DrawControl = DrawButton,
}

local negBackgroundColor = {0.85, 0.05, 0.25, 0.65}
local negFocusColor  = {0.85, 0.05, 0.25, 0.9}
local negBorderColor = {0.85, 0.05, 0.25, 0.15}

local disBackgroundColor = {0.2, 0.2, 0.2, 0.65}
local disFocusColor  = {0, 0, 0, 0}
local disBorderColor = {0.2, 0.2, 0.2, 0.15}

skin.negative_button = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0.85, 0.05, 0.25, 0.65},
  --focusColor  = {0.85, 0.05, 0.25, 0.9},
  --borderColor = {0.85, 0.05, 0.25, 0.15},
  backgroundColor = 	negBackgroundColor,
  focusColor  = 		negFocusColor,
  borderColor = 		negBorderColor,

  DrawControl = DrawButton,
}

skin.button_disabled = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  --backgroundColor = {0.2, 0.2, 0.2, 0.65},
  --focusColor  = {0, 0, 0, 0},
  --borderColor = {0.2, 0.2, 0.2, 0.15},
  backgroundColor = 	disBackgroundColor,
  focusColor  = 		disFocusColor,
  borderColor = 		disBorderColor,

  DrawControl = DrawButton,
}

skin.combobox = {
	TileImageBK = ":cn:combobox_ctrl.png",
	TileImageFG = ":cn:combobox_ctrl_fg.png",
	TileImageArrow = ":cn:combobox_ctrl_arrow.png",
	tiles   = {11, 11, 24, 11},
	padding = {5, 5, 12, 5},

	--backgroundColor = {1, 1, 1, 0.7},
	--borderColor = {1,1,1,0},
	backgroundColor = 	disBackgroundColor,
	borderColor = 		disBorderColor,

	DrawControl = DrawComboBox,
}


skin.combobox_window = {
	clone     = "window";
	TileImage = ":cn:combobox_wnd.png";
	tiles     = {1, 1, 1, 1};
	padding   = {1, 1.5, 1.5, 2};
}


skin.combobox_scrollpanel = {
	clone       = "scrollpanel";
	borderColor = {1, 1, 1, 0};
	padding     = {0, 0, 0, 0};
}


skin.combobox_item = {
	clone       = "button";
	borderColor = {1, 1, 1, 0};
}


skin.checkbox = {
  TileImageFG = ":cn:checkbox_arrow.png",
  TileImageBK = ":cn:checkbox.png",
  TileImageFG_round = ":cn:radiobutton_checked.png",
  TileImageBK_round = ":cn:radiobutton.png",
  tiles       = {1.5,1.5,1.5,1.5},
  boxsize     = 13,

  DrawControl = DrawCheckbox,
}


skin.editbox = {
  hintFont = table.merge({color = {1,1,1,0.7}}, skin.general.font),

  backgroundColor = {0.1, 0.1, 0.1, 0},
  cursorColor     = {1.0, 0.7, 0.1, 0.8},

  focusColor  = {1, 1, 1, 1},
  borderColor = {1, 1, 1, 0.6},

  TileImageBK = ":cn:panel2_bg.png",
  TileImageFG = ":cn:editbox_border.png",
  tiles       = {1, 1, 1, 1},
  cursorFramerate = 1, -- Per second

  DrawControl = DrawEditBox,
}

skin.textbox = {
  hintFont = table.merge({color = {1,1,1,0.7}}, skin.general.font),

  TileImageBK = ":cn:panel2_bg.png",
  bkgndtiles = {14,14,14,14},

  TileImageFG = ":cn:panel2_border.png",
  tiles       = {1, 1, 1, 1},

  borderColor     = {0.0, 0.0, 0.0, 0.0},
  focusColor      = {0.0, 0.0, 0.0, 0.0},

  DrawControl = DrawEditBox,
}

skin.imagelistview = {
  imageFolder      = "folder.png",
  imageFolderUp    = "folder_up.png",

  --DrawControl = DrawBackground,

  colorBK          = {1,1,1,0.3},
  colorBK_selected = {1,0.7,0.1,0.8},

  colorFG          = {0, 0, 0, 0},
  colorFG_selected = {1,1,1,1},

  imageBK  = ":cn:node_selected_bw.png",
  imageFG  = ":cn:node_selected.png",
  tiles    = {4.5, 4.5, 4.5, 4.5},
  tileScale = defTileScale,

  DrawItemBackground = DrawItemBkGnd,
}
--[[
skin.imagelistviewitem = {
  imageFG = ":cn:glassFG.png",
  imageBK = ":cn:glassBK.png",
  tiles = {17,15,17,20},

  padding = {12, 12, 12, 12},

  DrawSelectionItemBkGnd = DrawSelectionItemBkGnd,
}
--]]

skin.panel = {
	--TileImageBK = ":cn:panel_bow_small.png", --":cn:tech_mainwindow.png",
	--TileImageFG = ":cn:empty.png",
	--tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
	--padding = {60, 62, 60, 54},
	--hitpadding = {4, 4, 4, 4},
	--
	----captionColor = {1, 1, 1, 0.45},
	--backgroundColor = {0.1, 0.1, 0.1, 0.7},
	--
	--DrawControl = DrawPanel,

  TileImageBK = ":cn:panel_bow_small.png", --":cn:tech_overlaywindow.png",
  TileImageFG = ":cn:empty.png",
  tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
  tileScale = defTileScale,
  backgroundColor = {1, 1, 1, 0.7},

  DrawControl = DrawPanel,
}

skin.panel_internal = {
  TileImageBK = ":cn:tech_button_bright_tiny_bk.png",	--tech_overlaywindow.png
  TileImageFG = ":cn:empty.png",
  tiles = {1, 1, 1, 1},
  tileScale = defTileScale, --{0.2, 0.2},

  backgroundColor = {1, 1, 1, 0.6},

  DrawControl = DrawPanel,
}

skin.panel_button = {
  TileImageBK = ":cn:tech_button_bright_small_bk.png",
  TileImageFG = ":cn:tech_button_bright_small_fg.png",
  tiles = {10, 7, 10, 7}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor = defBackgroundColor, --{0.2, 0.25, 0.35, 0.7},
  focusColor  = 	defFocusColor, 		 --{0.3, 0.375, 0.525, 0.5},
  borderColor = 	defBorderColor,		 --{1,1,1,0},

  DrawControl = DrawPanel,
}

skin.panel_button_rounded = {
  TileImageBK = ":cn:tech_button_rounded.png",
  TileImageFG = ":cn:tech_buttonbk_rounded.png",
  tiles = {16, 16, 16, 16}, --// tile widths: left,top,right,bottom
  padding = {5, 5, 5, 5},

  backgroundColor = {1, 1, 1, 1.0},
  focusColor  = {0.3, 0.375, 0.525, 0.5},
  borderColor = {1,1,1,0},

  DrawControl = DrawPanel,
}

skin.panelSmall = {
  TileImageBK = ":cn:tech_button.png",
  TileImageFG = ":cn:empty.png",
  tiles = {1, 1, 1, 1},
  tileScale = defTileScale, --{0.2, 0.2},

  DrawControl = DrawPanel,
}

skin.overlay_panel = {
  TileImageBK = ":cn:tech_overlaywindow.png",
  TileImageFG = ":cn:empty.png",
  tiles = {1, 1, 1, 1}, --// tile widths: left,top,right,bottom
  tileScale = defTileScale, -- {0.2, 0.2},
  backgroundColor = {1, 1, 1, 0.7},

  DrawControl = DrawPanel,
}

--- These two are the base table for all the 'fancy' (9-slice) panels, overrides are set below
local fancyBase = {
  TileImageFG = ":cn:empty.png",
  tiles = {16, 16, 16, 16}, --// tile widths: left,top,right,bottom
  tileSize = {0.2,0.2},
  tileScale = defTileScale, -- {0.2, 0.2},
  DrawControl = DrawPanel,
  backgroundColor = {1,1,1,1},
}

local fancySmallBase = {
  TileImageFG = ":cn:empty.png",
  tiles = {8, 8, 8, 8},
  tileSize = {0.2,0.2},
  DrawControl = DrawPanel,
  backgroundColor = {1,1,1,1},
}

--- ---
----- If it's a string entry, skin[name].TileImageBK = ":cn:" .. name .. ".png"
----- [2] => "tiles" definition; [3] => "padding" definition; [4] => "tileScale" def (optional)
--tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
--padding = {60, 62, 60, 54},
--tileScale = {0.2, 0.2},
local fancyPanels = {
	{"mainwindow", {15,15,15,15}, {5,5,5,5}},	-- Test one (added by MaDDoX)
	{"bow_small", {550, 420, 547, 424}, {18,18,18,18}},
--	{"bow_tall", {418, 870, 418, 874}, {18,18,18,18}},	-- resulting image name => panel_bow_tall.png
--	{"bow_wide", {1108, 400, 1098, 426}, {18,18,18,18}},
	{"bow_tall", {209, 435, 209, 437}, {18,18,18,18}},	-- resulting image name => panel_bow_tall.png
	{"bow_wide", {554, 200, 549, 213}, {18,18,18,18}},
	----
	{"0100", {15, 4, 15, 1}, {0, 8, 0, 0}},	-- TileImageBK, tiles, padding
	{"0110", {78, 18, 1, 1}, {0, 20, 0, 0}},
	{"1100", {1, 18, 78, 1}, {0, 20, 0, 0}},
	{"0120", {106, 18, 106, 1}, {12, 32, 0, 0}},
	{"2100", {106, 18, 106, 1}, {0, 32, 12, 0}},
	{"1011", {86, 1, 86, 18}, {16, 0, 16, 8}},
	{"2011", {106, 1, 4, 18}, {8, 0, 16, 8}},
	{"1021", {4, 1, 106, 18}, {16, 0, 8, 8}},
	--
	-- Original: LoDPI, Small margins version:
	--{"0100", {30, 8, 30, 1}, {0, 4, 0, 0}},	-- TileImageBK, tiles, padding
	--{"0110", {156, 36, 1, 1}, {0, 10, 0, 0}},
	--{"1100", {1, 36, 156, 1}, {0, 10, 0, 0}},
	--{"0120", {212, 36, 212, 1}, {6, 16, 0, 0}},
	--{"2100", {212, 36, 212, 1}, {0, 16, 6, 0}},
	--{"1011", {172, 1, 172, 37}, {8, 0, 8, 4}},
	--{"2011", {172, 1, 8, 37}, {4, 0, 8, 4}},
	--{"1021", {8, 1, 172, 37}, {8, 0, 4, 4}},
	--
	-- LoDPI, Large margins version:
	--{"0100", {30, 8, 30, 1}, {10, 14, 10, 10}},	-- TileImageBK, tiles, padding
	--{"0110", {156, 36, 1, 1}, {10, 20, 10, 10}},
	--{"1100", {1, 36, 156, 1}, {10, 20, 10, 10}},
	--{"0120", {212, 36, 212, 1}, {16, 26, 10, 10}},
	--{"2100", {212, 36, 212, 1}, {10, 26, 16, 10}},
	--{"1011", {172, 1, 172, 37}, {18, 10, 18, 14}},
	--{"2011", {172, 1, 8, 37}, {14, 10, 18, 14}},
	--{"1021", {8, 1, 172, 37}, {18, 10, 14, 14}},
}

local fancyPanelsSmall = {
	{"0011_small", {43, 1, 25, 2}, {24, 0, 0, 12}},
	{"1001_small", {25, 1, 43, 2}, {0, 0, 24, 12}},
	{"0110_small", {15, 9, 1, 1}, {24, 8, 0, 0}},
	{"1100_small", {1, 9, 15, 1}, {0, 8, 24, 0}},
	{"0120_small", {20, 9, 20, 1}, {0, 20, 0, 0}},
	{"2100_small", {20, 9, 20, 1}, {0, 20, 0, 0}},
	{"0001_small", {23, 1, 23, 5}, {0, 0, 0, 12}},

	--{"0011_small", {87, 1, 51, 5}, {12, 0, 0, 6}},
	--{"1001_small", {51, 1, 87, 5}, {0, 0, 12, 6}},
	--{"0110_small", {29, 18, 1, 1}, {12, 4, 0, 0}},
	--{"1100_small", {1, 18, 29, 1}, {0, 4, 12, 0}},
	--{"0120_small", {40, 18, 40, 1}, {0, 10, 0, 0}},
	--{"2100_small", {40, 18, 40, 1}, {0, 10, 0, 0}},
	--{"0001_small", {46, 1, 46, 10}, {0, 0, 0, 6}},
}

local fancyPanelsLarge = {
	{"0110_large", {39, 9, 1, 1}, {6, 5, 0, 0}},
	{"1100_large", {1, 9, 39, 1}, {0, 5, 6, 0}},

	--{"0110_large", {78, 18, 1, 1}, {11, 7, 0, 0}},
	--{"1100_large", {1, 18, 78, 1}, {0, 7, 11, 0}},
}

local function LoadPanels(panelList)
	for i = 1, #panelList do
		if type(fancyPanels[i]) == "string" then
			local name = "panel_" .. panelList[i]
			skin[name] = Spring.Utilities.CopyTable(fancyBase)
			skin[name].TileImageBK = ":cn:" .. name .. ".png"
		else
			local name = "panel_" .. panelList[i][1]
			skin[name] = Spring.Utilities.CopyTable(fancyBase)		-- init Values, set on fancyBase
			skin[name].tiles = panelList[i][2]
			skin[name].padding = panelList[i][3]
			if (panelList[i][4]) then
				skin[name].tileScale = panelList[i][4] end
			skin[name].TileImageBK = ":cn:" .. name .. ".png"
		end
	end
end

LoadPanels(fancyPanels)
LoadPanels(fancyPanelsSmall)
LoadPanels(fancyPanelsLarge)

for i = 1, #fancyPanelsSmall do
	if type(fancyPanelsSmall[i]) == "string" then		-- Only one element (the first) is string, used to name the item
		local name = "panel_" .. fancyPanelsSmall[i]
		skin[name] = Spring.Utilities.CopyTable(fancySmallBase)
		skin[name].TileImageBK = ":cn:" .. name .. ".png"		--cl
	else												-- Remaining elements are tables
		local name = "panel_" .. fancyPanelsSmall[i][1]
		skin[name] = Spring.Utilities.CopyTable(fancySmallBase)
		skin[name].tiles = fancyPanelsSmall[i][2]
		skin[name].padding = fancyPanelsSmall[i][3]
		if (fancyPanelsSmall[i][4]) then
			skin[name].tileScale = fancyPanelsSmall[i][4] end
		skin[name].TileImageBK = ":cn:" .. name .. ".png" --":cl:"
	end
end

skin.progressbar = {
  TileImageFG = ":cn:tech_progressbar_full.png",
  TileImageBK = ":cn:tech_progressbar_empty.png",
  tiles       = {14, 8, 14, 8},
  tileScale = {0.2, 0.2},
  fillPadding     = {4, 3, 4, 3},

  font = {
    shadow = true,
  },

  DrawControl = DrawProgressbar,
}

skin.multiprogressbar = {
  fillPadding     = {4, 3, 4, 3},
}

skin.scrollpanel = {
  BorderTileImage = ":cn:panel2_border.png",
  bordertiles = {2,2,2,2},

  BackgroundTileImage = ":cn:panel2_bg.png",
  bkgndtiles = {14,14,14,14},

  TileImage = ":cn:tech_scrollbar.png",
  tiles     = {7,7,7,7},
  tileScale = {0.2, 0.2},
  KnobTileImage = ":cn:tech_scrollbar_knob.png",
  KnobTiles     = {6,8,6,8},

  HTileImage = ":cn:tech_scrollbar.png",
  htiles     = {7,7,7,7},
  HKnobTileImage = ":cn:tech_scrollbar_knob.png",
  HKnobTiles     = {6,8,6,8},

  KnobColorSelected = {1,0.7,0.1,0.8},

  padding = {5, 5, 5, 0},

  scrollbarSize = 11,
  DrawControl = DrawScrollPanel,
  DrawControlPostChildren = DrawScrollPanelBorder,
}

skin.trackbar = {
  TileImage = ":cn:trackbar.png",
  tiles     = {16, 16, 16, 16}, --// tile widths: left,top,right,bottom
  tileScale = {0.2, 0.2},

  ThumbImage = ":cn:trackbar_thumb.png",
  StepImage  = ":cn:trackbar_step.png",

  hitpadding  = {4, 4, 5, 4},

  DrawControl = DrawTrackbar,
}

skin.treeview = {
  --ImageNode         = ":cn:node.png",
  ImageNodeSelected = ":cn:node_selected.png",
  tiles = {9, 9, 9, 9},
  tileScale = {0.2, 0.2},

  ImageExpanded  = ":cn:treeview_node_expanded.png",
  ImageCollapsed = ":cn:treeview_node_collapsed.png",
  treeColor = {1,1,1,0.1},

  DrawNode = DrawTreeviewNode,
  DrawNodeTree = DrawTreeviewNodeTree,
}

skin.window = {
  TileImage = ":cn:panel_bow_small.png", --":cn:tech_mainwindow.png",
  tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
  --TileImage = ":cn:tech_overlaywindow.png",
  --tiles = {2, 2, 2, 2}, --// tile widths: left,top,right,bottom
  tileScale = {0.1, 0.1},
  padding = {13, 13, 13, 13},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},

  color = {1, 1, 1, 0.7},

  boxes = {
    resize = {-21, -21, -10, -10},
    drag = {0, 0, "100%", 10},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}

skin.main_window_small = {
	TileImage = ":cn:panel_bow_small.png", --":cn:tech_mainwindow.png",
	tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
	tileScale = {0.2, 0.2},
	padding = {60, 62, 60, 54},
	hitpadding = {4, 4, 4, 4},

	captionColor = {1, 1, 1, 0.45},
	backgroundColor = {0.1, 0.1, 0.1, 0.7},

	boxes = {
		resize = {-23, -19, -12, -8},
		drag = {0, 0, "100%", 10},
		--drag = {0, 0, 0, 0},
	},

	NCHitTest = NCHitTestWithPadding,
	NCMouseDown = WindowNCMouseDown,
	NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

	DrawControl = DrawWindow,
	DrawDragGrip = function() end,
	DrawResizeGrip = DrawResizeGrip,
}

skin.main_window_small_tall = {
	TileImage = ":cn:panel_bow_tall.png", --":cn:tech_mainwindow.png",
	tiles = {209, 435, 209, 437}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
  --TileImage = ":cn:tech_mainwindow_small_tall.png",
  --tiles = {40, 40, 40, 40}, --// tile widths: left,top,right,bottom
  tileScale = {0.1, 0.1},
  padding = {10, 6, 10, 6},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},
  backgroundColor = {0.1, 0.1, 0.1, 0.7},

  boxes = {
    resize = {-23, -19, -12, -8},
    drag = {0, 0, "100%", 10},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}

skin.main_window_small_flat = {
	TileImage = ":cn:panel_bow_small.png", --":cn:tech_mainwindow.png",
	tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
	tileScale = {0.1, 0.1},
	padding = {60, 62, 60, 54},
	hitpadding = {4, 4, 4, 4},

	captionColor = {1, 1, 1, 0.45},
	backgroundColor = {0.1, 0.1, 0.1, 0.7},

	boxes = {
		resize = {-23, -19, -12, -8},
		drag = {0, 0, "100%", 10},
		--drag = {0, 0, 0, 0},
	},

	NCHitTest = NCHitTestWithPadding,
	NCMouseDown = WindowNCMouseDown,
	NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

	DrawControl = DrawWindow,
	DrawDragGrip = function() end,
	DrawResizeGrip = DrawResizeGrip,
}

skin.main_window_small_very_flat = {
	TileImage = ":cn:panel_bow_small.png", --":cn:tech_mainwindow.png",
	tiles = {550, 420, 547, 424}, --// tile widths: left,top,right,bottom -- Hint: divide pixel size by the inverse of WG.imageScale
	tileScale = {0.1, 0.1},
	padding = {60, 62, 60, 54},
	hitpadding = {4, 4, 4, 4},

	captionColor = {1, 1, 1, 0.45},
	backgroundColor = {0.1, 0.1, 0.1, 0.7},

	boxes = {
		resize = {-23, -19, -12, -8},
		drag = {0, 0, "100%", 10},
		--drag = {0, 0, 0, 0},
	},

	NCHitTest = NCHitTestWithPadding,
	NCMouseDown = WindowNCMouseDown,
	NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

	DrawControl = DrawWindow,
	DrawDragGrip = function() end,
	DrawResizeGrip = DrawResizeGrip,
}

skin.main_window_tall = {
	TileImage = ":cn:panel_bow_tall.png",
	tiles = {209, 435, 209, 437}, --// tile widths: left,top,right,bottom
  tileScale = {0.1, 0.1},
  padding = {10, 6, 10, 6},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},
  backgroundColor = {0.1, 0.1, 0.1, 0.7},

  boxes = {
    resize = {-23, -19, -12, -8},
    drag = {0, 0, "100%", 10},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}

-- Used by the end-game stats panel
skin.main_window = {
  TileImage = ":cn:panel_mainwindow_2.png", --":cn:tech_mainwindow.png",
  tiles = {745, 400, 745, 450}, --// tile widths: left,top,right,bottom
  tileScale = {0.5, 0.5},
  padding = {30, 31, 30, 27},
  hitpadding = {4, 4, 4, 4},

  captionColor = {1, 1, 1, 0.45},
  backgroundColor = {0.1, 0.1, 0.1, 0.7},

  boxes = {
    resize = {-23, -19, -12, -8},
    drag = {0, 0, "100%", 10},
  },

  NCHitTest = NCHitTestWithPadding,
  NCMouseDown = WindowNCMouseDown,
  NCMouseDownPostChildren = WindowNCMouseDownPostChildren,

  DrawControl = DrawWindow,
  DrawDragGrip = function() end,
  DrawResizeGrip = DrawResizeGrip,
}

skin.line = {
  TileImage = ":cn:tech_line.png",
  tiles = {0, 0, 0, 0},
  TileImageV = ":cn:tech_line_vert.png",
  tilesV = {0, 0, 0, 0},
  DrawControl = DrawLine,
}

skin.tabbar = {
  padding = {3, 1, 1, 0},
}

skin.tabbaritem = {
  -- yes these are reverted, but also a lie (see images), only one is used
  TileImageFG = ":cn:tech_tabbaritem_fg.png",
  TileImageBK = ":cn:tech_tabbaritem_bk.png",
  tiles = {10, 10, 10, 0}, --// tile widths: left,top,right,bottom
  padding = {1, 1, 1, 2},
  -- since it's color multiplication, it's easier to control white color (1, 1, 1) than black color (0, 0, 0) to get desired results
  backgroundColor = {0, 0, 0, 1.0},
  -- actually kill this anyway
  borderColor     = {0, 0, 0, 0},
  focusColor      = {0.46, 0.54, 0.68, 1.0},

  DrawControl = DrawTabBarItem,
}


skin.control = skin.general


--//=============================================================================
--//

return skin
