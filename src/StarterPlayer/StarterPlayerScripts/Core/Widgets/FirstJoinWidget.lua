local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))
local Trove = ReplicatedModules.Classes.Trove

local LocalModules = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"))

local Warp = ReplicatedModules.Classes.Warp

local FirstJoinScreen = LocalPlayer:WaitForChild('PlayerGui'):WaitForChild("FirstJoinScreen")

local SystemsContainer = {}
local WidgetControllerModule = {}

local SkyPlotViewService = LocalModules.Services.SkyPlotViewService

-- // Module // --
local Module = {}

Module.WidgetTrove = Trove.new()
Module.Open = false

Module.PlotNumber = nil

function Module.UpdateWidget()
    
end

function Module.OpenWidget()
    if Module.Open then
        return
    end
    
    Module.Open = true

    -- Open the GUI (FirstJoinScreen) for the first-time player
    FirstJoinScreen.Enabled = true

    -- Invoke the event to find the plot number
    local FindPlotNumberEvent = Warp.Client("FindPlotNumberEvent")

    -- PlotNumber could be any plot based on logic, assuming it returns a number
    Module.PlotNumber = FindPlotNumberEvent:Invoke(2) -- Invoke with argument (example)

    -- Show the aerial view of the player's plot using the PlotNumber
    SkyPlotViewService.ShowPlotFromSky(Module.PlotNumber, Players.LocalPlayer)
end

function Module.SetupOpenButton()
    local OpenButton = FirstJoinScreen:WaitForChild("OpenLemonadeStandFrame"):WaitForChild("OpenButton") :: TextButton
    local CameraShakeService = LocalModules.Services.CameraShakeService

    local timeBetween = 0
    local down = false
    local timeToHold = 3
    local holdingComplete = false

    -- Create a loading bar inside the button
    local loadingBar = Instance.new("Frame") :: Frame
    loadingBar.Size = UDim2.new(0, 0, 1, 0)  -- Initially no width, full height
    loadingBar.Position = UDim2.new(0, 0, 0, 0)  -- Positioned at the left of the button
    loadingBar.BackgroundColor3 = Color3.fromRGB(107, 118, 203)  -- Green loading bar color
    loadingBar.BackgroundTransparency = 0.5  -- Semi-transparent
    loadingBar.BorderSizePixel = 0  -- No border
    loadingBar.Parent = OpenButton  -- Add it to the button

    -- Reset everything (camera shake, time, down flag, loading bar)
    local function resetButton()
        down = false
        timeBetween = 0
        holdingComplete = false
        CameraShakeService.StopShake()  -- Ensure the camera shake stops
        loadingBar.Size = UDim2.new(0, 0, 1, 0)  -- Reset the loading bar to 0 width
        loadingBar.Visible = false  -- Hide the loading bar
    end

    -- When the user clicks the button
    OpenButton.MouseButton1Down:Connect(function()
        down = true

        -- Show the loading bar and start the camera shake
        loadingBar.Visible = true
    
        -- Run camera shake asynchronously to prevent blocking
        task.spawn(function()
            CameraShakeService.ShakeCameraGradually(timeToHold)  -- Start gradual shake
        end)

        task.spawn(function()
            while down and timeBetween < timeToHold do
                task.wait(0.1)  -- Update every 0.1 seconds for smooth animation
                timeBetween += 0.1

                -- Update the loading bar width based on how long the player has held
                local progress = timeBetween / timeToHold
                loadingBar.Size = UDim2.new(progress, 0, 1, 0)  -- Set width as a percentage of the total time
            end
            if timeBetween >= timeToHold then
                holdingComplete = true  -- Mark that the required hold time was reached
            end
        end)
    end)

    -- When the user releases the button
    OpenButton.MouseButton1Up:Connect(function()
        -- If the user held long enough and releases on the button, close the widget
        if holdingComplete and down then
            Module.CloseWidget()
        end
        resetButton()  -- Reset everything whether they held long enough or not
    end)

    -- When the user's mouse leaves the button area
    OpenButton.MouseLeave:Connect(function()
        resetButton()  -- Reset everything if the user moves their mouse off the button
    end)
end

function Module.CloseWidget()
    if not Module.Open then
        return
    end

    -- Hide the GUI
    FirstJoinScreen.Enabled = false

    -- Stop showing the plot from the sky and teleport the player back to the plot's sign
    SkyPlotViewService.StopShowingPlotFromSky(Module.PlotNumber, Players.LocalPlayer)

    Module.Open = false
    Module.WidgetTrove:Destroy()
end


function Module.Start()
    local FirstJoinRemote = Warp.Client("FirstJoinRemote")

    FirstJoinRemote:Connect(function()
        Module.OpenWidget()
    end)

    Module.SetupOpenButton()
end

function Module.Init(ParentController, otherSystems)
    WidgetControllerModule = ParentController
    SystemsContainer = otherSystems
end

return Module