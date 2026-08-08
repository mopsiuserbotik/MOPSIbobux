-- Создание UI
local Players = game:GetService("Players")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local textLabel = Instance.new("TextLabel")

screenGui.Name = "MopsiLoaderGui"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Увеличили размер контейнера, чтобы поместились все строки
textLabel.Size = UDim2.new(1, 0, 0, 220)
textLabel.Position = UDim2.new(0, 0, 0.5, -110)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextStrokeTransparency = 0
textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
textLabel.TextSize = 36
textLabel.Font = Enum.Font.SourceSansBold

-- Одновременный вывод информации об авторстве и статуса
textLabel.Text = "MOPSI-Hub\nMade by FAUST\nTG:@faust_cheats\n\nЗагрузка скрипта..."
textLabel.TextTransparency = 1
textLabel.Parent = mainFrame

-- [[ РАДУЖНАЯ АНИМАЦИЯ ]]
-- Полный цикл смены цвета за 3 секунды
local rainbowConnection = RunService.RenderStepped:Connect(function()
    local hue = (tick() % 3) / 3
    textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
end)

-- [[ LOGIKA ZAGRUZKI ]]

-- 1. Анимация появления
TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0.3}):Play()
local fadeInText = TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 0})
fadeInText:Play()

fadeInText.Completed:Wait()

-- 2. Загрузка внешнего скрипта
local scriptUrl = "https://gist.githubusercontent.com/mopsiuserbotik/5ef0bcee0583d8ad0cd232059a57e502/raw/513a229ccde2f1044b3c6c32cedfae20c299a746/gistfile1.txt"

local success, result = pcall(function()
    local content = game:HttpGet(scriptUrl)
    return loadstring(content)()
end)

if success then
    textLabel.Text = "MOPSI-Hub\nMade by FAUST\nTG:@faust_cheats\n\nЗагружено Успешно!"
else
    textLabel.Text = "MOPSI-Hub\nMade by FAUST\nTG:@faust_cheats\n\nError loading script!"
    warn("Mopsi Loader Error: " .. tostring(result))
end

task.wait(2)

-- 3. Анимация исчезновения и удаление
TweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
fadeOut:Play()

fadeOut.Completed:Connect(function()
    rainbowConnection:Disconnect() -- Остановка обновления цвета при удалении UI
    screenGui:Destroy()
end)