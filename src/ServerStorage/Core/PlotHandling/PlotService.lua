local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))
local Promise = ReplicatedModules.Classes.Promise

local Warp = ReplicatedModules.Classes.Warp

local SystemsContainer = {}

-- // Module // --
local Module = {}

-- Plots table where each plot is either assigned a player or is false (unoccupied)
Module.Plots = {
    false, -- Plot 1
    false, -- Plot 2
    false, -- Plot 3
    false, -- Plot 4
    false, -- Plot 5
}

-- Find the first available plot for the player and assign them to it, returning the plot index (1-based array)
function Module.AddPersonToPlot(player: Player)
    for plotId, plot in ipairs(Module.Plots) do
        -- Check if the plot is available (i.e., false)
        if plot == false then
            -- Assign the player to this plot
            Module.Plots[plotId] = player
            -- print(player.Name .. " has been assigned to plot " .. plotId)
            return plotId -- Return the plot index after assigning the player
        end
    end

    -- If no plot was available
    print("No available plots for " .. player.Name)
    player:Kick("No available plots for you.") -- Kick the player if no plots are available
end

-- Return the plot index that a specific player is occupying, or false if they don't occupy any plot
function Module.GetPlayerPlotId(player: Player)
    for plotId, plot in ipairs(Module.Plots) do
        if plot == player then
            return plotId
        end
    end
    return false -- Return false if the player is not found in any plot
end

-- Remove a player from their assigned plot
function Module.RemovePlayerFromPlot(player: Player)
    local plotId = Module.GetPlayerPlotId(player)
    if plotId then
        Module.Plots[plotId] = false -- Make the plot available again (set to false)
        print(player.Name .. " has been removed from plot " .. plotId)
        return true
    else
        error("Player " .. player.Name .. " is not occupying any plot.")
        return false
    end
end

-- Check if a specific plot is occupied
function Module.IsPlotOccupied(plotId: number)
    return Module.Plots[plotId] ~= false -- Return true if the plot is occupied (not false)
end

-- Clear all players from the plots (useful for server reset)
function Module.ClearAllPlots()
    for plotId = 1, #Module.Plots do
        Module.Plots[plotId] = false -- Set all plots to false (clear them)
    end
    print("All plots have been cleared.")
end

-- Handles when a player joins the server
local function playerAdded(player: Player)
    local assignedPlotId = Module.AddPersonToPlot(player)
    if assignedPlotId then
        print(player.Name .. " was successfully assigned to plot " .. assignedPlotId)
    else
        player:Kick("Something went wrong while assigning you to a plot.")
    end
end

-- Handles when a player leaves the server
local function playerRemoving(player: Player)
    Module.RemovePlayerFromPlot(player) -- Remove the player from their plot when they leave
end

-- Start the plot service and assign players to plots on join, remove them on leave
function Module.StartService()
    -- Handle existing players when the service starts
    task.spawn(function()
        for _, player in ipairs(Players:GetPlayers()) do
            task.spawn(playerAdded, player)
        end
    end)

    -- Listen for player join and leave events
    Players.PlayerAdded:Connect(playerAdded)
    Players.PlayerRemoving:Connect(playerRemoving)
end

function Module.Start()
    Module.StartService()

    local FindPlotNumberEvent = Warp.Server("FindPlotNumberEvent")

    FindPlotNumberEvent:Connect(function(player)
        local assignedPlotId = Module.GetPlayerPlotId(player)
        return assignedPlotId
    end)
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
