local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- REMOTES
local SkillEvent = ReplicatedStorage:WaitForChild("UseSkill")
local QuestEvent = ReplicatedStorage:WaitForChild("QuestRemote")

-- STATES
local autoFarm, autoSkill, autoQuest = false, false, false

------------------------------------------------
-- FIND NEAREST ENEMY
------------------------------------------------
local function getNearestEnemy()
    local nearest, dist = nil, math.huge

    for _, mob in pairs(workspace:WaitForChild("Enemies"):GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") then
            local d = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = mob
            end
        end
    end

    return nearest
end

------------------------------------------------
-- AUTO FARM
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.25)

        if autoFarm then
            local enemy = getNearestEnemy()

            if enemy then
                humanoid:MoveTo(enemy.HumanoidRootPart.Position)

                if (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude < 8 then
                    if enemy:FindFirstChild("Humanoid") then
                        enemy.Humanoid:TakeDamage(10)
                    end
                end
            end
        end
    end
end)

------------------------------------------------
-- AUTO SKILL
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1)

        if autoSkill then
            SkillEvent:FireServer("Z")
            task.wait(0.2)
            SkillEvent:FireServer("X")
        end
    end
end)

------------------------------------------------
-- AUTO QUEST
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(3)

        if autoQuest then
            QuestEvent:FireServer("AcceptQuest", "BanditQuest")
        end
    end
end)

------------------------------------------------
-- UI HUB (GLOBAL STYLE)
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZMatrixHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 240)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Parent = gui

-- DRAG UI
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = frame

-- BUTTON SYSTEM
local function button(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,y)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Parent = frame

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

button("AUTO FARM", 60, function(v) autoFarm = v end)
button("AUTO SKILL", 110, function(v) autoSkill = v end)
button("AUTO QUEST", 160, function(v) autoQuest = v end)
