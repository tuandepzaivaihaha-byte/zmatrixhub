-- ZMatrix Hub v1.0

-- ===== INTRO =====
local ScreenGui = Instance.new("ScreenGui")
local Intro = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui

Intro.Parent = ScreenGui
Intro.Size = UDim2.new(1,0,1,0)
Intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
Intro.Text = "ZMatrix Hub"
Intro.TextColor3 = Color3.fromRGB(0,255,255)
Intro.TextScaled = true

task.wait(2)
Intro:Destroy()

-- ===== MAIN MENU =====
local Frame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FarmButton = Instance.new("TextButton")
local Footer = Instance.new("TextLabel")

local farming = false

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

Footer.Parent = Frame
Footer.Size = UDim2.new(1,0,0,25)
Footer.Position = UDim2.new(0,0,1,-25)
Footer.Text = "ZMatrix Hub v1.0"
Footer.TextScaled = true
Footer.TextColor3 = Color3.fromRGB(0,255,255)
Footer.BackgroundTransparency = 1

-- Toggle Auto Farm
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    FarmButton.Text = farming and "Auto Farm: ON" or "Auto Farm: OFF"
end)

-- ===== AUTO FARM LOOP =====
task.spawn(function()
    while true do
        if farming then
            local player = game.Players.LocalPlayer
            local char = player.Character
            
            if char and char:FindFirstChild("HumanoidRootPart") then
                
                -- 🔥 TELEPORT TO QUEST (EDIT THIS)
                char.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
                
                -- 🔥 SKILL SPAM
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
        end
        task.wait(2)
    end
end)
