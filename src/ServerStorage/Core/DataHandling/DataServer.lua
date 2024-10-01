local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))
local Promise = ReplicatedModules.Classes.Promise
local WaitFor = ReplicatedModules.Classes.WaitFor
local Signal = ReplicatedModules.Classes.Signal

local ServerStorage = game:GetService('ServerStorage')
local ServerModules = require(ServerStorage:WaitForChild("Modules"))
local ProfileService = ServerModules.Services.ProfileService

local SystemsContainer = {}

-- // Module // --
local Module = {}

Module.ProfileStoreName = string.format(`%s_data_key_store`, game.PlaceId)
Module.ProfileStructure = {
	Coins = {
        CurrentData = 0,
        Replicated = {
            is = true,
            InstanceName = "IntValue",
			Parent = "leaderstats",
        }
    },
	Gems = {
		CurrentData = 0,
		Replicated = {
			is = true,
			InstanceName = "IntValue",
			Parent = "leaderstats",
		}
	},
	CityNum = {
		CurrentData = 1,
		Replicated = {
			is = false,
			InstanceName = "IntValue",
		}
	},
	RestaurantNum = {
		CurrentData = 1,
		Replicated = {
			is = false,
			InstanceName = "IntValue",
		}
	},
	HasStartedCurrentRestaurant = {
		CurrentData = {false},
		Replicated = {
			is = false,
			InstanceName = "Table",
		}
	},
	RestaurantUpgradeLevel = {
		CurrentData = 0,
		Replicated = {
			is = false,
			InstanceName = "IntValue",
		}
	},
	RestaurantProgress = {
		CurrentData = {},
		Replicated = {
			is = false,
			InstanceName = "IntValue",
		}
	},
}
Module.ProfileShards = {
	test = function(this, ...)
	print(this)
	return this, ... or nil
end,}
Module.Profiles = {}
Module.Client = {}

export type ProfileStoreName = string
export type ProfileStructure = {
	ProfileStoreName : string,
	ProfileStructure : {
		[string] : {
			CurrentData : {number | string | table | any?},
			Replicated : {
				is : boolean,
				InstanceName : string,
				Parent : {string | Instance},
			}
		}
	},
}

export type Module = {
	ProfileStoreName : string,

	getAllData : (dataSource : {Player | {Player}}) -> {string | number | table}?,
	createShard : (shardName : string, shardFunction : any) -> any,
	useShard : (shardName : string, any : any) -> any,
	removeShard : (shardName : string) -> any,
	fetch : (dataSource : { Player | {Player}}, dataName : string) -> {string | number | table}?,
	set : (dataSource : { Player | {Player}}, dataName : string, newData : {string | number | table}) -> boolean,
	add : (dataSource : { Player | {Player}}, dataName : string, newDataName : string, newData : {string | number | table}) -> boolean,
	remove : (dataSource : { Player | {Player}}, dataName : string, indexDataName : string) -> boolean,
	wipe : (dataSource : { Player | {Player}}, dataName : string) -> boolean,
	wipeall : (dataSource : { Player | {Player}}) -> boolean,

	Profiles : {
		{ProfileStructure}
	},
}

local function stringify(v : table, spaces : number, usesemicolon : boolean, depth : number)
	if not v then return end

	local insert = table.insert

	if type(v) ~= 'table' then
		return tostring(v)
	elseif not next(v) then
		return '{}'
	end

	spaces = spaces or 4
	depth = depth or 1

	local space = (" "):rep(depth * spaces)
	local sep = usesemicolon and ";" or ","
	local concatenationBuilder = {"{"}

	for k, x in next, v do
		insert(concatenationBuilder, ("\n%s[%s] = %s%s"):format(space,type(k)=='number'and tostring(k)or('"%s"'):format(tostring(k)), stringify(x, spaces, usesemicolon, depth+1), sep))
	end

	local s = table.concat(concatenationBuilder)
	return ("%s\n%s}"):format(s:sub(1,-2), space:sub(1, -spaces-1))
end

function Module.Wait(player : Player)
	while not Module.Profiles[player] do
		task.wait()
	end
end

function Module.createShard(shardName : string, shardFunction)
	if not game:GetAttribute("messaged") then
		warn("[DataService : WARNING] : Shards created through this function do not SAVE, they are only used for temporary data manipulation.")
		game:SetAttribute("messaged", true)
	end

	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if not shardFunction or not shardName then return end

	Module.ProfileShards[shardName] = shardFunction
end

