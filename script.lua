
--// SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

--// REMOTES (PHẢI CÓ TRONG GAME BẠN)
local SkillEvent = ReplicatedStorage:WaitForChild("UseSkill")
local QuestEvent = ReplicatedStorage:WaitForChild("QuestRemote")

--// TOGGLES
local autoFarm = false
local autoSkill = false
local autoQuest = false

------------------------------------------------
-- FIND NEAREST ENEMY
------------------------------------------------
local function getNearestEnemy()
    local nearest = nil
    local dist = math.huge

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
-- AUTO FARM LOOP
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.3)

        if autoFarm then
            local enemy = getNearestEnemy()

            if enemy then
                humanoid:MoveTo(enemy.HumanoidRootPart.Position)

                -- đánh khi gần
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
-- AUTO SKILL LOOP
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(1.2)

        if autoSkill then
            SkillEvent:FireServer("Z")
            task.wait(0.2)
            SkillEvent:FireServer("X")
        end
    end
end)

------------------------------------------------
-- AUTO QUEST LOOP
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
-- UI HUB
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZMatrixHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 220)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

------------------------------------------------
-- BUTTON FUNCTION
------------------------------------------------
local function createButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = text .. ": OFF"
    btn.Parent = frame

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
createButton("AUTO FARM", 60, function(v)
    autoFarm = v
end)

createButton("AUTO SKILL", 110, function(v)
    autoSkill = v
end)

createButton("AUTO QUEST", 160, function(v)
    autoQuest = v
end)
