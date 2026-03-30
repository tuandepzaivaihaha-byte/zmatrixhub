-- Chờ game load xong
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local autoFarm = false

-- Hàm lấy nhân vật an toàn
local function getChar() return player.Character or player.CharacterAdded:Wait() end

-- TÌM QUÁI TỐI ƯU HƠN
local function getMob()
    local nearest, dist = nil, 500 -- Khoảng cách tối đa 500 studs
    -- Thay vì GetDescendants, hãy kiểm tra các Model trong Workspace
    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local root = v:FindFirstChild("HumanoidRootPart")
            if root and v ~= getChar() then
                local d = (getChar().HumanoidRootPart.Position - root.Position).Magnitude
                if d < dist then
                    dist = d
                    nearest = v
                end
            end
        end
    end
    return nearest
end

-- VÒNG LẶP AUTO FARM
task.spawn(function()
    while task.wait() do
        if autoFarm then
            local char = getChar()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local mob = getMob()

            if mob and hrp then
                local mhrp = mob:FindFirstChild("HumanoidRootPart")
                
                -- Khóa vị trí trên đầu quái (Dùng CFrame liên tục)
                hrp.CFrame = mhrp.CFrame * CFrame.new(0, 7, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                
                -- TỰ ĐỘNG ĐÁNH (Cần tìm đúng RemoteEvent của game Sailor Piece)
                -- Thông thường là: 
                local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Events") -- Ví dụ thôi nhé
                if combatRemote then
                    -- combatRemote:FireServer("Attack") -- Bạn cần check tên Remote chính xác trong game
                end
            end
        end
    end
end)

-- UI VÀ TOGGLE (GIỮ NGUYÊN PHẦN CŨ CỦA BẠN NHƯNG FIX LỖI HIỂN THỊ)
-- ... (Phần UI của bạn khá ổn, chỉ cần đảm bảo btn.MouseButton1Click hoạt động)
