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
    camera.CameraType = Enum.CameraType.Custom -- Reset the camera back to default
    camera.CFrame = player.Character.HumanoidRootPart.CFrame -- Return to player's current position
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

-- Stops showing the plot from the sky and teleports the player back to their plot sign
function Module.StopShowingPlotFromSky(plotNumber, player)
    local PlotSigns = workspace:WaitForChild("PlotSigns"):GetDescendants()
    for _, sign in ipairs(PlotSigns) do
        if sign.Name == "TycoonSign" .. plotNumber then
            -- Teleport the player back to their plot's sign
            player.Character:SetPrimaryPartCFrame(sign["Become Owner"].Head.CFrame + Vector3.new(15, 0, -10))
            resetCamera(player) -- Reset camera back to player's view
            print(player.Name .. " teleported back to plot " .. plotNumber)
            return
        end
    end
    print("No plot sign found for plot " .. plotNumber)
end

-- This is called when the service starts
function Module.Start()
    
end

-- Initializes the system and connects to other systems
function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
