local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Text = Instance.new("TextLabel")
Text.Parent = ScreenGui
Text.Size = UDim2.new(0,300,0,100)
Text.Position = UDim2.new(0.3,0,0.3,0)
Text.Text = "ZMatrix Hub WORKING"
Text.TextScaled = true
Text.BackgroundColor3 = Color3.fromRGB(0,0,0)
Text.TextColor3 = Color3.fromRGB(0,255,255)
