local SystemsContainer = {}

-- // Module // --
local Module = {}

function Module.Start()
    
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module

-- -- CustomerHandling.lua
-- local ReplicatedStorage = game:GetService('ReplicatedStorage')
-- local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))

-- local ServerStorage = game:GetService('ServerStorage')

-- local ServerModules = require(ServerStorage:WaitForChild("Modules"))

-- -- Data
-- local PlotData = ReplicatedModules.Data.PlotData
-- local CityData = ReplicatedModules.Data.CityData

-- local SystemsContainer = {}

-- -- // Module // --
-- local Module = {}

-- -- Table to keep track of per-player data
-- Module.PlayersData = {}

-- -- Function to get the player's restaurant model from the workspace
-- function Module.GetPlayerRestaurantModel(player)
--     local DataHandling = SystemsContainer.ParentSystems.DataHandling.DataHandling
--     local playerData = DataHandling.GetAllData(player)
--     local cityNumber = playerData.CityNum
--     local restaurantNum = playerData.RestaurantNum
--     local restaurantName = CityData.GetCurrentRestaurantName(cityNumber, restaurantNum)
--     local PlotHandler = SystemsContainer.ParentSystems.RestaurantHandling.PlotHandling
--     local plotNum = PlotHandler.GetPlayerPlotNum(player)

--     -- Construct the model name
--     local modelName = restaurantName:gsub("%s+", "") .. "_" .. plotNum
--     local plotsFolder = workspace:FindFirstChild("Plots")
--     if not plotsFolder then
--         warn("No Plots folder found in the workspace.")
--         return nil
--     end
--     local restaurantModel = plotsFolder:FindFirstChild(modelName)
--     if not restaurantModel then
--         warn("Player's restaurant model not found in the workspace.")
--         return nil
--     end
--     return restaurantModel
-- end

-- -- Function to set up the customer model (unanchor parts and weld together)
-- function Module.SetupCustomerModel(customerModel)
--     -- Ensure the customerModel has a PrimaryPart
--     local primaryPart = customerModel:FindFirstChild("Body") or customerModel:FindFirstChildWhichIsA("BasePart")
--     if not primaryPart then
--         warn("Customer model has no primary part")
--         return false
--     end
--     customerModel.PrimaryPart = primaryPart

--     -- Unanchor all parts and set up WeldConstraints
--     for _, part in ipairs(customerModel:GetDescendants()) do
--         if part:IsA("BasePart") then
--             part.Anchored = false
--             if part ~= primaryPart then
--                 local weld = Instance.new("WeldConstraint")
--                 weld.Part0 = primaryPart
--                 weld.Part1 = part
--                 weld.Parent = primaryPart
--             end
--         end
--     end
--     return true
-- end

-- -- Function to move the customer model to a target point with floating and bobbing effect
-- function Module.MoveCustomerToPoint(customerModel, targetPoint)
--     local customerPrimaryPart = customerModel.PrimaryPart
--     if not customerPrimaryPart then
--         warn("Customer model has no primary part")
--         return
--     end

--     local startPosition = customerPrimaryPart.Position
--     local endPosition = targetPoint.Position

--     local totalDistance = (endPosition - startPosition).Magnitude
--     local speed = 4  -- Units per second, adjust as needed
--     local duration = totalDistance / speed

--     local startTime = tick()
--     local RunService = game:GetService("RunService")

--     local movementComplete = false

--     local connection
--     connection = RunService.Heartbeat:Connect(function()
--         local elapsedTime = tick() - startTime
--         local alpha = math.clamp(elapsedTime / duration, 0, 1)
--         local position = startPosition:Lerp(endPosition, alpha)

--         -- Bobbing effect
--         local bobbingAmplitude = 3  -- Adjust as needed
--         local bobbingFrequency = 2    -- Adjust as needed
--         local bobbing = math.sin(elapsedTime * bobbingFrequency * math.pi * 2) * bobbingAmplitude

--         position = position + Vector3.new(0, bobbing, 0)

--         -- Ensure customer remains upright with the correct orientation (0, 90, 90)
--         customerPrimaryPart.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(90), math.rad(90))

--         if alpha >= 1 then
--             -- Movement is complete
--             connection:Disconnect()
--             movementComplete = true
--         end
--     end)

--     -- Wait until movement is complete
--     while not movementComplete do
--         task.wait()
--     end
-- end

-- -- Function to handle customer order completion
-- function Module.CustomerOrderCompleted(player, customerModel)
--     local playerInfo = Module.PlayersData[player]
--     if playerInfo and playerInfo.Customers[customerModel] then
--         -- Signal that the customer's order is completed
--         playerInfo.Customers[customerModel].OrderCompleted = true
--     else
--         warn("Customer not found in player's data")
--     end
-- end

