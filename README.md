local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ADMIN CHECK
local ADMINS = {
    2707361146
}

local isAdmin = false
for _, id in ipairs(ADMINS) do
    if player.UserId == id then
        isAdmin = true
        break
    end
end

if not isAdmin then return end

-- UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggLoggerUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = screenGui

local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0, 5)

local event = ReplicatedStorage:WaitForChild("EggLogEvent")

event.OnClientEvent:Connect(function(data)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 60)
    label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame

    label.Text = "🐣 " .. data.player ..
                 "\n🐾 " .. data.pet ..
                 " | ⚖️ " .. data.weight .. " KG"
end)
