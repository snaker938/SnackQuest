-- Client Module (e.g., in ReplicatedStorage.Modules.DisplayUpgradeArrowService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage:WaitForChild("Assets")

local ReplicatedModules = ReplicatedStorage:WaitForChild('Modules')
local Trove = require(ReplicatedModules:WaitForChild("Classes"):WaitForChild("Trove"))

local SystemsContainer = {}

-- // Module // --
local Module = {}

Module.Trove = Trove.new()

-- Table to keep track of active arrows and their animations
local activeArrows = {}

-- Function to display the upgrade arrow over a specific part
function Module.DisplayUpgradeArrow(part : Instance)
    -- Check if the arrow is already displayed for this part
    if activeArrows[part] then
        return -- Arrow already displayed
    end

    -- Clone the UpgradeArrow model from ReplicatedStorage
    local arrowModel = Assets:WaitForChild("UpgradeArrow"):Clone()

    arrowModel.Name = "UpgradeArrow"
    arrowModel.Parent = workspace -- Or parent it to a suitable container

    -- Ensure the arrow model has a PrimaryPart set
    if not arrowModel.PrimaryPart then
        warn("UpgradeArrow model does not have a PrimaryPart set.")
        return
    end

    -- Position the arrow above the part
    local partCFrame = part:GetPivot() -- Get the CFrame of the part
    local arrowHeight = arrowModel:GetExtentsSize().Y
    local desiredGap = 5 -- Adjust as needed
    local arrowOffsetY = part.Size.Y / 2 + arrowHeight / 2 + desiredGap
    local initialPosition = partCFrame.Position + Vector3.new(0, arrowOffsetY, 0)

    -- Set the initial rotation based on the arrow's natural orientation
    local initialRotation = CFrame.Angles(0, math.rad(90), math.rad(90))

    -- Set the arrow's initial CFrame, including its orientation
    arrowModel:SetPrimaryPartCFrame(
        CFrame.new(initialPosition) * initialRotation
    )

    -- Function to animate the arrow (bob and rotate)
    local runService = game:GetService("RunService")
    local timeElapsed = 0
    local amplitude = 0.5     -- Bobbing amplitude
    local frequency = 1       -- Bobbing frequency (cycles per second)
    local rotationSpeed = 45  -- Degrees per second

    local function animateArrow(dt)
        if not arrowModel or not arrowModel.Parent then
            -- Arrow has been destroyed; clean up
            if activeArrows[part] and activeArrows[part].connection then
                activeArrows[part].connection:Disconnect()
                activeArrows[part] = nil
            end
            return
        end

        timeElapsed = timeElapsed + dt

        -- Bobbing effect
        local bobbingY = math.sin(timeElapsed * frequency * math.pi * 2) * amplitude

        -- Rotation effect
        local rotationAngle = timeElapsed * math.rad(rotationSpeed)

        -- Update arrow position and rotation
        local newPosition = initialPosition + Vector3.new(0, bobbingY, 0)

        -- Rotate around the local X-axis
        arrowModel:SetPrimaryPartCFrame(
            CFrame.new(newPosition) *
            initialRotation *
            CFrame.Angles(rotationAngle, 0, 0)
        )
    end

    -- Connect the animation function to RenderStepped
    local connection = runService.RenderStepped:Connect(animateArrow)

    -- Store the arrow and connection so we can clean up later
    activeArrows[part] = {
        arrow = arrowModel,
        connection = connection,
    }

    Module.Trove:Add(arrowModel)
end

-- Function to destroy the upgrade arrow for a specific part
function Module.DestroyUpgradeArrow(part : Instance)
    if activeArrows[part] then
        -- Disconnect the animation function
        if activeArrows[part].connection then
            activeArrows[part].connection:Disconnect()
        end
        -- Destroy the arrow model
        if activeArrows[part].arrow then
            activeArrows[part].arrow:Destroy()
        end
        -- Remove from activeArrows table
        activeArrows[part] = nil

        Module.Trove:Remove(part)
    end
end

function Module.Start()
    
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
