local SystemsContainer = {}

-- // Module // --
local Module = {}

-- Helper function to set the camera position to a specific part
local function setCameraToPart(player, part)
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Scriptable -- Set camera to be script-controlled
    camera.CFrame = part.CFrame -- Set the camera position and orientation to match the part's CFrame
end

-- Helper function to reset the camera to the player's default view
local function resetCamera(player)
    local camera = workspace.CurrentCamera
    camera.CameraType = Enum.CameraType.Custom -- Set camera back to player-controlled
end

-- Shows the specified plot from the sky
function Module.ShowPlotFromSky(plotNumber, player)
    local SkyViewParts = workspace:WaitForChild("SkyViewParts"):GetChildren()
    for _, part in ipairs(SkyViewParts) do
        if part.Name == "Sky" .. plotNumber then
            -- Set the camera to the corresponding SkyView part
            setCameraToPart(player, part)
            print("Showing plot " .. plotNumber .. " from the sky.")
            return
        end
    end
    print("No sky view part found for plot " .. plotNumber)
end

-- Stops showing the plot from the sky and teleports the player back to their plot
function Module.StopShowingPlotFromSky(plotNumber, player : Player)
    local plotsFolder = workspace:WaitForChild("Plots"):GetChildren()  -- Get all models in the Plots folder
    
    -- Loop through each model in the "Plots" folder and find the one with the correct plot number
    for _, plotModel in ipairs(plotsFolder) do
        if plotModel:IsA("Model") and plotModel.Name:match("_" .. plotNumber .. "$") then
            -- Teleport the player back to the plot's primary part (usually the base)
            if plotModel.PrimaryPart then
                player.Character.HumanoidRootPart.CFrame = plotModel.PrimaryPart.CFrame + Vector3.new(0, 5, 0) -- Teleport above the base to avoid collisions
                resetCamera(player) -- Reset the camera back to the player's view
                print(player.Name .. " teleported back to plot " .. plotNumber)
                return
            else
                warn("PrimaryPart not set for plot model " .. plotModel.Name)
            end
        end
    end

    print("No plot found for plot " .. plotNumber)
end

-- This is called when the service starts
function Module.Start()

end

-- Initializes the system and connects to other systems
function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module



-- local SystemsContainer = {}

-- -- // Module // --
-- local Module = {}

-- -- Helper function to set the camera position to a specific part
-- local function setCameraToPart(player, part)
--     local camera = workspace.CurrentCamera
--     camera.CameraType = Enum.CameraType.Scriptable -- Set camera to be script-controlled
--     camera.CFrame = part.CFrame -- Set the camera position and orientation to match the part's CFrame
-- end


-- -- Helper function to reset the camera to the player's default view
-- local function resetCamera(player)
--     local camera = workspace.CurrentCamera
--     camera.CameraType = Enum.CameraType.Custom -- Set camera back to player-controlled
-- end


-- -- Shows the specified plot from the sky
-- function Module.ShowPlotFromSky(plotNumber, player)
--     local SkyViewParts = workspace:WaitForChild("SkyViewParts"):GetChildren()
--     for _, part in ipairs(SkyViewParts) do
--         if part.Name == "Sky" .. plotNumber then
--             -- Set the camera to the corresponding SkyView part
--             setCameraToPart(player, part)
--             print("Showing plot " .. plotNumber .. " from the sky.")
--             return
--         end
--     end
--     print("No sky view part found for plot " .. plotNumber)
-- end

-- -- Stops showing the plot from the sky and teleports the player back to their plot
-- function Module.StopShowingPlotFromSky(plotNumber, player : Player)
--     local Plots = workspace:WaitForChild("Plots"):GetDescendants()
--     for _, plot in ipairs(Plots) do
--         if plot.Name == "Plot" .. plotNumber then
--             -- Teleport the player back to their plot
--             player.Character.HumanoidRootPart.CFrame = plot.CFrame
--             resetCamera(player) -- Reset camera back to player's view
--             print(player.Name .. " teleported back to plot " .. plotNumber)
--             return
--         end
--     end
--     print("No plot found for plot " .. plotNumber)
-- end

-- -- This is called when the service starts
-- function Module.Start()
    
-- end

-- -- Initializes the system and connects to other systems
-- function Module.Init(otherSystems)
--     SystemsContainer = otherSystems
-- end

-- return Module
