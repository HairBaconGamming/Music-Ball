--// Load UI Library
local Material = require(game:GetHttp("https://raw.githubusercontent.com/HairBaconGamming/Gamming-Material-HUB/main/Main.lua"))()

local Main = Material:Load({
    Title = "Part Tracker",
    SmothDrag = true,
    Key = Enum.KeyCode.RightShift,
    X = 100,
    Y = 100,
})

local Tab = Main:New({
    Title = "Main",
    ImageId = 0
})

--// Camera helper
local camera = workspace.CurrentCamera
local function getXYfrom(part)
    return camera:WorldToViewportPoint(part.Position)
end

--// UI State Variables
local enabled = false
local refreshRate = 1/60 -- default to 60 FPS
local manualPartName = ""

--// UI Components

-- Toggle to enable or disable mouse tracking
local Toggle = Tab:Toggle({
    Title = "Enable Tracking",
    Callback = function(state)
        enabled = state
        return state
    end,
    Enabled = false
})

-- Slider to control refresh rate (FPS)
local Slider = Tab:Slide({
    Title = "Refresh Rate (FPS)",
    Callback = function(value)
        refreshRate = 1 / value
        return value
    end,
    Min = 10,
    Max = 120,
    Default = 60,
    Percent = 50
})

-- Textbox to manually select a part
local Textbox = Tab:Textbox({
    Title = "Manual Part Name",
    TextboxTitle = "Part Name",
    Callback = function(text)
        manualPartName = text
        return text
    end,
    ClearTextOnFocus = false
})

-- Button to clear manual part
local Button = Tab:Button({
    Title = "Clear Manual Selection",
    Callback = function()
        manualPartName = ""
    end
})

--// Main logic
game:GetService("RunService").RenderStepped:Connect(function()
    if not enabled then return end
    if not workspace:FindFirstChild("Folder") then return end

    local part

    if manualPartName ~= "" then
        part = workspace.Folder:FindFirstChild(manualPartName)
    else
        -- find lowest name number in workspace.Folder
        local lowest = math.huge
        for i,v in pairs(workspace.Folder:GetChildren()) do
            local num = tonumber(v.Name)
            if num and num < lowest then
                lowest = num
                part = v
            end
        end
    end

    if part then
        local point = getXYfrom(part)
        mousemoveabs(point.X, point.Y)
    end

    task.wait(refreshRate)
end)
