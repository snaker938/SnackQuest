local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer


local SystemsContainer = {}

-- // Module // --
local Module = {}

function Module.DisableDefaultKeybinds()
    CAS:BindActionAtPriority("DisableI", function()
        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.I)

    CAS:BindActionAtPriority("DisableL", function()
        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.L)
end

function Module.InputBegan(input, _gameProcessed)
end

function Module.Start()
    Module.DisableDefaultKeybinds()

    UserInputService.InputBegan:Connect(function(input, _gameProcessed)
        Module.InputBegan(input, _gameProcessed)
    end)

    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end

function Module.Init(otherSystems)
    SystemsContainer = otherSystems
end

return Module