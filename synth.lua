-- Create a ScreenGui to hold our UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSDisplay"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Create a frame for the display
local frame = Instance.new("Frame")
frame.Name = "StatsPanel"
frame.Size = UDim2.new(0, 300, 0, 40)
frame.Position = UDim2.new(0.5, -150, 0, 10)
frame.AnchorPoint = Vector2.new(0, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
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
fpsLabel.Size = UDim2.new(0.5, 0, 1, 0)
fpsLabel.Position = UDim2.new(0, 0, 0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 20
fpsLabel.Parent = frame

-- Create mouse position text label
local mouseLabel = Instance.new("TextLabel")
mouseLabel.Name = "MouseLabel"
mouseLabel.Size = UDim2.new(0.5, 0, 1, 0)
mouseLabel.Position = UDim2.new(0.5, 0, 0, 0)
mouseLabel.BackgroundTransparency = 1
mouseLabel.Text = "Mouse: 0, 0"
mouseLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
mouseLabel.Font = Enum.Font.GothamBold
mouseLabel.TextSize = 20
mouseLabel.Parent = frame

-- Variables for FPS calculation
local lastTime = tick()
local frameCount = 0
local currentFPS = 0

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
    
    -- Get mouse position
    local mouse = game.Players.LocalPlayer:GetMouse()
    local mouseX = math.floor(mouse.X)
    local mouseY = math.floor(mouse.Y)
    
    -- Update labels
    fpsLabel.Text = "FPS: " .. currentFPS
    mouseLabel.Text = "Mouse: " .. mouseX .. ", " .. mouseY
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

print("FPS and Mouse Position Display loaded successfully!")
