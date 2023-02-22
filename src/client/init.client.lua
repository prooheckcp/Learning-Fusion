local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Label = require(script.Label)

local Value = Fusion.Value
local Observer = Fusion.Observer
local New = Fusion.New
local Hydrate = Fusion.Hydrate

local color = Value(Color3.fromRGB(100, 100, 100))

local app = New("ScreenGui"){
    Parent = Players.LocalPlayer.PlayerGui,
    Name = "Hello World",
    [Fusion.Children] = Hydrate(Label()){
        BackgroundColor3 = color
    }
}