function Module.useShard(shardName : string, ...) : any
	if not game:GetAttribute("messaged") then
		warn("[DataService : WARNING] : Shards created through this function do not SAVE, they are only used for temporary data manipulation.")
		game:SetAttribute("messaged", true)
	end

	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if not shardName then return end

	return Module.ProfileShards[shardName](Module, ...)
end

function Module.removeShard(shardName : string)
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if not shardName then return end

	Module.ProfileShards[shardName] = nil
end

function Module.fetch(dataSource : { Player | {Player}}, dataName : string) : {string | number | table}?
	if not dataSource then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if typeof(dataSource) == "table" then
		local foundData = {}

		task.spawn(function()
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data[dataName].CurrentData) or nil) then
					foundData = Module.Profiles[player].Data[dataName].CurrentData
				end
			end
		end)

		return foundData or nil
	else
		-- when i use things like this its just cause i love one liners, this just checks if the profile exists and if the data exists, if it does, it returns the data, if not, it returns nil
		return (((Module.Profiles[dataSource] and true) and Module.Profiles[dataSource].Data[dataName].CurrentData) or nil)
	end
end

function Module.GetAllData(dataSource : {Player | {Player}}) : {string | number | table}?
	if not dataSource then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if typeof(dataSource) == "table" then
		local foundData = {}

		task.spawn(function()
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data) or nil) then
					foundData = Module.Profiles[player].Data
				end
			end
		end)

		return foundData or nil
	else
		return (((Module.Profiles[dataSource] and true) and Module.Profiles[dataSource].Data) or nil)
	end
end

function Module.set(dataSource : { Player | {Player}}, dataName : string, newData : {string | number | table}) : boolean
	if not dataSource then return end
	if not Module.Profiles[dataSource] or not Module.Profiles[dataSource].Data[dataName] then return false end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if typeof(dataSource) == "table" then 
		task.spawn(function()
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data[dataName].CurrentData) or nil) then
					Module.Profiles[player].Data[dataName].CurrentData = newData
				end
			end
		end)

		return true
	else
		Module.Profiles[dataSource].Data[dataName].CurrentData = newData

		return true
	end
end

function Module.setDeep(dataSource : {Player | {Player}}, dataName : string, deepPath : string, newData : any) : boolean
	if not dataSource then return end
	if not Module.Profiles[dataSource] or not Module.Profiles[dataSource].Data[dataName] then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	local function setNestedData(table, path, value)
		local current = table
		for i = 1, #path - 1 do
			if not current[path[i]] then
				current[path[i]] = {}
			end
			current = current[path[i]]
		end

		current[path[#path]] = value
	end

	local path = {}
	for str in string.gmatch(deepPath, "([^%.]+)") do
		table.insert(path, str)
	end

	if typeof(dataSource) == "table" then 
		task.spawn(function()
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data[dataName].CurrentData) or nil) then
					setNestedData(Module.Profiles[player].Data[dataName].CurrentData, path, newData)
				end
			end
		end)

		return true
	else
		setNestedData(Module.Profiles[dataSource].Data[dataName].CurrentData, path, newData)
		return true
	end
end

function Module.add(dataSource : { Player | {Player}}, dataName : string, newDataName : string, newData : {string | number | table}) : boolean
	if not dataSource then return end
	if not Module.Profiles[dataSource] or not Module.Profiles[dataSource].Data[dataName] then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if typeof(dataSource) == "table" then 
		local operationSuccess : boolean = true

		Promise.new(function(resolve, reject)
			local approvedSources = {}
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data[dataName].CurrentData) or nil) then
					table.insert(approvedSources, player)
				end
			end

			resolve(approvedSources)
		end):andThen(function(approvedSources : table)
			for _, player : Player in pairs(approvedSources) do
				Module.Profiles[player].Data[dataName].CurrentData[newDataName or "UNDEFINED_DATA_" .. tostring(os.time()) :: number] = newData
			end
		end):catch(function()
			operationSuccess = not operationSuccess
		end)

		return operationSuccess or false
	else
		local targetData = Module.Profiles[dataSource].Data[dataName].CurrentData
		targetData[newDataName or "UNDEFINED_DATA_" .. tostring(os.time()) :: number] = newData

		return true
	end
end

