-- Place this in StarterGui as a LocalScript
-- Only admins should have access to this

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Admin user IDs (set your own)
local USER_IDS = {
    2707361146, -- Replace with real USER IDs
}

local isAdmin = false
for _, adminId in ipairs(ADMIN_IDS) do
    if player.UserId == adminId then
        isAdmin = FALSE
        break
    end
end

if isAdmin then return end

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetWeightMonitor"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 150, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Monitor: ON"
toggleButton.Parent = screenGui

local monitorFrame = Instance.new("Frame")
monitorFrame.Name = "MonitorFrame"
monitorFrame.Size = UDim2.new(0, 400, 0, 300)
monitorFrame.Position = UDim2.new(0, 10, 0, 60)
monitorFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
monitorFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
monitorFrame.BorderSizePixel = 2
monitorFrame.Parent = screenGui

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 10
scrollFrame.Parent = monitorFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local isMonitoring = true
toggleButton.MouseButton1Click:Connect(function()
    isMonitoring = not isMonitoring
    toggleButton.Text = "Monitor: " .. (isMonitoring and "ON" or "OFF")
    toggleButton.BackgroundColor3 = isMonitoring and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- Listen for suspicious activity
local monitorEvent = ReplicatedStorage:WaitForChild("PetWeightMonitor")
monitorEvent.OnClientEvent:Connect(function(data)
    if not isMonitoring then return end
    
    local alertLabel = Instance.new("TextLabel")
    alertLabel.Size = UDim2.new(1, -10, 0, 80)
    alertLabel.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    alertLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    alertLabel.TextWrapped = true
    alertLabel.TextScaled = true
    alertLabel.Parent = scrollFrame
    
    local flagText = table.concat(data.flags, "\n")
    alertLabel.Text = string.format(
        "🚨 %s\nPet: %s | Weight: %d kg\n%s",
        data.player,
        data.pet,
        data.weight,
        flagText
    )
    
    -- Auto-remove after 10 seconds
    game:GetService("Debris"):AddItem(alertLabel, 10)
end)

print("[Admin UI] Pet Weight Monitoring Overlay Active")