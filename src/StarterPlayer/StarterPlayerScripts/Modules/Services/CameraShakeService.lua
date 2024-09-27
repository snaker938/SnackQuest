local SystemsContainer = {}
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- // Module // --
local Module = {}
local shaking = false  -- A flag to track whether the camera is currently shaking

-- Helper function to apply camera shake
local function applyCameraShake(camera, startCFrame, intensity)
    -- Random offsets for shake based on intensity
    local xOffset = math.random(-100, 100) / (500 / intensity)
    local yOffset = math.random(-100, 100) / (500 / intensity)
    local zOffset = math.random(-100, 100) / (500 / intensity)

    -- Apply the camera shake
    camera.CFrame = startCFrame * CFrame.new(xOffset, yOffset, zOffset)
end

-- Gradual camera shake function with increasing intensity
function Module.ShakeCameraGradually(timeToHold)
    local player = Players.LocalPlayer
    local camera = workspace.CurrentCamera
    local startCFrame = camera.CFrame
    local startTime = tick()
    local intensity = 0  -- Start with no intensity
    local maxIntensity = 5  -- The maximum shake intensity

    shaking = true  -- Set shaking to true when we start the shake

    -- Shake the camera with gradually increasing intensity
    while shaking do
        task.wait()
        local elapsedTime = tick() - startTime

        -- Gradually increase the intensity up to the max as time progresses
        if elapsedTime < timeToHold then
            intensity = math.clamp(elapsedTime / timeToHold * maxIntensity, 0, maxIntensity)
        else
            intensity = maxIntensity  -- Keep at max intensity once the timeToHold is hit
        end

        -- Apply the shake with the current intensity
        applyCameraShake(camera, startCFrame, intensity)
    end

    -- Reset the camera to its original position when shaking stops
    camera.CFrame = startCFrame
end

-- Function to stop the camera shake
function Module.StopShake()
    shaking = false  -- Set shaking to false to stop the loop
end

function Module.Start()
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module