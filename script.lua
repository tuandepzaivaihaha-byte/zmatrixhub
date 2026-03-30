repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CHARACTER
local char, hrp, humanoid
local function setup()
    char = player.Character or player.CharacterAdded:Wait()
    hrp = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
end
setup()
player.CharacterAdded:Connect(setup)

-- STATE
local autoFarm = false

------------------------------------------------
-- FIND MOB (CÁCH CHẮC CHẮN NHẤT)
------------------------------------------------
local function getMob()
    local nearest, dist = nil, math.huge

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") 
        and v:FindFirstChild("Humanoid") 
        and v:FindFirstChild("HumanoidRootPart")
        and v ~= char
        and v.Humanoid.Health > 0 then

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
-- AUTO FARM REAL (KHÔNG FAIL)
------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.2)

        if autoFarm then
            local mob = getMob()

            if mob then
                local mhrp = mob:FindFirstChild("HumanoidRootPart")

                if mhrp then
                    -- TELE LÊN ĐẦU MOB (ANTI DIE)
                    hrp.CFrame = mhrp.CFrame * CFrame.new(0, 5, 0)

                    -- GIỮ NHÂN VẬT ĐỨNG
                    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
                end
            end
        end
    end
end)

------------------------------------------------
-- UI ĐƠN GIẢN (CHẮC CHẠY)
------------------------------------------------
pcall(function()
    player.PlayerGui:FindFirstChild("ZMatrixHub"):Destroy()
end)

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ZMatrixHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,120)
frame.Position = UDim2.new(0.4,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ZMatrix Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1,-20,0,40)
btn.Position = UDim2.new(0,10,0,50)
btn.Text = "AUTO FARM: OFF"
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.TextColor3 = Color3.new(1,1,1)

btn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    btn.Text = "AUTO FARM: " .. (autoFarm and "ON" or "OFF")
end)

------------------------------------------------
-- TOGGLE UI (INSERT)
------------------------------------------------
UIS.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)
