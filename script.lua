repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CHARACTER
local char, hrp, humanoid
local function setupCharacter()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end
setupCharacter()
player.CharacterAdded:Connect(setupCharacter)

-- REMOTES
local SkillEvent = ReplicatedStorage:WaitForChild("UseSkill")
local QuestEvent = ReplicatedStorage:WaitForChild("QuestRemote")

-- STATES
local autoFarm = false
local autoSkill = false
local autoQuest = false

-- REMOVE OLD UI
pcall(function()
    player.PlayerGui:FindFirstChild("ZMatrixHub"):Destroy()
end)

------------------------------------------------
-- ENEMY
------------------------------------------------
local function getNearestEnemy()
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end

    local nearest, dist = nil, math.huge

    for _, mob in pairs(folder:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
            if mob.Humanoid.Health > 0 then
                local d = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = mob
                end
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
        task.wait(0.3)

        if autoFarm then
            local enemy = getNearestEnemy()

            if enemy then
                local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude

                if dist > 6 then
                    humanoid:MoveTo(enemy.HumanoidRootPart.Position)
                else
                    SkillEvent:FireServer("M1")
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
        task.wait(2)

        if autoSkill then
            SkillEvent:FireServer("Z")
            task.wait(0.3)
            SkillEvent:FireServer("X")
        end
    end
end)

------------------------------------------------
-- AUTO QUEST
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(5)

        if autoQuest then
            QuestEvent:FireServer("AcceptQuest", "BanditQuest")
        end
    end
end)

------------------------------------------------
-- UI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ZMatrixHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 230)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BorderSizePixel = 0
frame.Parent = gui

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextScaled = true
title.Parent = frame

-- SUB TITLE (VI + EN)
local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1,0,0,20)
sub.Position = UDim2.new(0,0,0,35)
sub.BackgroundTransparency = 1
sub.Text = "Auto Farm / Tự động farm"
sub.TextColor3 = Color3.fromRGB(180,180,180)
sub.TextScaled = true
sub.Parent = frame

-- DRAG
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
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

------------------------------------------------
-- BUTTON
------------------------------------------------
local function createButton(textVI, textEN, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,40)
    btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Text = textEN .. " / " .. textVI .. ": OFF"
    btn.Parent = frame

    local state = false

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = textEN .. " / " .. textVI .. (state and ": ON" or ": OFF")
        callback(state)
    end)
end

createButton("Tự động farm", "AUTO FARM", 70, function(v) autoFarm = v end)
createButton("Tự dùng skill", "AUTO SKILL", 120, function(v) autoSkill = v end)
createButton("Tự nhận nhiệm vụ", "AUTO QUEST", 170, function(v) autoQuest = v end)

------------------------------------------------
-- TOGGLE UI (INSERT)
------------------------------------------------
local visible = true

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Insert then
        visible = not visible
        frame.Visible = visible
    end
end)

------------------------------------------------
-- MINI BUTTON
------------------------------------------------
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,110,0,30)
toggleBtn.Position = UDim2.new(0,10,0,10)
toggleBtn.Text = "Open Hub"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Parent = gui

toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)
