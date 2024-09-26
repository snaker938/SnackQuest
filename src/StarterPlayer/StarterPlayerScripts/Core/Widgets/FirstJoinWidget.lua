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
    local PlotNumber = FindPlotNumberEvent:Invoke(2) -- Invoke with argument (example)

    -- Show the aerial view of the player's plot using the PlotNumber
    SkyPlotViewService.ShowPlotFromSky(PlotNumber, Players.LocalPlayer)
end

function Module.CloseWidget()
    if not Module.Open then
        return
    end

    -- Hide the GUI
    FirstJoinScreen.Enabled = false

    -- We assume the plot number was stored during opening the widget
    local FindPlotNumberEvent = Warp.Client("FindPlotNumberEvent")
    local PlotNumber = FindPlotNumberEvent:Invoke(2) -- Get the same plot number

    -- Stop showing the plot from the sky and teleport the player back to the plot's sign
    SkyPlotViewService.StopShowingPlotFromSky(PlotNumber, Players.LocalPlayer)

    Module.Open = false
    Module.WidgetTrove:Destroy()
end


function Module.Start()
    local FirstJoinRemote = Warp.Client("FirstJoinRemote")

    FirstJoinRemote:Connect(function()
        Module.OpenWidget()
    end)

    local OpenButton = FirstJoinScreen:WaitForChild("OpenLemonadeStandFrame"):WaitForChild("OpenButton")

    OpenButton.MouseButton1Click:Connect(function()
        Module.CloseWidget()
    end)
end

function Module.Init(ParentController, otherSystems)
    WidgetControllerModule = ParentController
    SystemsContainer = otherSystems
end

return Module