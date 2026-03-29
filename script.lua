-- Intro Screen
local ScreenGui = Instance.new("ScreenGui")
local Intro = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

Intro.Parent = ScreenGui
Intro.Size = UDim2.new(1,0,1,0)
Intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
Intro.Text = "ZMatrix Hub"
Intro.TextColor3 = Color3.fromRGB(0,255,255)
Intro.TextScaled = true

-- Wait 2 seconds
task.wait(2)

-- Remove intro
Intro:Destroy()

-- ===== MAIN MENU =====
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Button = Instance.new("TextButton")

local spamming = false

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 260, 0, 160)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "ZMatrix Hub"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

Button.Parent = Frame
Button.Size = UDim2.new(0.8,0,0,45)
Button.Position = UDim2.new(0.1,0,0.5,0)
Button.Text = "Skill Spam: OFF"
Button.TextScaled = true

-- Toggle button
Button.MouseButton1Click:Connect(function()
    spamming = not spamming
    Button.Text = spamming and "Skill Spam: ON" or "Skill Spam: OFF"
end)

-- Skill spam loop
task.spawn(function()
    while true do
        if spamming then
            local vim = game:GetService("VirtualInputManager")

            vim:SendKeyEvent(true, "Z", false, game)
            vim:SendKeyEvent(false, "Z", false, game)
            task.wait(0.3)

            vim:SendKeyEvent(true, "X", false, game)
            vim:SendKeyEvent(false, "X", false, game)
            task.wait(0.3)

            vim:SendKeyEvent(true, "C", false, game)
            vim:SendKeyEvent(false, "C", false, game)
        end
        task.wait(0.1)
    end
end)