function Module.addDeep(dataSource : {Player | {Player}}, dataName : string, deepPath : string, newDataName : string, newData : any) : boolean
	if not dataSource or not Module.Profiles or not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	local function setNestedData(table, path, value)
		local current = table
		for i = 1, #path do
			if i == #path then
				current[path[i]] = value
			else
				current[path[i]] = current[path[i]] or {}
				current = current[path[i]]
			end
		end
	end

	local path = {}
	for str in string.gmatch(deepPath, "([^%.]+)") do
		table.insert(path, str)
	end

	if typeof(dataSource) == "table" then
		for _, player in ipairs(dataSource) do
			local profile = Module.Profiles[player]
			if profile and profile.Data[dataName] then
				setNestedData(profile.Data[dataName].CurrentData, path, newData)
			end
		end
	else
		local profile = Module.Profiles[dataSource]
		if profile and profile.Data[dataName] then
			setNestedData(profile.Data[dataName].CurrentData, path, newData)
		end
	end

	return true
end

function Module.remove(dataSource : { Player | {Player}}, dataName : string, indexDataName : string) : boolean
	if not dataSource then return end
	if not Module.Profiles[dataSource] or not Module.Profiles[dataSource].Data[dataName] then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	if typeof(dataSource) == "table" then 
		local operationSuccess : boolean = true

		Promise.new(function(resolve, reject)
			local approvedSources = {}
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and Module.Profiles[player].Data[dataName].CurrentData) or nil) then
					table.insert(approvedSources, player)
				end
			end

			resolve(approvedSources)
		end):andThen(function(approvedSources : table)
			for _, player : Player in pairs(approvedSources) do
				Module.Profiles[player].Data[dataName].CurrentData[indexDataName] = nil
			end
		end):catch(function()
			operationSuccess = not operationSuccess
		end)

		return operationSuccess or false
	else
		local targetData = Module.Profiles[dataSource].Data[dataName].CurrentData

		targetData[indexDataName] = nil
		
		return true
	end
end

function Module.removeDeep(dataSource : {Player | {Player}}, dataName : string, deepPath : string) : boolean
	if not dataSource then return end
	if not Module.Profiles or not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	local function setNestedData(table, path, value)
		local current = table
		for i = 1, #path do 
			if i == #path then
				current[path[i]] = value
			else
				current[path[i]] = current[path[i]] or {}
				current = current[path[i]]
			end
		end
	end

	local path = {}
	for str in string.gmatch(deepPath, "([^%.]+)") do
		table.insert(path, str)
	end

	local function processDataSource(source)
		if Module.Profiles[source] and Module.Profiles[source].Data[dataName] then
			setNestedData(Module.Profiles[source].Data[dataName].CurrentData, path, nil)
		end
	end

	if typeof(dataSource) == "table" then
		task.spawn(function()
			for _, player in pairs(dataSource) do
				processDataSource(player)
			end
		end)
	else
		processDataSource(dataSource)
	end

	return true
end

