--http://springrts.com/phpbb/viewtopic.php?f=23&t=30560
function widget:GetInfo()
	return {
		name = "GUI Replay buttons",
		desc = "click buttons to change replay speed",
		author = "knorke",
		version = "1",
		date = "June 2013",
		license = "click button magic",
		layer = 10,
		enabled = true,		
	}
end

VFS.Include("gamedata/taptools.lua")

local font
local bgcorner				= "LuaUI/Images/bgcorner.png"
local vsx,vsy = Spring.GetViewGeometry()
local fontfileScale = (0.5 + (vsx*vsy / 5700000))

local speedbuttons={} --the 1x 2x 3x etc buttons
local buttons={}	--other buttons (atm only pause/play)
local wantedSpeed = nil
local speeds = {0.5, 1, 2, 3, 4, 5, 10, 20}
wPos = {x=0.00, y=0.15}
local isPaused = false
local isActive = true --is the widget shown and reacts to clicks?
local scheduleUpdate = true
local loadedFontSize = 55


local spGetSelectedUnits = Spring.GetSelectedUnits
local spGetGameSpeed = Spring.GetGameSpeed
local spSendCommands = Spring.SendCommands
local spGetGameFrame = Spring.GetGameFrame
local spGetMouseState = Spring.GetMouseState
local gl_CallList = gl.CallList
local gl_DeleteList = gl.DeleteList
local gl_CreateList = gl.CreateList
local gl_DeleteFont = gl.DeleteFont
local gl_LoadFont = gl.LoadFont

local gl_Color = gl.Color
local gl_PushMatrix = gl.PushMatrix
--local gl_Translate = gl.Translate
local gl_BeginText = gl.BeginText
local gl_EndText = gl.EndText
local gl_PopMatrix = gl.PopMatrix

local function SetColor(r,g,b,a)
	if font == nil then
		return end
    gl_Color(r,g,b,a)
    font:SetTextColor(r,g,b,a)
end

function widget:Initialize()
	if (not Spring.IsReplay()) then
		Spring.Echo ("[Replay Control] Replay not detected, Shutting Down.")
		widgetHandler:RemoveWidget(self)
		return
	end

    --local font = gl.LoadFont(FontPath, loadedFontSize, 10, 10)
    font = gl.LoadFont ( FontPath, loadedFontSize, 24, 1.25 ) -- 24, 1.25

    local dy = 0
	local h = 0.033
	for i = 1, #speeds do	
		dy=dy+h
		add_button (speedbuttons, wPos.x, wPos.y+dy, 0.037, 0.033, "  " .. speeds[i].."x", speeds[i], speedButtonColor (i))
	end
	speedbuttons[2].color = {0.75,0,0,0.66}
	dy=dy+h
	local text = "  skip"
	if spGetGameFrame() > 0 then
		text = "  ||"
	end
	add_button (buttons, wPos.x, wPos.y, 0.037, 0.033, text,"playpauseskip", {0,0,0,0.6})	
	
end

function widget:Shutdown()	
	if (WG['guishader_api'] ~= nil) then
		WG['guishader_api'].RemoveRect('replaybuttons')
	end
	gl_DeleteList(speedButtonsList)
	gl_DeleteList(buttonsList)
end

function speedButtonColor (i)
	return{1,1,1,0.6}	-- 0, 0, 0
end


function widget:DrawScreen()
	if (WG['guishader_api'] ~= nil) then
		if isActive then
			local h = 0.033
			local dy = (#speeds +1) * h
			WG['guishader_api'].InsertRect(sX(wPos.x), sY(wPos.y), sX(wPos.x+0.037), sY(wPos.y+dy), 'replaybuttons')
		else
			WG['guishader_api'].RemoveRect('replaybuttons')
		end
	end
	
	if not isActive then
		return end

	gl_PushMatrix()
	gl_BeginText()

		SetColor(1,1,1,1)

		if scheduleUpdate then
			if speedButtonsList then
				gl_DeleteList(speedButtonsList)
				gl_DeleteList(buttonsList)
			end
			speedButtonsList = gl_CreateList(draw_buttons, speedbuttons)
			buttonsList = gl_CreateList(draw_buttons, buttons)
			scheduleUpdate = false
		end
		if speedButtonsList then
			gl_CallList(speedButtonsList)
			gl_CallList(buttonsList)
		end
		local mousex, mousey = spGetMouseState()
		local b = speedbuttons
		local topbutton = #speedbuttons
		if point_in_rect (buttons[1].x, buttons[1].y, b[topbutton].x+b[topbutton].w, b[topbutton].y+b[topbutton].h,  uiX(mousex), uiY(mousey)) then
			for i = 1, #b, 1 do
				if (point_in_rect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h,  uiX(mousex), uiY(mousey)) or i == active_button) then
					SetColor (0.4,0.4,0.4,0.6)
					uiRect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h)
					uiText (b[i].text, b[i].x, b[i].y+b[i].h/2, (0.0115), 'vo')
				end
			end
			b = buttons
			for i = 1, #b, 1 do
				if (point_in_rect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h,  uiX(mousex), uiY(mousey)) or i == active_button) then
					SetColor (0.4,0.4,0.4,0.6)
					uiRect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h)
					uiText (b[i].text, b[i].x, b[i].y+b[i].h/2, (0.0115), 'vo')
				end
			end
		end

	gl_EndText()
	gl_PopMatrix()
