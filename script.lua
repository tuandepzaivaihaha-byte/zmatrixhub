local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmButton = Instance.new("TextButton")

local farming = false

ScreenGui.Parent = game.CoreGui

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 260, 0, 180)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "ZMatrix Hub"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

FarmButton.Parent = Frame
FarmButton.Size = UDim2.new(0.8,0,0,45)
FarmButton.Position = UDim2.new(0.1,0,0.5,0)
FarmButton.Text = "Auto Farm: OFF"
FarmButton.TextScaled = true

-- Toggle nút
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    FarmButton.Text = farming and "Auto Farm: ON" or "Auto Farm: OFF"
end)

-- Loop demo
task.spawn(function()
    while true do
        if farming then
            print("Auto Farm đang chạy (demo)")
        end
        task.wait(1)
    end
end)