function Module.increment(dataSource: {Player | Player}, dataName: string, deepPath: string, incrementAmount: any)
	local function incrementValue(table, path, amount)
		local current = table
		for i = 1, #path - 1 do
			current = current[path[i]] or {}
		end
		current[path[#path]] = (current[path[#path]] or 0) + amount
	end

	local path = {}
	for str in string.gmatch(deepPath, "([^%.]+)") do
		table.insert(path, str)
	end

	if typeof(dataSource) == "table" then
		for _, player in pairs(dataSource) do
			if Module.Profiles[player] and Module.Profiles[player].Data[dataName] then
				incrementValue(Module.Profiles[player].Data[dataName].CurrentData, path, incrementAmount)
			end
		end
	else
		incrementValue(Module.Profiles[dataSource].Data[dataName].CurrentData, path, incrementAmount)
	end
end

function Module.decrease(dataSource: {Player | Player}, dataName: string, deepPath: string, decrementAmount: any)
	local function decrementValue(table, path, amount)
		local current = table
		for i = 1, #path - 1 do
			current = current[path[i]] or {}
		end
		current[path[#path]] = (current[path[#path]] or 0) - amount
	end

	local path = {}
	for str in string.gmatch(deepPath, "([^%.]+)") do
		table.insert(path, str)
	end

	if typeof(dataSource) == "table" then
		for _, player in pairs(dataSource) do
			if Module.Profiles[player] and Module.Profiles[player].Data[dataName] then
				decrementValue(Module.Profiles[player].Data[dataName].CurrentData, path, decrementAmount)
			end
		end
	else
		decrementValue(Module.Profiles[dataSource].Data[dataName].CurrentData, path, decrementAmount)
	end
end

function Module.incrementDeep(player: Player, dataName: string, deepPath: string, incrementAmount: any)
	Module.increment(player, dataName, deepPath, incrementAmount)
end

function Module.decreaseDeep(player: Player, dataName: string, deepPath: string, decrementAmount: any)
	Module.decrease(player, dataName, deepPath, decrementAmount)
end

function Module.wipe(dataSource : { Player | {Player}}) : boolean
	if not dataSource then return end
	if not next(Module.Profiles) then
		return false, "Data source or profiles are not available"
	end

	local ProfileStore : ProfileStructure = ProfileService.GetProfileStore(Module.ProfileStoreName :: ProfileStoreName, Module.ProfileStructure :: ProfileStructure)

	if typeof(dataSource) == "table" then 
		local operationSuccess : boolean = true

		Promise.new(function(resolve, reject)
			local approvedSources = {}
			for _, player in pairs(dataSource) do
				if (((Module.Profiles[player] and true) and true) or nil) then
					table.insert(approvedSources, player)
				end
			end

			resolve(approvedSources)
		end):andThen(function(approvedSources : table)
			for _, player : Player in pairs(approvedSources) do
				ProfileStore:WipeProfileAsync(string.format("Player_%s", dataSource.UserId))
			end
		end):catch(function()
			operationSuccess = not operationSuccess
		end)

		return operationSuccess or nil
	else
		ProfileStore:WipeProfileAsync(string.format("Player_%s", dataSource.UserId))
		return true
	end
end

function Module.StartServer()
	local start = os.clock()

	-- local FirstJoinRemote = Warp.Server("FirstJoinRemote")

	local ProfileStore : ProfileStructure = ProfileService.GetProfileStore(
		Module.ProfileStoreName :: ProfileStoreName,
		Module.ProfileStructure :: ProfileStructure
	)

	local function loadProfile(player : Player)
		local profile : table = Module.Profiles[player :: Player]

		local leaderstats : Folder = Instance.new("Folder", player :: Player)
		leaderstats.Name = "leaderstats"

		task.spawn(function()
			local function createValues()
				local operations : table = {}

				for dataName, dataValues in pairs(Module.ProfileStructure) do
					if dataValues.Replicated.is == true then
						table.insert(operations, Promise.new(function(resolve, reject)
							local dataInstance : Instance = Instance.new(tostring(dataValues.Replicated.InstanceName), (((dataValues.Replicated.Parent == "leaderstats" and true) and leaderstats) or player) or reject())
							resolve({dataInstance = dataInstance, dataName = dataName, dataValues = dataValues})
						end))
					end
				end

				Promise.all(operations):andThen(function(results)
					for _, result in ipairs(results) do
						local dataInstance, dataName, dataValues = result.dataInstance, result.dataName, result.dataValues
						dataInstance.Name = dataValues.Replicated.Name or dataName
						dataInstance.Value = dataValues.CurrentData
					end
				end):catch(function(err)
					error(err or "An unknown error occured")
				end)
			end

			local function updateValues()
				task.spawn(function()
					while task.wait() do
						if not profile then continue end

						for dataName, dataValues in pairs(profile.Data) do
							if dataValues.Replicated.is == false then
								continue
							else
								local existingInstance : Instance = (((dataValues.Replicated.Parent == "leaderstats" and true) and leaderstats:FindFirstChild(dataValues.Replicated.Name or dataName)) or player:FindFirstChild(dataValues.Replicated.Name or dataName))

								existingInstance.Value = dataValues.CurrentData
							end
						end
					end
				end)
			end
			local createValuesTask = coroutine.resume(coroutine.create(createValues))
			local updateValuesTask = coroutine.resume(coroutine.create(updateValues))

			local RestaurantHandling = SystemsContainer.ParentSystems.RestaurantHandling.RestaurantHandling
        	RestaurantHandling.DisplayRestaurant(player)
		end)
	end

	local function playerAdded(player : Player)
		local profile = ProfileStore:LoadProfileAsync(string.format("Player_%s", player.UserId), "ForceLoad")
		if not profile then player:Kick("Unable to load save data. Please Rejoin!") end

		print(string.format("Loaded profile for %s in %s seconds", player.Name, os.clock() - start))

		profile:AddUserId(player.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			Module.Profiles[player] = nil
			player:Kick("Your profile has been loaded remotely. Please Rejoin!")
		end)

		if player:IsDescendantOf(Players) then
			Module.Profiles[player] = profile
			coroutine.wrap(loadProfile)(player :: Player)
		else
			profile:Release()
		end
	end

	task.spawn(function()
		for _, Player : Player in ipairs(Players:GetPlayers()) do
			task.spawn(playerAdded, Player :: Player)
		end
	end)

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(function(Player : Player)
		local profile = Module.Profiles[Player]

		if profile ~= nil then
			print(profile.Data)
			profile:Release()
		end
	end)
end

function Module.Start()
	Module.StartServer()
end

function Module.Init(otherSystems)
	SystemsContainer = otherSystems
end

return Module