-- -- Function to spawn one customer for a player
-- function Module.SpawnCustomer(player)
--     -- Initialize player data if not already done
--     if not Module.PlayersData[player] then
--         Module.PlayersData[player] = {
--             OccupiedOrderPoints = {},
--             Customers = {}
--         }
--     end
--     local playerInfo = Module.PlayersData[player]

--     -- Get the player's restaurant model
--     local playerRestaurantModel = Module.GetPlayerRestaurantModel(player)
--     if not playerRestaurantModel then
--         return
--     end

--     local spawnPointsFolder = playerRestaurantModel:FindFirstChild("CustomerSpawnPoints")
--     local orderPointsFolder = playerRestaurantModel:FindFirstChild("CustomerOrderPoints")
--     local endPointsFolder = playerRestaurantModel:FindFirstChild("CustomerEndPoints")

--     if not spawnPointsFolder or not orderPointsFolder or not endPointsFolder then
--         warn("Missing customer points in player's restaurant model")
--         return
--     end

--     -- Get the lists of points
--     local spawnPoints = spawnPointsFolder:GetChildren()
--     local orderPoints = orderPointsFolder:GetChildren()
--     local endPoints = endPointsFolder:GetChildren()

--     -- Limit the number of customers to the number of order points
--     local maxCustomers = #orderPoints

--     -- Get the number of existing customers
--     local existingCustomers = 0
--     for _ in pairs(playerInfo.Customers) do
--         existingCustomers = existingCustomers + 1
--     end

--     if existingCustomers >= maxCustomers then
--         warn("Maximum number of customers reached for player " .. player.Name)
--         return
--     end

--     -- Only spawn one customer at a time
--     local customerModel = ServerStorage.Customers.Customer:Clone() :: Model

--     -- Set up the customer model (unanchor parts and weld together)
--     if not Module.SetupCustomerModel(customerModel) then
--         customerModel:Destroy()
--         return
--     end

--     -- Set random colors for Head and Body parts
--     local body = customerModel:FindFirstChild("Body")
--     local head = body:FindFirstChild("Head")

--     if head and body then
--         print("Assining random colors")
--         head.Color = Color3.new(math.random(), math.random(), math.random())
--         body.Color = Color3.new(math.random(), math.random(), math.random())
--     end

--     -- Place the customer at a random spawn point and set correct orientation (0, 90, 90)
--     local spawnPoint = spawnPoints[math.random(1, #spawnPoints)]
--     customerModel:SetPrimaryPartCFrame(spawnPoint.CFrame * CFrame.Angles(0, math.rad(90), math.rad(90)))

--     -- Place the customer inside the "Customers" folder within the player's restaurant
--     local customersFolder = playerRestaurantModel:FindFirstChild("Customers")
--     if not customersFolder then
--         customersFolder = Instance.new("Folder")
--         customersFolder.Name = "Customers"
--         customersFolder.Parent = playerRestaurantModel
--     end

--     customerModel.Parent = customersFolder

--     -- Add customer to player's customers list
--     playerInfo.Customers[customerModel] = {
--         OrderCompleted = false
--     }

--     -- Wait 2 seconds
--     task.wait(2)

--     -- Move to an available order point
--     local occupiedOrderPoints = playerInfo.OccupiedOrderPoints

--     -- Find an available order point
--     local availableOrderPoint = nil

--     repeat
--         for _, orderPoint in ipairs(orderPoints) do
--             if not occupiedOrderPoints[orderPoint] then
--                 availableOrderPoint = orderPoint
--                 break
--             end
--         end
--         if not availableOrderPoint then
--             -- All order points are occupied, wait and try again
--             task.wait(1)
--         end
--     until availableOrderPoint

--     -- Mark the order point as occupied
--     occupiedOrderPoints[availableOrderPoint] = true

--     -- Move the customer to the order point
--     Module.MoveCustomerToPoint(customerModel, availableOrderPoint)

--     -- Wait until the customer's order is completed
--     local customerData = playerInfo.Customers[customerModel]
--     while not customerData.OrderCompleted do
--         task.wait(0.1)
--     end

--     -- Customer is ready to leave, unmark the order point
--     occupiedOrderPoints[availableOrderPoint] = nil

--     -- Move to a random end point
--     local endPoint = endPoints[math.random(1, #endPoints)]
--     Module.MoveCustomerToPoint(customerModel, endPoint)

--     -- Once at the end point, delete the customer
--     customerModel:Destroy()

--     -- Remove customer from player's customers list
--     playerInfo.Customers[customerModel] = nil
-- end

-- function Module.Start()
--     -- Placeholder for any initialization logic
-- end

-- function Module.Init(otherSystems)
--     SystemsContainer = otherSystems
-- end

-- return Module