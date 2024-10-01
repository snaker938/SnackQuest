local SystemsContainer = {}

-- // Module // --
local Module = {}

-- Function to create a dotted line between two points
local function createDottedLine(startPos, endPos, parent, color)
    local distance = (endPos - startPos).Magnitude
    local direction = (endPos - startPos).Unit
    local dotLength = 0.2      -- Length of each dot
    local gapLength = 0.1      -- Length of gap between dots
    local segmentLength = dotLength + gapLength
    local totalDots = math.floor(distance / segmentLength)

    for i = 0, totalDots do
        local offset = direction * (i * segmentLength)
        local dotStart = startPos + offset
        local dotEnd = dotStart + direction * dotLength

        -- Ensure we don't go beyond the end position
        if (dotStart - startPos).Magnitude > distance then
            break
        end

        -- Create the dot part
        local dotPart = Instance.new("Part")
        dotPart.Size = Vector3.new(0.05, 0.05, dotLength)
        dotPart.CFrame = CFrame.new((dotStart + dotEnd) / 2, dotEnd)
        dotPart.Anchored = true
        dotPart.CanCollide = false
        dotPart.Color = color or Color3.fromRGB(255, 255, 255)
        dotPart.Material = Enum.Material.Neon
        dotPart.Parent = parent
        dotPart.Name = "OutlineDot"
        dotPart.Transparency = 0
    end
end

-- Function to get the corners of a part
local function getPartCorners(part)
    local cf = part.CFrame
    local size = part.Size

    local corners = {}

    local x = size.X / 2
    local y = size.Y / 2
    local z = size.Z / 2

    -- Define the eight corners of the part
    local relativeCorners = {
        Vector3.new(-x, -y, -z),  -- Corner 1
        Vector3.new(x, -y, -z),   -- Corner 2
        Vector3.new(-x, y, -z),   -- Corner 3
        Vector3.new(x, y, -z),    -- Corner 4
        Vector3.new(-x, -y, z),   -- Corner 5
        Vector3.new(x, -y, z),    -- Corner 6
        Vector3.new(-x, y, z),    -- Corner 7
        Vector3.new(x, y, z),     -- Corner 8
    }

    for _, corner in ipairs(relativeCorners) do
        table.insert(corners, (cf * CFrame.new(corner)).Position)
    end

    return corners
end

-- Function to create the dotted outline around the part
function Module.DisplayOutline(part : Instance)
    -- Remove any existing outline
    Module.DestroyOutline(part)

    -- Create a folder to hold the outline parts
    local outlineFolder = Instance.new("Folder")
    outlineFolder.Name = "Outline"
    outlineFolder.Parent = part

    local corners = getPartCorners(part)

    -- Define the edges by specifying pairs of corner indices
    local edges = {
        {1,2},{2,6},{6,5},{5,1},  -- Bottom face edges
        {3,4},{4,8},{8,7},{7,3},  -- Top face edges
        {1,3},{2,4},{5,7},{6,8},  -- Vertical edges
    }

    for _, edge in ipairs(edges) do
        local startPos = corners[edge[1]]
        local endPos = corners[edge[2]]
        createDottedLine(startPos, endPos, outlineFolder)
    end
end

-- Function to destroy the outline for a specific part
function Module.DestroyOutline(part : Instance)
    if part:FindFirstChild("Outline") then
        part.Outline:Destroy()
    end
end

function Module.Start()
    
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
