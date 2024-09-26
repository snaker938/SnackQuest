local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))

local Warp = ReplicatedModules.Classes.Warp


local SystemsContainer = {}

-- // Module // --
local Module = {}

function Module.Start()
    local TestRemote = Warp.Server("AddCoins");

    local DataServer = SystemsContainer.DataServer

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

        DataServer.wipe(player)
        -- print(DataServer.fetch(player, "City"))
end)

end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module