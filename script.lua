--// ZMATRIX HUB FULL SYSTEM (FOR OWN GAME ONLY)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--// REMOTES (CHANGE THESE TO YOUR GAME)
local SkillEvent = ReplicatedStorage:WaitForChild("UseSkill")
local QuestEvent = ReplicatedStorage:WaitForChild("QuestRemote")

--// TOGGLES
local autoFarm = false
local autoSkill = false
local autoQuest = false

------------------------------------------------
--// FIND NEAREST ENEMY
------------------------------------------------
local function getNearestEnemy()
    local nearest, dist = nil, math.huge

    for _, v in pairs(workspace:WaitForChild("Enemies"):GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") then
            local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                nearest = v
            end
        end
    end

    return nearest
end

------------------------------------------------
--// AUTO FARM LOOP
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.5)

        if autoFarm then
            local enemy = getNearestEnemy()
            if enemy then
                humanoid:MoveTo(enemy.HumanoidRootPart.Position)
            end
        end
    end
end)

------------------------------------------------
--// AUTO SKILL LOOP
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1.5)

        if autoSkill then
            SkillEvent:FireServer("Z")
            SkillEvent:FireServer("X")
        end
    end
end)

------------------------------------------------
--// AUTO QUEST LOOP
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
--// UI HUB
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZMatrixHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.Position = UDim2.new(0, 0, 0.1, 0)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

------------------------------------------------
--// BUTTON FACTORY
------------------------------------------------
local function createButton(name, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 50)
    btn.Position = UDim2.new(0.5, -110, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name .. ": OFF"
    btn.TextScaled = true
    btn.Parent = frame

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

------------------------------------------------
--// TOGGLES UI
------------------------------------------------
createButton("AUTO FARM", 0.35, function(v)
    autoFarm = v
end)

createButton("AUTO SKILL", 0.45, function(v)
    autoSkill = v
end)

createButton("AUTO QUEST", 0.55, function(v)
    autoQuest = v
end)
