local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))

local ServerStorage = game:GetService('ServerStorage')

local ServerModules = require(ServerStorage:WaitForChild("Modules"))
local ProfileService = ServerModules.Services.ProfileService

-- Data
local PlotData = ReplicatedModules.Data.PlotData
local CityData = ReplicatedModules.Data.CityData

local SystemsContainer = {}

-- // Module // --
local Module = {}

-- Helper function to get the restaurant model from ServerStorage
function Module.GetRestaurantModel(restaurantName)
    -- Remove spaces from restaurantName to get the model (e.g., "Pizza Place" becomes "PizzaPlace")
    local modelName = restaurantName:gsub("%s+", "")
    local restaurantModel = ServerStorage.Restaurants:FindFirstChild(modelName)

    if not restaurantModel then
        warn("Restaurant model for " .. modelName .. " not found!")
        return nil
    end

    return restaurantModel
end

-- Helper function to destroy the restaurant model on the player's plot
function Module.DestroyRestaurant(player : Player)
    local PlotHandler = SystemsContainer.ParentSystems.RestaurantHandling.PlotHandling
    local plotNum = PlotHandler.GetPlayerPlotNum(player)
    local plotsFolder = workspace:FindFirstChild("Plots")

    if not plotsFolder then
        warn("No Plots folder found in the workspace.")
        return
    end

    -- Search for the specific plot model for the player
    for _, model in ipairs(plotsFolder:GetChildren()) do
        if model.Name:find("_" .. plotNum) then
            model:Destroy()
            print("Destroyed restaurant for player " .. player.Name .. " at plot " .. plotNum)
            return
        end
    end

    print("No restaurant found to destroy for player " .. player.Name)
end

-- Function to display a restaurant on the player's plot
function Module.DisplayRestaurant(player : Player)
    local PlotHandler = SystemsContainer.ParentSystems.RestaurantHandling.PlotHandling
    local DataHandling = SystemsContainer.ParentSystems.DataHandling.DataHandling

    local playerData = DataHandling.GetAllData(player)
    local cityNumber = playerData.City
    local restaurantNum = playerData.Restaurant
    local plotNum = PlotHandler.GetPlayerPlotNum(player)

    -- Get the restaurant name based on the current city and restaurant number
    local restaurantName = CityData.GetCurrentRestaurantName(cityNumber, restaurantNum)

    -- Get the restaurant model
    local restaurantModel = Module.GetRestaurantModel(restaurantName)
    if not restaurantModel then
        return
    end

    -- Destroy any existing restaurant on the player's plot before placing a new one
    Module.DestroyRestaurant(player)

    -- Get the plot position and orientation
    local position = PlotData.GetPlotData(plotNum, "position")
    local orientation = PlotData.GetPlotData(plotNum, "orientation")

    -- Clone the restaurant model and set its position and orientation
    local clonedModel = restaurantModel:Clone()
    -- Name the cloned model as "{firstName}{secondName}_{plotNum}"
    clonedModel.Name = restaurantName:gsub("%s+", "") .. "_" .. plotNum

    -- Ensure PrimaryPart is already set in Studio as 'Base'
    if clonedModel.PrimaryPart then
        clonedModel:SetPrimaryPartCFrame(CFrame.new(position) * CFrame.Angles(0, math.rad(orientation.Y), 0))
    else
        warn("PrimaryPart not set for model " .. clonedModel.Name)
    end

    -- Place the restaurant model in the "Plots" folder in the workspace
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        plotsFolder = Instance.new("Folder")
        plotsFolder.Name = "Plots"
        plotsFolder.Parent = workspace
    end

    clonedModel.Parent = plotsFolder
    print("Placed " .. restaurantName .. " at Plot " .. plotNum .. " for player " .. player.Name)
end

function Module.Start()
    -- Placeholder for any initialization logic
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module
