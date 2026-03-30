repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
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

-- TRY FIND REMOTES (auto detect)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkillEvent = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")

-- STATES
local autoFarm = false

-- REMOVE OLD UI
pcall(function()
    player.PlayerGui:FindFirstChild("ZMatrixHub"):Destroy()
end)

------------------------------------------------
-- FIND ENEMY (Sailor Piece)
------------------------------------------------
local function getNearestEnemy()
    local nearest, dist = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v ~= char and v.Humanoid.Health > 0 then
                local d = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = v
                end
            end
        end
    end

    return nearest
end

------------------------------------------------
-- AUTO FARM (ỔN ĐỊNH)
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.25)

        if autoFarm then
            local enemy = getNearestEnemy()

            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                local pos = enemy.HumanoidRootPart.Position
                local dist = (hrp.Position - pos).Magnitude

                -- TELE GẦN (farm nhanh hơn)
                if dist > 5 then
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0,3,0))
                else
                    -- đánh thường
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)

                    -- thử spam remote (nếu có)
                    if SkillEvent then
                        pcall(function()
                            SkillEvent:FireServer("Z")
                            SkillEvent:FireServer("X")
                        end)
                    end
                end
            end
        end
    end
end)

------------------------------------------------
-- UI
------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ZMatrixHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,280,0,150)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- BUTTON
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,40)
btn.Position = UDim2.new(0,10,0,60)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = "AUTO FARM: OFF"

btn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    btn.Text = "AUTO FARM: " .. (autoFarm and "ON" or "OFF")
end)

------------------------------------------------
-- TOGGLE UI (INSERT)
------------------------------------------------
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)
