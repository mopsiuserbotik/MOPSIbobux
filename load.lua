local COLORS = {
    Background = Color3.fromRGB(15, 15, 15),
    Shape = Color3.fromRGB(200, 200, 200),
    TextDefault = Color3.fromRGB(0, 0, 0)
}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MopsiHubLoader_Dark"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = COLORS.Background
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local backgroundAnimFrame = Instance.new("Frame")
backgroundAnimFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundAnimFrame.BackgroundTransparency = 1
backgroundAnimFrame.ZIndex = 1
backgroundAnimFrame.Parent = mainFrame

local function createShape()
    local shape = Instance.new("Frame")
    local size = math.random(50, 150)
    shape.Size = UDim2.new(0, size, 0, size)
    
    local side = math.random(1, 4)
    if side == 1 then shape.Position = UDim2.new(-0.2, 0, math.random(), 0)
    elseif side == 2 then shape.Position = UDim2.new(1.2, 0, math.random(), 0)
    elseif side == 3 then shape.Position = UDim2.new(math.random(), 0, -0.2, 0)
    else shape.Position = UDim2.new(math.random(), 0, 1.2, 0)
    end
    
    shape.BackgroundColor3 = COLORS.Shape
    shape.BackgroundTransparency = 0.9
    shape.BorderSizePixel = 0
    shape.Rotation = math.random(0, 360)
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, math.random(5, 30))
    uiCorner.Parent = shape
    
    shape.Parent = backgroundAnimFrame
    
    local randomTargetX = math.random(20, 80) / 100
    local randomTargetY = math.random(20, 80) / 100
    local animTime = math.random(10, 20)
    
    local tweenInfo = TweenInfo.new(animTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(shape, tweenInfo, {
        Position = UDim2.new(randomTargetX, 0, randomTargetY, 0),
        Rotation = shape.Rotation + math.random(90, 360),
        BackgroundTransparency = 0.8
    })
    tween:Play()
end

for i = 1, 5 do
    createShape()
end

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 0, 220)
textLabel.Position = UDim2.new(0, 0, 0.5, -110)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = COLORS.TextDefault
textLabel.TextStrokeTransparency = 0.3
textLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 36
textLabel.Font = Enum.Font.SourceSansBold
textLabel.ZIndex = 2

textLabel.Text = "MOPSI-Hub\nby FAUST\n\nЗагрузка скрипта..."
textLabel.TextTransparency = 1
textLabel.Parent = mainFrame

local blinkConnection = RunService.RenderStepped:Connect(function()
    local val = math.abs(math.sin(tick() * 4)) * 90
    textLabel.TextColor3 = Color3.fromRGB(val, val, val)
end)

TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15}):Play()
local fadeInText = TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 0})
fadeInText:Play()

fadeInText.Completed:Wait()

local scriptUrl = "https://raw.githubusercontent.com/mopsiuserbotik/MOPSIbobux/refs/heads/main/mopsi.lua"

task.wait(0.5)

local success, result = pcall(function()
    local content = game:HttpGet(scriptUrl)
    return loadstring(content)()
end)

if success then
    textLabel.Text = "MOPSI-Hub\nby FAUST\n\nЗагружено Успешно!"
else
    textLabel.Text = "MOPSI-Hub\nby FAUST\n\nОшибка загрузки скрипта!"
    textLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
    warn("Mopsi Loader Ошибка: " .. tostring(result))
end

task.wait(2)

TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
fadeOut:Play()

fadeOut.Completed:Connect(function()
    blinkConnection:Disconnect()
    screenGui:Destroy()
end)
