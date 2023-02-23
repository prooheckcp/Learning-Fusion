local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local New = Fusion.New
local Value = Fusion.Value
local Tween = Fusion.Tween
local Spring = Fusion.Spring
local Computed = Fusion.Computed

local style = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
local sizeValue = Value(UDim2.fromScale(0.3, 0.1))
local tween = Tween(sizeValue, style)


New "ScreenGui" {
    Parent = Players.LocalPlayer.PlayerGui,
    [Fusion.Children] = {
        New "TextButton" {
            BackgroundColor3 = Color3.fromRGB(122, 122, 122),
            Text = "Press me!",
            TextColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = Spring(Computed(function()
                return sizeValue:get()
            end)),

            [Fusion.OnEvent "Activated"] = function()
                sizeValue:set(UDim2.fromScale(0.35, 0.15))
            end
        }
    }
}
