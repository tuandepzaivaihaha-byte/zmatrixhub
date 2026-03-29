-- ZMatrix Hub UI (Pro Style)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 420, 0, 250)
Main.Position = UDim2.new(0.35, 0, 0.35, 0)
Main.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- Sidebar
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0, 120, 1, 0)
Side.BackgroundColor3 = Color3.fromRGB(20,20,20)

-- Title
local Title = Instance.new("TextLabel", Side)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "ZMatrix Hub"
Title.TextColor3 = Color3.fromRGB(0,255,255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

-- Tabs
local MainTab = Instance.new("TextButton", Side)
MainTab.Size = UDim2.new(1,0,0,35)
MainTab.Position = UDim2.new(0,0,0.2,0)
MainTab.Text = "Main"

local UpdateTab = Instance.new("TextButton", Side)
UpdateTab.Size = UDim2.new(1,0,0,35)
UpdateTab.Position = UDim2.new(0,0,0.35,0)
UpdateTab.Text = "Updates"

-- Content Area
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -120, 1, 0)
Content.Position = UDim2.new(0, 120, 0, 0)
Content.BackgroundTransparency = 1

-- Toggle Button (Auto Farm)
local FarmToggle = Instance.new("TextButton", Content)
FarmToggle.Size = UDim2.new(0.8,0,0,40)
FarmToggle.Position = UDim2.new(0.1,0,0.2,0)
FarmToggle.Text = "Auto Farm: OFF"

local farming = false

FarmToggle.MouseButton1Click:Connect(function()
    farming = not farming
    FarmToggle.Text = farming and "Auto Farm: ON" or "Auto Farm: OFF"
end)

-- Toggle Button (Skill Spam)
local SkillToggle = Instance.new("TextButton", Content)
SkillToggle.Size = UDim2.new(0.8,0,0,40)
SkillToggle.Position = UDim2.new(0.1,0,0.4,0)
SkillToggle.Text = "Skill Spam: OFF"

local skill = false

SkillToggle.MouseButton1Click:Connect(function()
    skill = not skill
    SkillToggle.Text = skill and "Skill Spam: ON" or "Skill Spam: OFF"
end)

-- Footer
local Footer = Instance.new("TextLabel", Main)
Footer.Size = UDim2.new(1,0,0,25)
Footer.Position = UDim2.new(0,0,1,-25)
Footer.Text = "ZMatrix Hub v1.0"
Footer.TextColor3 = Color3.fromRGB(0,255,255)
Footer.BackgroundTransparency = 1
Footer.TextScaled = true

-- Demo loop
task.spawn(function()
    while true do
        if farming then
            print("Auto Farm Running (demo)")
        end
        if skill then
            print("Skill Spam Running (demo)")
        end
        task.wait(1)
    end
end)
