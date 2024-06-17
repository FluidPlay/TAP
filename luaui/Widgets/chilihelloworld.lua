function widget:GetInfo()

    return {
        name    = "Chili Hello World",
        desc    = "",
        author  = "",
        date    = "",
        license = "GNU GPL v2",
        layer   = 0,
        enabled = true
    }
end

local Chili, Screen0

local helloWorldWindow, helloWorldLabel,window,textBox,yesButton, noButton

function widget:Initialize()

    if (not WG.Chili) then
        -- don't run if we can't find Chili
        widgetHandler:RemoveWidget()
        return
    end
    -- Get ready to use Chili
    Chili = WG.Chili
    Screen0 = Chili.Screen0
    -- Create the window
    helloWorldWindow = Chili.Window:New{
        parent = Screen0,
        --x = '20%', --80%-20%(width)
        --y = '20%',

        right = '2%',
        bottom = 'same',
        width  = '20%',
        height = '20%',
    }
    -- Create some text inside the window
    helloWorldLabel = Chili.Label:New{
        parent = helloWorldWindow,
        width  = '100%',
        height = '100%',
        caption = "Hello world",
    }

    --window = Chili.Window:New{parent = Screen0,   x='25%', y='25%', width='50%', height='50%'}
    --textBox = Chili.TextBox:New{parent = window,  x='10%', y='10%', width='80%', height='30%', text="Is the sky blue?"}
    --yesButton = Chili.Button:New{parent = window, x='10%', y='60%', width='30%', height='30%', caption="Yes"}
    --noButton = Chili.Button:New{parent = window,  x='60%', y='60%', width='30%', height='30%', caption="No"}
end