end

function widget:MousePress(x,y,button)	
	if not isActive then return end
	local cb,i = clicked_button (speedbuttons)
	if cb ~= "NOBUTTONCLICKED" then
		setReplaySpeed (speeds[i], i)
		for i = 1, #speeds do --reset all buttons colors
			speedbuttons[i].color = speedButtonColor (i)
		end
		speedbuttons[i].color = {0.75,0,0,0.66 }
		scheduleUpdate = true
	end
	
	local cb,i = clicked_button (buttons)	
	if cb == "playpauseskip" then
		if spGetGameFrame () > 1 then
			if (isPaused) then 			
				spSendCommands ("pause 0")
				buttons[i].text = "  ||"
				isPaused = false
			else 
				spSendCommands ("pause 1")
				buttons[i].text = "  >>"
				isPaused = true
			end
		else
			spSendCommands ("skip 1")
			buttons[i].text = "  ||"
		end
		scheduleUpdate = true
	end	
end

function setReplaySpeed (speed, i)
	local s = spGetGameSpeed()
	--Spring.Echo ("setting speed to: " , speed , " current is " , s)
	if (speed > s) then	--speedup
		spSendCommands ("setminspeed " .. speed)
		spSendCommands ("setminspeed " ..0.1)
	else	--slowdown
		wantedSpeed = speed
	end
end

function widget:Update()
	if (wantedSpeed) then
		if (spGetGameSpeed() > wantedSpeed) then
			spSendCommands ("slowdown")
		else
			wantedSpeed = nil
		end
	end
	if #spGetSelectedUnits () ~=0 then isActive = false else isActive = true end
end

function widget:GameFrame (f)	
	if (f==1) then
		buttons[1].text= "  ||"
	end
end

------------------------------------------------------------------------------------------
--a simple UI framework with buttons 
--Feb 2011 by knorke
local glPopMatrix      = gl.PopMatrix
local glPushMatrix     = gl.PushMatrix
local glText           = gl.Text
local vsx, vsy = widgetHandler:GetViewSizes()
--UI coordinaten zu scalierten screen koordinaten
function sX (uix)
	return uix*vsx
end
function sY (uiy)
	return uiy*vsy
end
---...und andersrum!
function uiX (sX)
	return sX/vsx
end
function uiY (sY)
	return sY/vsy
end

function widget:ViewResize(viewSizeX, viewSizeY)
	vsx = viewSizeX
	vsy = viewSizeY
    scheduleUpdate = true
    local newFontfileScale = (0.5 + (vsx*vsy / 5700000))
    if (fontfileScale ~= newFontfileScale) then
        fontfileScale = newFontfileScale
        gl_DeleteFont(font)
        font = gl_LoadFont ( FontPath, loadedFontSize, 24, 1.25 ) -- 24, 1.25
        --font = gl.LoadFont(fontfile, fontfileSize*fontfileScale, fontfileOutlineSize*fontfileScale, fontfileOutlineStrength)
    end
end
----zeichen funktionen---------
function uiRect (x,y,x2,y2)
	RectRound(sX(x), sY(y), sX(x2), sY(y2), 6)
	--gl.Rect (sX(x), sY(y), sX(x2), sY(y2))
end

function uiText (text, x,y,s,options)
	if (text==" " or text=="  ") then return end --archivement: unlock +20 fps
    font:Print(text, sX(x), sY(y), sX(s), options)
end
--------------------------------
-----message boxxy-----
function drawmessagebox (msgbox, msg_n)
	if (msgbox.messages==nil) then return end	
	local yoff = msgbox.textsize
	if (msg_n==nil) then msg_n=100 end --***
	local start = #msgbox.messages-msg_n+1
	if (start < 1) then start = 1 end	
	local fade = 1
	for i =  start, #msgbox.messages , 1 do
		drawmessage (msgbox.messages[i],  msgbox.x,  msgbox.y-yoff, msgbox.textsize)
		yoff=yoff+msgbox.textsize*1.2
	end
end

