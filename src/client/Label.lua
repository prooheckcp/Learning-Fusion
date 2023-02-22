local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Fusion = require(ReplicatedStorage.Packages.Fusion)
local Value = Fusion.Value
local New = Fusion.New

local text = Value("Hello World!")

local function Label()
    return New("TextLabel"){
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.2, 0.2),
        Text = text
    }
end

task.delay(5, function()
    text:set(":D")
end)

return Label