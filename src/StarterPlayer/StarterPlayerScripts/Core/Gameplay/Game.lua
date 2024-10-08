local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = ReplicatedStorage:WaitForChild('Modules')

local Warp = require(ReplicatedModules:WaitForChild("Classes"):WaitForChild("Warp"))

local SystemsContainer = {}

-- // Module // --
local Module = {}

Module.PlayerData = nil

function Module.StartGameplay()
    local GetAllDataRemote = Warp.Client("GetAllData")
    Module.PlayerData = GetAllDataRemote:Invoke(2)

    local cityNumber = Module.PlayerData.CityNum
    local restaurantNum = Module.PlayerData.RestaurantNum
    local plotNum = Module.PlayerData.PlotNum
    local hasStartedRestaurant = Module.PlayerData.HasStartedCurrentRestaurant[1] -- Extract the value from the table

    -- Only display the widget if HasStartedCurrentRestaurant is false
    if not hasStartedRestaurant then
        SystemsContainer.ParentSystems.Widgets.ToggleWidget("OpenRestaurantWidget", true, cityNumber, restaurantNum, plotNum)
    end
end

function Module.Start()

end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