function drawmessage_simple (message, x, y, s)
	offx=0
	if (message.frame) then
        font:Print (frame2time (message.frame), sX(x+offx), sY(y), sX(s/2), 'vo')
		offx=offx+(2*s)
	end
    font:Print (message.text, sX(x+offx), sY(y), sX(s), 'vo')
end

--X, Y and size in UI scale
function drawmessage (message, x, y, s)	
	if (message.bgcolor) then
        SetColor (unpack(message.bgcolor))
		uiRect (x,y+s/2, x+1, y-s/2)
	end	
	offx=0
	if (message.frame) then
        font:Print (frame2time (message.frame), sX(x+offx), sY(y), sX(s/2), 'vo')
		offx=offx+(2*s)
	end
	if (message.icon) then		
		--****!!! irgendwie malt er danach keine Rechtecke mehr
		--gl.PushMatrix()
        SetColor (1,1,1,1)
		gl.Texture(message.icon)		
		gl.TexRect(sX(x+s*1.9),sY(y-s*0.8), sX(x+s*2.9),sY(y+s*0.8)  )		
		gl.Texture(false)
		--gl.PopMatrix()
		offx=offx+(s)
	end
    font:Print (message.text, sX(x+offx), sY(y), sX(s), 'vo')
end

function addmessage (msgbox, text, bgcolor)
	local newmessage = {}
	--newmessage.frame = gameframe
	if (bgcolor) then newmessage.bgcolor = bgcolor end---{0,0,0.8,0.5}
	newmessage.text = text
	table.insert (msgbox.messages, newmessage)
end

-------message boxxy end------
------BUTTONS------

function RectRound(px,py,sx,sy,cs)

	local px,py,sx,sy,cs = math.floor(px),math.floor(py),math.floor(sx),math.floor(sy),math.floor(cs)
	
	gl.Rect(px+cs, py, sx-cs, sy)
	gl.Rect(sx-cs, py+cs, sx, sy-cs)
	gl.Rect(px+cs, py+cs, px, sy-cs)
	
	if py <= 0 or px <= 0 then gl.Texture(false) else gl.Texture(bgcorner) end
	gl.TexRect(px, py+cs, px+cs, py)		-- top left
	
	if py <= 0 or sx >= vsx then gl.Texture(false) else gl.Texture(bgcorner) end
	gl.TexRect(sx, py+cs, sx-cs, py)		-- top right
	
	if sy >= vsy or px <= 0 then gl.Texture(false) else gl.Texture(bgcorner) end
	gl.TexRect(px, sy-cs, px+cs, sy)		-- bottom left
	
	if sy >= vsy or sx >= vsx then gl.Texture(false) else gl.Texture(bgcorner) end
	gl.TexRect(sx, sy-cs, sx-cs, sy)		-- bottom right
	
	gl.Texture(false)
end

function draw_buttons (b)
	--local mousex, mousey = Spring.GetMouseState()
	for i = 1, #b, 1 do	
		if (b[i].color) then SetColor (unpack(b[i].color)) else SetColor (1 ,0,0,0.66) end
		--if (point_in_rect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h,  uiX(mousex), uiY(mousey)) or i == active_button) then
		--	gl.Color (0.4,0.4,0.4,0.6)
		--end
		if (b[i].name == selected_missionid) then SetColor (0,1,1,0.66) end --highlight selected mission, bit unnice this way w/e
		
		uiRect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h)
		uiText (b[i].text, b[i].x, b[i].y+b[i].h/2, (0.0115), 'vo')
	end
end

function add_button (buttonlist, x,y, w, h, text, name, color)
	local new_button = {x=x, y=y, w=w, h=h, text=text, name=name}
	if(color) then
        new_button.color=color end
	table.insert (buttonlist, new_button)
end

function previous_button ()
	active_button = active_button -1
	if (active_button < 1) then active_button = #buttons end
end

function next_button ()
	active_button = active_button +1
	if (active_button > #buttons) then active_button = 1 end
end

function point_in_rect (x1, y1, x2, y2, px, py)
	return (px > x1 and px < x2 and py > y1 and py < y2)
end

function clicked_button (b)
	local mx, my,click = Spring.GetMouseState()
	local mousex=uiX(mx)
	local mousey=uiY(my)
	for i = 1, #b, 1 do	
		if (click == true and point_in_rect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h,  mousex, mousey)) then return b[i].name, i end
		--if (mouse_was_down == false and click == true and point_in_rect (b[i].x, b[i].y, b[i].x+b[i].w, b[i].y+b[i].h,  mousex, mousey)) then mouse_was_down = true end
		end
	--keyboard:
	--if (enter_was_down and active_button > 0 and active_button < #buttons+1) then enter_was_down = false return b[active_button].name, active_button end
	return "NOBUTTONCLICKED"
end
