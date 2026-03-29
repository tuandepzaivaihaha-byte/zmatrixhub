local Players = game:GetService("Players")
local player = Players.LocalPlayer

local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local autoFarm = true

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

task.spawn(function()
    while true do
        task.wait(0.3)

        if autoFarm then
            local enemy = getNearestEnemy()

            if enemy then
                humanoid:MoveTo(enemy.HumanoidRootPart.Position)

                -- đứng gần thì đánh luôn
                if (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude < 8 then
                    enemy.Humanoid:TakeDamage(10)
                end
            end
        end
    end
end)
