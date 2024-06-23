function widget:GetInfo()

    return {
        name    = "Chili Hello World",
        desc    = "",
        author  = "",
        date    = "",
        license = "GNU GPL v2",
        layer   = 0,
        enabled = false, --true
    }
end

--local Chili, Screen0
--
--local helloWorldWindow, helloWorldLabel,window,panel,textBox,yesButton, noButton
--
--function widget:Initialize()
--
--    if (not WG.Chili) then
--        -- don't run if we can't find Chili
--        widgetHandler:RemoveWidget()
--        return
--    end
--    -- Get ready to use Chili
--    Chili = WG.Chili
--    Screen0 = Chili.Screen0
--    -- Create the window
--    window = Chili.Window:New{
--        parent = Screen0,
--
--        --- "left" and "top" do not 'exist' in the API, only 'x' and 'y'. Bottom and Right both work.
--
--        --== TOP-LEFT
--        --x = 'y', --'top',
--        --y = '2%',
--
--        --== BOTTOM-LEFT
--        --x = 'y', --'bottom',
--        --bottom = '2%',
--
--        --== BOTTOM-RIGHT
--        --right = 'y', --'bottom',
--        --bottom = '2%',
--
--        --== TOP-RIGHT
--        right = 'y', --'top',
--        y = '20%',
--
--        width  = '40%',
--        height = '40%',
--        --
--        --x = 'bottom',
--        --right = 'y', --'bottom',
--        --bottom = '2%',
--        --
--        padding = {5, 5, 5, 5},
--        --y = '2%',
--    }
--    -- Create some text inside the window
--    --helloWorldLabel = Chili.Label:New{
--    --    parent = helloWorldWindow,
--    --    width  = '100%',
--    --    height = '100%',
--    --    caption = "Hello world",
--    --}
--
--    local function CloseWindow(self, x, y, mouse, mods)
--        window:Dispose()
--        window = nil
--    end
--
--    --window = Chili.Window:New{parent = Screen0,   x='25%', y='25%', width='50%', height='50%'}
--    panel = Chili.Panel:New
--        {parent = window, y='10%', x='y', height='80%', width='height'}
--    textBox = Chili.TextBox:New
--        {parent = panel,  x='10%', y='10%', width='80%', height='30%', text="Is the sky blue?"}
--    yesButton = Chili.Button:New
--        {parent = panel, x='10%', y='60%', width='30%', height='30%', caption="Yes", OnClick = {function() Spring.SendCommands("quitforce")end }, }
--    noButton = Chili.Button:New
--        {parent = panel,  x='60%', y='60%', width='30%', height='30%', caption="No",
--         --OnClick = {function(self) window:Dispose(); window = nil; end }}
--         OnClick = {CloseWindow}}
--end