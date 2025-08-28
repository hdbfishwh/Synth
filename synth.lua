-- Create a ScreenGui to hold our UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NetworkStatsDisplay"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Create a frame for the display
local frame = Instance.new("Frame")
frame.Name = "StatsPanel"
frame.Size = UDim2.new(0, 350, 0, 40)
frame.Position = UDim2.new(0.5, -175, 0, 10)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Add rounded corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Add a stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 130, 180)
stroke.Thickness = 2
stroke.Parent = frame

-- Create FPS text label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(0.33, 0, 1, 0)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 18
fpsLabel.Parent = frame

-- Create Mbps text label
local mbpsLabel = Instance.new("TextLabel")
mbpsLabel.Name = "MbpsLabel"
mbpsLabel.Size = UDim2.new(0.33, 0, 1, 0)
mbpsLabel.Position = UDim2.new(0.33, 0, 0, 0)
mbpsLabel.BackgroundTransparency = 1
mbpsLabel.Text = "Mbps: 0.0"
mbpsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
mbpsLabel.Font = Enum.Font.GothamBold
mbpsLabel.TextSize = 18
mbpsLabel.Parent = frame

-- Create MS (ping) text label
local msLabel = Instance.new("TextLabel")
msLabel.Name = "MSLabel"
msLabel.Size = UDim2.new(0.34, 0, 1, 0)
msLabel.Position = UDim2.new(0.66, 0, 0, 0)
msLabel.BackgroundTransparency = 1
msLabel.Text = "Ping: 0ms"
msLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
msLabel.Font = Enum.Font.GothamBold
msLabel.TextSize = 18
msLabel.Parent = frame

-- Variables for FPS calculation
local lastTime = tick()
local frameCount = 0
local currentFPS = 0

-- Variables for network stats
local lastBytesReceived = 0
local lastBytesSent = 0
local lastStatsTime = tick()

-- Function to format bytes to Mbps
local function formatMbps(bytes)
    return string.format("%.1f", (bytes * 8) / 1000000) -- Convert bytes to megabits
end

-- Function to update the display
local function updateDisplay()
    -- Calculate FPS
    frameCount = frameCount + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        currentFPS = math.floor(frameCount / (currentTime - lastTime))
        frameCount = 0
        lastTime = currentTime
    end
    
    -- Calculate network stats every 0.5 seconds
    if currentTime - lastStatsTime >= 0.5 then
        -- Get network stats
        local stats = game:GetService("Stats")
        local network = stats.Network
        
        -- Calculate received Mbps
        local bytesReceived = network.ServerReceivedBytes
        local receivedMbps = formatMbps((bytesReceived - lastBytesReceived) / (currentTime - lastStatsTime))
        lastBytesReceived = bytesReceived
        
        -- Calculate sent Mbps
        local bytesSent = network.ServerSentBytes
        local sentMbps = formatMbps((bytesSent - lastBytesSent) / (currentTime - lastStatsTime))
        lastBytesSent = bytesSent
        
        -- Get ping
        local ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0)
        
        -- Update labels
        mbpsLabel.Text = "Net: " .. receivedMbps .. "↓ " .. sentMbps .. "↑"
        msLabel.Text = "Ping: " .. ping .. "ms"
        
        -- Update ping color based on value
        if ping < 100 then
            msLabel.TextColor3 = Color3.fromRGB(100, 220, 100) -- Green for good ping
        elseif ping < 200 then
            msLabel.TextColor3 = Color3.fromRGB(220, 220, 100) -- Yellow for medium ping
        else
            msLabel.TextColor3 = Color3.fromRGB(220, 100, 100) -- Red for high ping
        end
        
        lastStatsTime = currentTime
    end
    
    -- Update FPS label
    fpsLabel.Text = "FPS: " .. currentFPS
    
    -- Update FPS color based on value
    if currentFPS >= 50 then
        fpsLabel.TextColor3 = Color3.fromRGB(100, 220, 100) -- Green for good FPS
    elseif currentFPS >= 30 then
        fpsLabel.TextColor3 = Color3.fromRGB(220, 220, 100) -- Yellow for medium FPS
    else
        fpsLabel.TextColor3 = Color3.fromRGB(220, 100, 100) -- Red for low FPS
    end
end

-- Connect to RenderStepped to update the display every frame
game:GetService("RunService").RenderStepped:Connect(updateDisplay)

-- Optional: Make the panel draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

print("FPS and Network Stats Display loaded successfully!")
