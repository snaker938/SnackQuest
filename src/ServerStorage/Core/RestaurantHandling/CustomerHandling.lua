local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))

local ServerStorage = game:GetService('ServerStorage')

local ServerModules = require(ServerStorage:WaitForChild("Modules"))

-- Data
local PlotData = ReplicatedModules.Data.PlotData
local CityData = ReplicatedModules.Data.CityData



local SystemsContainer = {}

-- // Module // --
local Module = {}

function Module.SpawnCustomers(player : Player)
    -- Get number of customers to spawn
    

end

function Module.Start()
    
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module