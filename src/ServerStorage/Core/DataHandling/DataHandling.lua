local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))

local Warp = ReplicatedModules.Classes.Warp


local SystemsContainer = {}

-- // Module // --
local Module = {}

function Module.GetAllData(player)
    local DataServer = SystemsContainer.DataServer

    -- Helper function to process the data and remove the "Replicated" field
    local function processAllData(rawData)
        local processedData = {}

        -- Iterate over each entry in rawData
        for dataName, dataContent in pairs(rawData) do
            -- Add the entry with only the "CurrentData" field to processedData
            processedData[dataName] = dataContent.CurrentData
        end

        return processedData
    end

    -- Retrieve the raw data from DataServer
    local AllData = DataServer.GetAllData(player)

    -- Process the data and remove the "Replicated" field
    local cleanedData = processAllData(AllData)

    -- Retrieve the player's plot number
    local PlotHandler = SystemsContainer.ParentSystems.PlotHandling.PlotService
 
    local plotNum = PlotHandler.GetPlayerPlotNum(player)

    -- Add the plot number to the cleaned data
    cleanedData.PlotNum = plotNum

    return cleanedData
end



function Module.Start()
    local TestRemote = Warp.Server("AddCoins");


    TestRemote:Connect(function(player, coins)
        -- Fetch the current coins from DataServer for the player
        -- local currentCoins = DataServer.fetch(player, "Coins")

        -- -- If the coins were successfully fetched, increment by the value of `coins`
        -- if currentCoins then
        --     local newCoins = currentCoins + coins
        --     -- Update the player's coins in DataServer
        --     DataServer.set(player, "Coins", newCoins)
        -- else
        --     warn("Failed to fetch coins for player: " .. player.Name)
        -- end

        -- print(Module.GetAllData(player))
        -- print(DataServer.fetch(player, "City"))
    end)

    local GetAllDataRemote = Warp.Server("GetAllData")
    GetAllDataRemote:Connect(function(player)
        return Module.GetAllData(player)
    end)



end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module