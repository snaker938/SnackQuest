local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ReplicatedModules = require(ReplicatedStorage:WaitForChild('Modules'))
local Trove = ReplicatedModules.Classes.Trove

local Warp = ReplicatedModules.Classes.Warp

local Interface = LocalPlayer:WaitForChild('PlayerGui')

local LocalModules = require(LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Modules"))

local SystemsContainer = {}
local WidgetControllerModule = {}

-- // Module // --
local Module = {}

Module.WidgetTrove = Trove.new()
Module.Open = false

function Module.UpdateWidget()

end

function Module.OpenWidget()
	if Module.Open then
		return
	end
	
	Module.Open = true
end

function Module.CloseWidget()
	if not Module.Open then
		return
	end

	Module.Open = false
	Module.WidgetTrove:Destroy()
end

function Module.Start()
	local TestBtn = Interface:WaitForChild("ScreenGui"):WaitForChild("TestBtn")
	local TestRemote = Warp.Client("AddCoins");

	TestBtn.MouseButton1Click:Connect(function()
		TestRemote:Fire(true, 10)
	end)

	local TestCooker = workspace:WaitForChild("TestCooker")

	local DisplayOutlineService = LocalModules.Services.DisplayOutlineService

	DisplayOutlineService.DisplayOutline(TestCooker)


end

function Module.Init(ParentController, otherSystems)
	WidgetControllerModule = ParentController
	SystemsContainer = otherSystems
end

return Module
