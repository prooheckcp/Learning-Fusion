local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Label = require(script.Label)

local Value = Fusion.Value
local Observer = Fusion.Observer
local New = Fusion.New
local Hydrate = Fusion.Hydrate
local ForValues = Fusion.ForValues
local ForPairs = Fusion.ForPairs

local names = Value({"prooheckcp", "prooheck", "proo"})
local color = Value(Color3.fromRGB(100, 100, 100))

--[[
local app = New "ScreenGui" {
    Parent = Players.LocalPlayer.PlayerGui,
    Name = "Hello World",
    [Fusion.Children] = 
    {
        Hydrate(Label()){
            BackgroundColor3 = color
        },

        ForPairs(names, function(index, value)
            return index, New "TextLabel" {
                Size = UDim2.fromScale(1, 0.1),
                Position = UDim2.fromScale(0, 0.11 * (index - 1)),
                Text = value
            }
        end, Fusion.cleanup)
    }

}    
]]
