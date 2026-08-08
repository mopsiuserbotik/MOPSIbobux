local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MopsiLoaderGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = overlay

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(45, 45, 45)
uiStroke.Thickness = 1.5
uiStroke.Transparency = 1
uiStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 16)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MOPSI HUB"
titleLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0, 18)
creditsLabel.Position = UDim2.new(0, 0, 0, 46)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "By FAUST"
creditsLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
creditsLabel.TextSize = 12
creditsLabel.Font = Enum.Font.GothamMedium
creditsLabel.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 20)
statusLabel.Position = UDim2.new(0, 20, 0, 84)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Инициализация..."
statusLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(1, -40, 0, 6)
progressBg.Position = UDim2.new(0, 20, 0, 112)
progressBg.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
progressBg.BorderSizePixel = 0
progressBg.Parent = mainFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(1, 0)
bgCorner.Parent = progressBg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = progressBar

local targetSize = UDim2.new(0, 360, 0, 145)

TweenService:Create(overlay, TweenInfo.new(0.3), {BackgroundTransparency = 0.45}):Play()
TweenService:Create(uiStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()

local popIn = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = targetSize
})
popIn:Play()
popIn.Completed:Wait()

local scriptUrl = "https://raw.githubusercontent.com/mopsiuserbotik/MOPSIbobux/refs/heads/main/mopsi.lua"

statusLabel.Text = "Загрузка скрипта..."

local fillProgress = TweenService:Create(progressBar, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0.8, 0, 1, 0)
})
fillProgress:Play()

local success, result
task.spawn(function()
    success, result = pcall(function()
        local content = game:HttpGet(scriptUrl)
        return loadstring(content)()
    end)
end)

repeat task.wait() until success ~= nil

fillProgress:Cancel()

if success then
    statusLabel.Text = "Успешно загружено!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local finishTween = TweenService:Create(progressBar, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    finishTween:Play()
    finishTween.Completed:Wait()
else
    statusLabel.Text = "Ошибка при загрузке!"
    statusLabel.TextColor3 = Color3.fromRGB(235, 75, 75)
    progressBar.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    warn("Mopsi Loader Error: " .. tostring(result))
end

task.wait(1)

local popOut = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0)
})
TweenService:Create(overlay, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
popOut:Play()

popOut.Completed:Connect(function()
    screenGui:Destroy()
end)
