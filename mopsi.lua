local LP = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
repeat task.wait() until game:IsLoaded() and LP and LP.Character and LP.Character:FindFirstChild("Animate") and LP.Character:FindFirstChildOfClass("Humanoid") and LP.Character.Humanoid:FindFirstChild("Animator")
local Animate = LP.Character.Animate
local URL = "http://www.roblox.com/asset/?id="
local workspace = game.Workspace

game.StarterPlayer.AllowCustomAnimations = true 
workspace:SetAttribute("RbxLegacyAnimationBlending", true)

if not getgenv().OriginalAnimations then
	getgenv().OriginalAnimations = {}
	if Animate:FindFirstChild("pose") then
		local poseAnimation = LP.Character.Animate.pose:FindFirstChildOfClass("Animation")
		if poseAnimation then
			getgenv().OriginalAnimations[3] = poseAnimation.AnimationId
		end
	end
	getgenv().OriginalAnimations[1] = Animate.idle.Animation1.AnimationId
	getgenv().OriginalAnimations[2] = Animate.idle.Animation2.AnimationId
	getgenv().OriginalAnimations[4] = Animate.walk:FindFirstChildOfClass("Animation").AnimationId
	getgenv().OriginalAnimations[5] = Animate.run:FindFirstChildOfClass("Animation").AnimationId
	getgenv().OriginalAnimations[6] = Animate.jump:FindFirstChildOfClass("Animation").AnimationId
	getgenv().OriginalAnimations[7] = Animate.climb:FindFirstChildOfClass("Animation").AnimationId
	getgenv().OriginalAnimations[8] = Animate.fall:FindFirstChildOfClass("Animation").AnimationId
	if Animate:FindFirstChild("swim") then 
		getgenv().OriginalAnimations[9] = Animate.swim:FindFirstChildOfClass("Animation").AnimationId
		getgenv().OriginalAnimations[10] = Animate.swimidle:FindFirstChildOfClass("Animation").AnimationId
	end
end


local function GetOriginalAnimation(animationIndex)
    return getgenv().OriginalAnimations[animationIndex]
end

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


local TotalEmotes = 0
local TotalAnimations = 0


getgenv().Settings = {
	Favorite = {},
	Custom = {Name=nil,Idle=nil, Idle2=nil, Idle3=nil, Walk=nil, Run=nil, Jump=nil, Climb=nil, Fall=nil, Swim=nil, SwimIdle=nil, Wave=9527883498, Laugh=507770818,Cheer=507770677,Point=507770453,Sit=2506281703,Dance=507771019,Dance2=507776043,Dance3=507777268, Weight=9, Weight2=1},
	Chat = false,
	Day = false,
	Player = nil,
	EmoteChat = false,
	Animate = false,
	RandomAnim = false,
	Refresh = false,
	DeathPosition = nil,
	Noclip = false,
	RapePlayer = false,
	TwerkAss = false,
	TwerkAss2 = false,
	Annoy = false,
	PlayAlways = false,
	Platform = false,
	FlySpeed = 50,
	InfJump = false,
	AntiKill = false,
	ClickTeleport = false,
	ClickToSelect = false,
	AnimationSpeedToggle = false,
	EmotePrefix = "/em",
	AnimationPrefix = "/a",
	EmoteSpeed = 1,
	AnimationSpeed = 1,
	ReverseSpeed = -1,
	SelectedAnimation = "",
	LastEmote = "",
	Looped = false,
	Reversed = false,
	Time = false,
	TimePosition = 1,
    Orbit = false,
    OrbitRadius = 5,
    OrbitSpeed = 5,
    ESP = false,
    ESP2 = false,
    ESP_Names = true,
    ESP_Health = true,
    ESPHue = 0,
    Xray = false,
    Crosshair = false,
    CrosshairHue = 0,
    CrosshairSize = 10,
    Spin = false,
    SpinSpeed = 10,
    AntiFling = false,
    WalkFling = false,
    AutoFarm = false,
    ChatSpam = false,
    SpamMessage = "MOPSI",
    SpamDelay = 1000,
    FrogJump = false,
    FrogPower = 60,
    WalkSpeed = 16,
    JumpPower = 50,
    WhiteList = {}
}

if isfile and not isfile("MOPSI-Hub/Animations_Settings.txt") and writefile then
    writefile('MOPSI-Hub/Animations_Settings.txt', game:GetService('HttpService'):JSONEncode(getgenv().Settings))
end

function UpdateFile()
	if writefile then
       writefile('MOPSI-Hub/Animations_Settings.txt', game:GetService('HttpService'):JSONEncode(getgenv().Settings))
	end
end

if readfile and isfile("MOPSI-Hub/Animations_Settings.txt") then
    getgenv().Settings = game:GetService('HttpService'):JSONDecode(readfile('MOPSI-Hub/Animations_Settings.txt'))
	if Settings.EmotePrefix and Settings.EmotePrefix == "/e" then
		Settings.EmotePrefix = "/em"
		UpdateFile()
	end
	if Settings.FrogJump == nil then Settings.FrogJump = false end
	if Settings.FrogPower == nil then Settings.FrogPower = 60 end
	if Settings.WalkSpeed == nil then Settings.WalkSpeed = 16 end
	if Settings.JumpPower == nil then Settings.JumpPower = 50 end
	if Settings.WhiteList == nil then Settings.WhiteList = {} end
end

local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request
local httpservice = game:GetService('HttpService')


local function ServerHop()
    local servers = {}
    local req = httprequest({Url = "https://games.roblox.com/v1/games/"..tostring(game.PlaceId).."/servers/Public?sortOrder=Desc&limit=100"})
    local body = httpservice:JSONDecode(req.Body)
    if body and body.data then
        for i, v in next, body.data do
            if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers then
            table.insert(servers, 1, v.id)
            end
        end
    end
    if #servers > 0 then
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
    end
    game:GetService("TeleportService").TeleportInitFailed:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
    end)
end



function getPlayersByName(Name)
	local Name,Len,Found = string.lower(Name),#Name,{}
	for _,v in pairs(game:GetService('Players'):GetPlayers()) do
        if v.Name ~= game:GetService('Players').LocalPlayer then
            if Name:sub(0,1) == '@' then
                if string.sub(string.lower(v.Name),1,Len-1) == Name:sub(2) then
                    return v
                end
            else
                if string.sub(string.lower(v.Name),1,Len) == Name or string.sub(string.lower(v.DisplayName),1,Len) == Name then
                return v
            end
        end
	end
end
end

local currentESP
local function UpdateESP(player)
    if currentESP then currentESP:Destroy() end
    if player and player.Character then
        currentESP = Instance.new("Highlight")
        currentESP.Name = "MOPSI_ESP"
        currentESP.FillColor = Color3.fromRGB(255, 255, 0)
        currentESP.FillTransparency = 0.5
        currentESP.OutlineColor = Color3.fromRGB(0, 0, 0)
        currentESP.OutlineTransparency = 0
        currentESP.Parent = player.Character
    end
end

local function CreateESP(player)
    if player == game.Players.LocalPlayer then return end
    local function setup(char)
        if not char then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 10)
        if not hrp then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "MOPSI_GlobalESP"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = char

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MOPSI_Billboard"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = char:WaitForChild("Head", 10) or hrp

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard

        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            if not char or not char.Parent or not player.Parent then
                if highlight then highlight:Destroy() end
                if billboard then billboard:Destroy() end
                conn:Disconnect()
                return
            end

            highlight.Enabled = Settings.ESP
            local color = Color3.fromHSV(Settings.ESPHue or 0, 1, 1)
            highlight.FillColor = color
            highlight.OutlineColor = Color3.new(1, 1, 1) -- Белая обводка для лучшей видимости
            billboard.Enabled = Settings.ESP and (Settings.ESP_Names or Settings.ESP_Health)

            if billboard.Enabled then
                local dist = (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude
                label.TextSize = math.clamp(25 - (dist / 15), 10, 20)
                local text = ""
                if Settings.ESP_Names then text = player.DisplayName end
                if Settings.ESP_Health then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        text = text .. (text ~= "" and " | " or "") .. math.floor(hum.Health) .. " HP"
                    end
                end
                label.Text = text
            end
        end)
    end
    player.CharacterAdded:Connect(setup)
    if player.Character then setup(player.Character) end
end

for _, p in pairs(game.Players:GetPlayers()) do CreateESP(p) end
game.Players.PlayerAdded:Connect(CreateESP)

local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "MOPSI_Crosshair"
CrosshairGui.Parent = game:GetService("CoreGui")
CrosshairGui.Enabled = Settings.Crosshair or false

local HorizontalLine = Instance.new("Frame")
HorizontalLine.Name = "HorizontalLine"
HorizontalLine.Parent = CrosshairGui
HorizontalLine.AnchorPoint = Vector2.new(0.5, 0.5)
HorizontalLine.Position = UDim2.new(0.5, 0, 0.5, 0)
HorizontalLine.Size = UDim2.new(0, (Settings.CrosshairSize or 10) * 2, 0, 2)
HorizontalLine.BackgroundColor3 = Color3.fromHSV(Settings.CrosshairHue or 0, 1, 1)
HorizontalLine.BorderSizePixel = 0

local VerticalLine = Instance.new("Frame")
VerticalLine.Name = "VerticalLine"
VerticalLine.Parent = CrosshairGui
VerticalLine.AnchorPoint = Vector2.new(0.5, 0.5)
VerticalLine.Position = UDim2.new(0.5, 0, 0.5, 0)
VerticalLine.Size = UDim2.new(0, 2, 0, (Settings.CrosshairSize or 10) * 2)
VerticalLine.BackgroundColor3 = Color3.fromHSV(Settings.CrosshairHue or 0, 1, 1)
VerticalLine.BorderSizePixel = 0

local function UpdateCrosshair()
    CrosshairGui.Enabled = Settings.Crosshair
    HorizontalLine.Size = UDim2.new(0, Settings.CrosshairSize * 2, 0, 2)
    VerticalLine.Size = UDim2.new(0, 2, 0, Settings.CrosshairSize * 2)
    local color = Color3.fromHSV(Settings.CrosshairHue, 1, 1)
    HorizontalLine.BackgroundColor3 = color
    VerticalLine.BackgroundColor3 = color
end

task.spawn(function()
    while task.wait(0.5) do
        if Settings.ESP2 then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(4, 6, 2)
                    hrp.Transparency = 0.7
                    hrp.Color = Color3.fromHSV(Settings.ESPHue or 0, 1, 1)
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

local function AdminCheck()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player:GetRankInGroup(1200769) >= 100 or player:IsA("Player") and player.UserId == 1 then
             SendError("ОПАСНОСТЬ", "Администратор на сервере: " .. player.Name)
        end
    end
end
game.Players.PlayerAdded:Connect(function(p)
    SendCheck("Игрок зашел", p.DisplayName .. " (@" .. p.Name .. ")")
    AdminCheck()
end)

local allPlayerDropdowns = {}

local function GetPlayerList()
    local players = {}
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= game:GetService("Players").LocalPlayer then
            table.insert(players, v.DisplayName .. " (@" .. v.Name .. ")")
        end
    end
    table.sort(players)
    return players
end

local function updateAllDropdowns()
    local newList = GetPlayerList()
    for _, dropdown in pairs(allPlayerDropdowns) do
        pcall(function()
            dropdown:Refresh(newList, true)
        end)
    end
end

game:GetService("Players").PlayerAdded:Connect(updateAllDropdowns)
game:GetService("Players").PlayerRemoving:Connect(updateAllDropdowns)

local function getPlayerFromSelection(s)
    local username = s:match("@([%w_]+)")
    local target = game:GetService("Players"):FindFirstChild(username)
    if target then
        UpdateESP(target)
    end
    return target
end

local function giveItem(item)
    if not item then return end
    local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        local clone = item:Clone()
        clone.Parent = backpack
    end
end

local foundItems = {}
local function getItemsList(filter)
    foundItems = {}
    local list = {}
    for _, container in pairs({game.ReplicatedStorage, workspace, game.ServerStorage, game.Players.LocalPlayer:WaitForChild("StarterGear"), game:GetService("StarterPack")}) do
        pcall(function()
            for _, v in pairs(container:GetDescendants()) do
                if (v:IsA("Tool") or v:IsA("HopperBin")) and not foundItems[v.Name] then
                    if not filter or v.Name:lower():find(filter:lower()) then
                        foundItems[v.Name] = v
                        table.insert(list, v.Name)
                    end
                end
            end
        end)
    end
    table.sort(list)
    return list
end

local function frogJump(character)
    if not Settings.FrogJump then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    local moveDirection = humanoid.MoveDirection
    local lookDirection = moveDirection.Magnitude > 0.1 and moveDirection.Unit or hrp.CFrame.LookVector

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = (lookDirection * (Settings.FrogPower or 60)) + Vector3.new(0, humanoid.JumpPower, 0)
    bodyVelocity.Parent = hrp
    Debris:AddItem(bodyVelocity, 0.15)
end

local function setupFrog(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end
    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            frogJump(character)
        end
    end)
end
setupFrog(LP.Character)

local isRecording = false
local isRunning = false
local recordedFrames = {}
local recordConnection = nil
local runConnection = nil
local recordStartTime = 0

local function startRecording()
    recordedFrames = {}
    isRecording = true
    recordStartTime = tick()

    local character = game.Players.LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if recordConnection then recordConnection:Disconnect() end
    recordConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not isRecording then return end
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            table.insert(recordedFrames, {
                cframe = root.CFrame,
                time = tick() - recordStartTime
            })
        end
    end)
end

local function stopRecording()
    isRecording = false
    if recordConnection then
        recordConnection:Disconnect()
        recordConnection = nil
    end
end

local function playRecording()
    if #recordedFrames == 0 then return end
    isRunning = true
    local startTime = tick()
    local index = 1

    if runConnection then runConnection:Disconnect() end
    runConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not isRunning then return end
        local char = game.Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local elapsed = tick() - startTime
        while index < #recordedFrames and recordedFrames[index + 1].time <= elapsed do
            index = index + 1
        end

        root.CFrame = recordedFrames[index].cframe

        if index >= #recordedFrames and elapsed >= recordedFrames[#recordedFrames].time then
            if isRunning then
                index = 1
                startTime = tick()
            else
                if runConnection then runConnection:Disconnect() end
            end
        end
    end)
end

local function stopRunning()
    isRunning = false
    if runConnection then
        runConnection:Disconnect()
        runConnection = nil
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local function SendError(message, message2)
    Rayfield:Notify({
        Title = "MOPSI-Hub - Ошибка",
        Content = message .. "\n"..message2,
        Duration = 4,
        Image = 4483345998,
    })
end


local function SendCheck(message, message2)
    Rayfield:Notify({
        Title = "MOPSI-Hub - Успех",
        Content = message .. "\n"..message2,
        Duration = 4,
        Image = 4483345998,
    })
end

local function SendCustomCheck(message, message2, time)
    Rayfield:Notify({
        Title = "MOPSI-Hub - Успех",
        Content = message .. "\n"..message2,
        Duration = time,
        Image = 4483345998,
    })
end

getgenv().FPDH = workspace.FallenPartsDestroyHeight
local function SkidFling(TargetPlayer, AllBool)
    if table.find(getgenv().Settings.WhiteList, TargetPlayer.Name) then
        if not AllBool then SendError("Отказ", "Игрок в белом списке") end
        return
    end
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit and not AllBool then
            return SendError("Ошибка", "Цель сидит")
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end

        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until not BasePart or BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end

        workspace.FallenPartsDestroyHeight = 0/0

        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            BV:Destroy()
            return SendError("Ошибка", "У цели отсутствует HumanoidRootPart и Head")
        end

        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid

        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            for _, x in pairs(Character:GetChildren()) do
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return SendError("Ошибка", "HumanoidRootPart не найден")
    end
end


task.spawn(function()
	if getgenv().Teleported then
		SendCheck("MOPSI-Hub успешно загружен","Нажмите Q, чтобы открыть меню. Мы свернули его, так как вы перешли с другого сервера.")
	 end
end)

local Emotes = {
	['Fashion'] = 3333331310;
	["Baby Dance"] = 4265725525;
	["Cha-Cha"] = 6862001787;
	['Monkey'] = 3333499508;
	['Shuffle'] = 4349242221;
	["Top Rock"] = 3361276673;
	["Around Town"] = 3303391864;
	["Fancy Feet"] = 3333432454;
	["Hype Dance"] = 3695333486;
	['Bodybuilder'] = 3333387824;
	['Idol'] = 4101966434;
	['Curtsy'] = 4555816777;
	['Happy'] = 4841405708;
	["Quiet Waves"] = 7465981288;
	['Sleep'] = 4686925579;
	["Floss Dance"] = 5917459365;
	['Shy'] = 3337978742;
	['Godlike'] = 3337994105;
	["Hero Landing"] = 5104344710;
	["High Wave"] = 5915690960;
	['Cower'] = 4940563117;
	['Bored'] = 5230599789;
	["Show Dem Wrists -KSI"] = 7198989668;
	['Celebrate'] = 3338097973;
	['Dash'] = 582855105;
	['Beckon'] = 5230598276;
	['Haha'] = 3337966527;
	["Lasso Turn - Tai Verdes"] = 7942896991;
	["Line Dance"] = 4049037604;
	['Shrug'] = 3334392772;
	['Point2'] = 3344585679;
	['Stadium'] = 3338055167;
	['Confused'] = 4940561610;
	['Side to Side'] = 3333136415;
	['Old Town Road Dance - Lil Nas X"'] = 5937560570;
	['Hello'] = 3344650532;
	['Dolphin Dance'] = 5918726674;
	['Samba'] = 6869766175;
	['Break Dance'] = 5915648917;
	["Hips Poppin' - Zara Larsson"] = 6797888062;
	['Wake Up Call - KSI'] = 7199000883;
	['Greatest'] = 3338042785;
	['On The Outside - Twenty One'] = 7422779536;
	['Boxing Punch - KSI'] = 7202863182;
	['Sad'] = 4841407203;
	['Flowing Breeze'] = 7465946930;
	['Twirl'] = 3334968680;
	['Jumping Wave'] = 4940564896;
	['HOLIDAY Dance - Lil Nas X (LNX)'] = 5937558680;
	['Take Me Under - Zara Larsson'] = 6797890377;
	['Shuffle'] = 4349242221;
	['Dizzy'] = 3361426436;
	["Dancing' Shoes - Twenty One"] = 7404878500;
	['Fashionable'] = 3333331310;
	['Fast Hands'] = 4265701731;
	['Tree'] = 4049551434;
	['Agree'] = 4841397952;
	['Power Blast'] = 4841403964;
	['Swoosh'] = 3361481910;
	['Jumping Cheer'] = 5895324424;
	['Disagree'] = 4841401869;
	['Rodeo Dance - Lil Nas X (LNX)'] = 5918728267;
	["It Ain't My Fault - Zara Larsson"] = 6797891807;
	['Rock On'] = 5915714366;
	['Block Partier'] = 6862022283;
	['Dorky Dance'] = 4212455378;
	['Zombie'] = 4210116953;
	['AOK - Tai Verdes'] = 7942885103;
	['T'] = 3338010159;
	['Cobra Arms - Tai   Verdes'] = 7942890105;
	['Panini Dance - Lil Nas X (LNX)'] = 5915713518;
	['Fishing'] = 3334832150;
	['Robot'] = 3338025566;
	['Around Town'] = 3303391864;
	['Saturday Dance - Twenty One'] = 7422807549;
	['Top Rock'] = 3361276673;
	['Keeping Time'] = 4555808220;
	['Air Dance'] = 4555782893;
	['Fancy Feet'] = 3333432454;
	['Rock Guitar - Royal Blood'] = 6532134724;
	["Borock's Rage"] = 3236842542;
	["Ud'zal's Summoning"] = 3303161675;
	['Y'] = 4349285876;
	['Swan Dance'] = 7465997989;
	['Louder'] = 3338083565;
	['Up and Down - Twenty One'] = 7422797678;
	['Swish'] = 3361481910;
	['Drummer Moves - Twenty One'] = 7422527690;
	['Sneaky'] = 3334424322;
	['Heisman Pose'] = 3695263073;
	['Jacks'] = 3338066331;
	['Cha-Cha 2'] = 3695322025;
	['BURBERRY LOLA ATTITUDE - NIMBUS'] = 10147821284;
	['BURBERRY LOLA  ATTITUDE - GEM'] = 10147815602;
	['BURBERRY LOLA ATTITUDE - HYDRO'] = 10147823318;
	['BURBERRY LOLA ATTITUDE - BLOOM'] = 10147817997;
	['Superhero Reveal'] = 3695373233;
	['Air Guitar'] = 3695300085;
	['Dismissive Wave'] = 3333272779;
	['Country Line  Dance - Lil Nas X'] = 5915712534;
	['Salute'] = 3333474484;
	['Applaud'] = 5915693819;
	['Get Out'] = 3333272779;
	['Hwaiting (화이팅)'] = 9527885267;
	['Annyeong (안녕)'] = 9527883498;
	['Bunny Hop'] = 4641985101;
	['Sandwich Dance'] = 4406555273;
	['Hyperfast  5G Dance Move'] = 9408617181;
	['Victory - 24kGoldn'] = 9178377686;
	['Tantrum'] = 5104341999;
	['Rock Star - Royal Blood'] = 10714400171;
	['Drum Solo - Royal Blood'] = 6532839007;
	['Drum Master - Royal Blood'] = 6531483720;
	['High Hands'] = 9710985298;
	['Tilt'] = 3334538554;
	['Gashina - SUNMI'] = 9527886709;
	['Chicken Dance'] = 4841399916;
	["You can't sit with us - Sunmi"] = 9983520970;
	["Frosty Flair - Tommy Hilfiger"] = 10214311282;
	["Floor Rock Freeze - Tommy Hilfiger"] = 10214314957;
	['Boom Boom Clap - George Ezra'] = 10370346995;
	['Cartwheel - George Ezra'] = 10370351535;
	['Chill Vibes - George Ezra'] = 10370353969;
	['Sidekicks - George Ezra'] = 10370362157;
	['The Conductor - George Ezra'] = 10370359115;
	['Super Charge'] = 10478338114;
	['Swag Walk'] = 10478341260;
	['Mean Mug - Tommy Hilfiger'] = 10214317325;
	['V Pose - Tommy Hilfiger'] = 10214319518;
	['Uprise - Tommy Hilfiger'] = 10275008655;
	['2 Baddies Dance Move - NCT 127'] = 12259828678;
	['Kick It Dance Move - NCT 127'] = 12259826609;
	['Sticker Dance Move - NCT 127'] = 12259825026;
	['Elton John - Rock Out'] = 11753474067;
	['Elton John - Heart Skip'] = 11309255148;
	['Elton John - Still Standing'] = 11444443576;
	['Elton John - Elevate'] = 11394033602;
	['Elton John - Cat Man'] = 11444441914;
	['Elton John - Piano Jump'] = 11453082181;
	['Alo Yoga Pose - Triangle'] = 12507084541;
	['Alo Yoga Pose - Warrior II'] = 12507083048;
	['Alo Yoga Pose - Lotus Position'] = 12507085924;
	['Alo Yoga Pose - Warrior II'] = 12507083048;
	['Alo Yoga Pose - Triangle'] = 12507084541;
	['TWICE-Moonlight-Sunrise'] = 12714233242;
	['TWICE-Set-Me-Free-Dance-1'] = 12714228341;
	['TWICE-Set-Me-Free-Dance-2'] = 12714231087;
	['Ay-Yo-Dance-Move-NCT-127'] = 12804157977;
	['TWICE-The-Feels'] = 12874447851;
	['Zombie'] = 10714089137;
	['Rise-Above-The-Chainsmokers'] = 12992262118;
	['TWICE-What-Is-Love'] = 13327655243;
	['Man-City-Bicycle-Kick'] = 13421057998;
	['TWICE-Fancy'] = 13520524517;
	['TWICE Pop by Nayeon'] = 13768941455;
	['Tommy - Archer'] = 13823324057;
	['TWICE-Pop-by-Nayeon'] = 13768941455;
	['Man City Backflip'] = 13694100677;
	['Man-City-Scorpion-Kick'] = 13694096724;
	['Arm Twist'] = 10713968716;
	['Tommy - Archer'] = 13823324057;
	['YUNGBLUD – HIGH KICK'] = 14022936101;
	['TWICE Like Ooh-Ahh'] = 14123781004;
	['Baby Queen - Air Guitar & Knee Slide'] = 14352335202;
	['Baby Queen - Dramatic Bow'] = 14352337694;
	['Baby Queen - Face Frame'] = 14352340648;
	['Baby Queen - Bouncy Twirl'] = 14352343065;
	['Baby Queen - Strut'] = 14352362059;
	['BLACKPINK Pink Venom - Get em Get em Get em'] = 14548619594;
	['BLACKPINK Pink Venom - I Bring the Pain Like…'] = 14548620495;
	['BLACKPINK Pink Venom - Straight to Ya Dome'] = 14548621256;
	['TWICE LIKEY'] = 14899979575;
	['TWICE Feel Special'] = 14899980745;
	['BLACKPINK Shut Down - Part 1'] = 14901306096;
	['BLACKPINK Shut Down - Part 2'] = 14901308987;
	["Bone Chillin' Bop"] = 15122972413;
	['Paris Hilton - Sliving For The Groove'] = 15392759696;
	['Paris Hilton - Iconic IT-Grrrl'] = 15392756794;
	['Paris Hilton - Checking My Angles'] = 15392752812;
	['BLACKPINK JISOO Flower'] = 15439354020;
	['BLACKPINK JENNIE You and Me'] = 15439356296;
	['Rock n Roll'] = 15505458452;
	['Air Guitar'] = 15505454268;
	['Victory Dance'] = 15505456446;
	['Flex Walk'] = 15505459811;
	['Olivia Rodrigo Head Bop'] = 15517864808;
	['Olivia Rodrigo good 4 u'] = 15517862739;
	['Olivia Rodrigo Fall Back to Float'] = 15549124879;
	["Nicki Minaj That's That Super Bass"] = 15571446961;
	['Nicki Minaj Boom Boom Boom'] = 15571448688;
	['Nicki Minaj Anaconda'] = 15571450952;
	['Nicki Minaj Starships'] = 15571453761;
	['Yungblud Happier Jump'] = 15609995579;
	['Festive Dance'] = 15679621440;
	['BLACKPINK LISA Money'] = 15679623052;
	['BLACKPINK ROSÉ On The Ground'] = 15679624464;
	['Imagine Dragons - “Bones” Dance'] = 15689279687;
	['GloRilla - "Tomorrow" Dance'] = 15689278184;
	['d4vd - Backflip'] = 15693621070;
	['ericdoa - dance'] = 15698402762;
	['Cuco - Levitate'] = 15698404340;
	['Mean Girls Dance Break'] = 15963314052;
	['Paris Hilton Sanasa'] = 16126469463;
	['BLACKPINK Ice Cream'] = 16181797368;
	['BLACKPINK Kill This Love'] = 16181798319;
	['TWICE I GOT YOU part 1'] = 16215030041;
	['TWICE I GOT YOU part 2'] = 16256203246;
	["Dave's Spin Move - Glass Animals"] = 16272432203;
	['Sol de Janeiro - Samba'] = 16270690701;
	['Beauty Touchdown'] = 16302968986;
	['Skadoosh Emote - Kung Fu Panda 4'] = 16371217304;
	['Jawny - Stomp'] = 16392075853;
	['Mae Stephens - Piano Hands'] = 16553163212;
	['BLACKPINK Boombayah Emote'] = 16553164850;
	['BLACKPINK DDU-DU DDU-DU'] = 16553170471;
	['HIPMOTION - Amaarae'] = 16572740012;
	['Mae Stephens – Arm Wave'] = 16584481352;
	['Wanna play?'] = 16646423316;
	['BLACKPINK-How-You-Like-That'] = 16874470507;
	['BLACKPINK - Lovesick Girls'] = 16874472321;
	['Mini Kong'] = 17000021306;
	["HUGO Let's Drive!"] = 17360699557;
	['Wisp - air guitar'] = 17370775305;
	['Vans Ollie'] = 18305395285;
	['Sturdy Dance - Ice Spice'] = 17746180844;
	['Shuffle'] = 17748314784;
	['Rolling Stones Guitar Strum'] = 18148804340;
	['Rock Out - Bebe Rexha'] = 18225053113;
	['SpongeBob Imaginaaation 🌈'] = 18443237526;
	['SpongeBob Dance'] = 18443245017;
	['Shrek Roar'] = 18524313628;
	['Team USA Breaking Emote'] = 18526288497;
	['NBA WNBA Fadeaway'] = 18526362841;
	['Vroom Vroom'] = 18526397037;
	['TMNT Dance'] = 18665811005;
	['Olympic Dismount'] = 18665825805;
    ["BLACKPINK As If It's Your Last"] = 18855536648;
    ["BLACKPINK Don't know what to do"] = 18855531354;
    ['TWICE ABCD by Nayeon'] = 18933706381;
    ['Charli xcx - Apple Dance'] = 18946844622;
	['The Zabb'] = 129470135909814;
	['Fashion Klossette - Runway my way'] = 80995190624232;
	['ALTÉGO - Couldn’t Care Less'] = 107875941017127;
	['Fashion Roadkill'] = 136831243854748;
	['Skibidi Toilet - Titan Speakerman Laser Spin'] = 134283166482394;
	['Chappell Roan HOT TO GO!'] = 85267023718407;
	['Secret Handshake Dance'] = 71243990877913;
	['KATSEYE - Touch'] = 135876612109535;
	['Fashion Spin'] = 131669256082047;
	['TWICE Strategy'] = 97311229290836;
	['NBA Monster Dunk'] = 132748833449150;
	['DearALICE - Ariana'] = 134318425949290;
	['The Weeknd Starboy Strut'] = 71105746210464;
	['The Weeknd Opening Night'] = 133110725387025;
	['Robot M3GAN'] = 125803725853577;
	["M3GAN's Dance"] = 99649534578309;
	['Rasputin – Boney M.'] = 114872820353992;
	['Thanos Happy Jump - Squid Game'] = 97611664803614;
	['Young-hee Head Spin - Squid Game'] = 112011282168475;
	['TWICE Takedown'] = 140182843839424;
	['Stray Kids Walkin On Water'] = 125064469983655;
	['TWICE TAKEDOWN DANCE 2'] = 127104635954695;
}


local Animations = {
 Emotes = {Weight=9, Weight2=1},
 Stylish = {Idle = 616136790, Idle2=616138447, Idle3=886888594, Walk=616146177,Run=616140816,Jump=616139451,Climb=616133594,Fall=616134815, Swim=616143378, SwimIdle=616144772, Weight=9, Weight2=1},
 Zombie = {Idle = 616158929, Idle2=616160636, Idle3=885545458, Walk=616168032,Run=616163682,Jump=616161997,Climb=616156119,Fall=616157476, Swim=616165109, SwimIdle=616166655, Weight=9, Weight2=1},
 Robot = {Idle = 616088211, Idle2=616089559, Idle3=885531463, Walk=616095330,Run=616091570,Jump=616090535,Climb=616086039,Fall=616087089, Swim=616092998, SwimIdle=616094091, Weight=9, Weight2=1},
 Toy = {Idle = 782841498, Idle2=782845736, Idle3=980952228, Walk=782843345,Run=782842708,Jump=782847020,Climb=782843869,Fall=782846423, Swim=782844582, SwimIdle=782845186, Weight=9, Weight2=1},
 Cartoony = {Idle = 742637544, Idle2=742638445, Idle3=885477856, Walk=742640026,Run=742638842,Jump=742637942,Climb=742636889,Fall=742637151, Swim=742639220, SwimIdle=742639812, Weight=9, Weight2=1},
 Superhero = {Idle = 616111295, Idle2=616113536, Idle3=885535855, Walk=616122287,Run=616117076,Jump=616115533,Climb=616104706,Fall=616108001, Swim=616119360, SwimIdle=616120861, Weight=9, Weight2=1},
 Mage = {Idle = 707742142, Idle2=707855907, Idle3=885508740, Walk=707897309,Run=707861613,Jump=707853694,Climb=707826056,Fall=707829716, Swim=707876443, SwimIdle=707894699, Weight=9, Weight2=1},
 Levitation = {Idle = 616006778, Idle2=616008087, Idle3=886862142, Walk=616013216,Run=616010382,Jump=616008936,Climb=616003713,Fall=616005863, Swim=616011509, SwimIdle=616012453, Weight=9, Weight2=1},
 Vampire = {Idle = 1083445855, Idle2=1083450166, Idle3=1088037547, Walk=1083473930,Run=1083462077,Jump=1083455352,Climb=1083439238,Fall=1083443587, Swim=1083464683, SwimIdle=1083467779, Weight=9, Weight2=1},
 Elder = {Idle = 845397899, Idle2=845400520, Idle3=901160519, Walk=845403856,Run=845386501,Jump=845398858,Climb=845392038,Fall=845396048, Swim=845401742, SwimIdle=845403127, Weight=9, Weight2=1},
 Werewolf = {Idle = 1083195517, Idle2=1083214717, Idle3=1099492820, Walk=1083178339,Run=1083216690,Jump=1083218792,Climb=1083182000,Fall=1083189019, Swim=1083222527, SwimIdle=1083225406, Weight=9, Weight2=1},
 Knight = {Idle = 657595757, Idle2=657568135, Idle3=885499184, Walk=657552124,Run=657564596,Jump=658409194,Climb=658360781,Fall=657600338, Swim=657560551, SwimIdle=657557095, Weight=9, Weight2=1},
 Bold = {Idle = 16738333868, Idle2=16738334710, Idle3=16738335517, Walk=16738340646,Run=16738337225,Jump=16738336650,Climb=16738332169,Fall=16738333171, Swim=16738339158, SwimIdle=16738339817, Weight=9, Weight2=1},
 Astronaut = {Idle = 891621366, Idle2=891633237, Idle3=1047759695, Walk=891667138,Run=891636393,Jump=891627522,Climb=891609353,Fall=891617961, Swim=891639666, SwimIdle=891663592, Weight=9, Weight2=1},
 Bubbly = {Idle = 910004836, Idle2=910009958, Idle3=1018536639, Walk=910034870,Run=910025107,Jump=910016857,Climb=909997997,Fall=910001910, Swim=910028158, SwimIdle=910030921, Weight=9, Weight2=1},
 Pirate = {Idle = 750781874, Idle2=750782770, Idle3=885515365, Walk=750785693,Run=750783738,Jump=750782230,Climb=750779899,Fall=750780242, Swim=750784579, SwimIdle=750785176, Weight=9, Weight2=1},
 Rthro = {Idle = 2510196951, Idle2=2510197257, Idle3=3711062489, Walk=2510202577,Run=2510198475,Jump=2510197830,Climb=2510192778,Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 Ninja = {Idle=656117400, Idle2=656118341, Idle3=886742569, Walk=656121766, Run=656118852, Jump=656117878, Climb=656114359,Fall=656115606, Swim=656119721, SwimIdle=656121397, Weight=9, Weight2=1},
 Oldschool = {Idle=5319828216, Idle2=5319831086, Idle3=5392107832, Walk=5319847204, Run=5319844329, Jump=5319841935, Climb=5319816685, Fall=5319839762, Swim=5319850266, SwimIdle=5319852613, Weight=9, Weight2=1},
 Realistic = {Idle=17172918855, Idle2=17173014241, Idle3=17173014241, Walk=11600249883, Run=11600211410, Jump=11600210487, Climb=11600205519, Fall=11600206437, Swim=11600212676, SwimIdle=11600213505, Weight=9, Weight2=1},
 ['No Boundaries'] = {Idle=18747067405, Idle2=18747063918, Idle3=18747063918, Walk=18747074203, Run=18747070484, Jump=18747069148, Climb=18747060903,Fall=18747062535, Swim=18747073181, SwimIdle=18747071682, Weight=9, Weight2=1},
 ['NFL Animation'] = {Idle=92080889861410, Idle2=74451233229259, Idle3=80884010501210, Walk=110358958299415, Run=117333533048078, Jump=119846112151352, Climb=134630013742019,Fall=129773241321032, Swim=132697394189921, SwimIdle=79090109939093, Weight=9, Weight2=1},
 ['Adidas Aura'] = {Idle=110211186840347,Idle2=114191137265065,Idle3=99129837931148,Walk=83842218823011,Run=118320322718866,Jump=109996626521204,Climb=97824616490448,Fall=95603166884636,Swim=134530128383903,SwimIdle=94922130551805,Weight=9,Weight2=1},
 ['Adidas Sports'] = {Idle=18537376492, Idle2=18537371272, Idle3=18537374150, Walk=18537392113, Run=18537384940, Jump=18537380791, Climb=18537363391,Fall=18537367238, Swim=18537389531, SwimIdle=18537387180, Weight=9, Weight2=1},
 ['Adidas Community '] = {Idle=122257458498464, Idle2=102357151005774, Idle3=89262795687364, Walk=122150855457006, Run=82598234841035, Jump=75290611992385, Climb=88763136693023,Fall=98600215928904, Swim=133308483266208, SwimIdle=109346520324160, Weight=9, Weight2=1},
 ['Wickled Popular'] = {Idle=118832222982049, Idle2=76049494037641, Idle3=138255200176080, Walk=92072849924640, Run=72301599441680, Jump=104325245285198, Climb=131326830509784, Fall=121152442762481, Swim=99384245425157, SwimIdle=113199415118199, Weight=9, Weight2=1},
 ['Catwalk Glam'] = {Idle=133806214992291, Idle2=94970088341563, Idle3=87105332133518, Walk=109168724482748, Run=81024476153754, Jump=116936326516985, Climb=119377220967554,Fall=92294537340807, Swim=134591743181628, SwimIdle=98854111361360, Weight=9, Weight2=1},
 Princess = {Idle=941003647, Idle2=941013098, Idle3=1159195712, Walk=941028902, Run=941015281, Jump=0941008832, Climb=940996062, Fall=941000007, Swim=941018893, SwimIdle=941025398, Weight=9, Weight2=1},
 Confident = {Idle=1069977950, Idle2=1069987858, Idle3=1116160740, Walk=1070017263, Run=1070001516, Jump=1069984524, Climb=1069946257, Fall=1069973677, Swim=1070009914, SwimIdle=1070012133, Weight=9, Weight2=1},
 Popstar = {Idle=1212900985, Idle2=1150842221, Idle3=1239733474, Walk=1212980338, Run=1212980348, Jump=1212954642, Climb=1213044953, Fall=1212900995, Swim=1212852603, SwimIdle=1070012133, Weight=9, Weight2=1},
 Patrol = {Idle=1149612882, Idle2=1150842221, Idle3=1159573567, Walk=1151231493, Run=1150967949, Jump=1150944216, Climb=1148811837, Fall=1148863382, Swim=1151204998, SwimIdle=1151221899, Weight=9, Weight2=1},
 Sneaky = {Idle=1132473842, Idle2=1132477671, Idle3="None", Walk=1132510133, Run=1132494274, Jump=1132489853, Climb=1132461372, Fall=1132469004, Swim=1132500520, SwimIdle=1132506407, Weight=9, Weight2=1},
 Cowboy = {Idle=1014390418, Idle2=1014398616, Idle3=1159487651, Walk=1014421541, Run=1014401683, Jump=1014394726, Climb=1014380606, Fall=1014384571, Swim=1014406523, SwimIdle=1014411816, Weight=9, Weight2=1},
 Ghost = {Idle=616006778, Idle2=616008087, Idle3=616008087, Walk=616013216, Run=616013216, Jump=616008936, Climb=0, Fall=616005863, Swim=616011509, SwimIdle=616012453, Weight=9, Weight2=1},
 ['Ghost 2'] = {Idle=1151221899, Idle2=1151221899, Idle3="None", Walk=1151221899, Run=1151221899, Jump=1151221899, Climb=0, Fall=1151221899, Swim=16738339158, SwimIdle=1151221899, Weight=9, Weight2=1},
 ['Mr. Toilet'] = {Idle=4417977954, Idle2=4417978624, Idle3=4441285342, Walk=2510202577, Run=4417979645, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 Udzal = {Idle=3303162274, Idle2=3303162549, Idle3=3710161342, Walk=3303162967, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 ['Oinan Thickhoof'] = {Idle = 657595757, Idle2=657568135, Idle3=885499184, Walk=2510202577, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 Borock = {Idle = 3293641938, Idle2=3293642554, Idle3=3710131919, Walk=2510202577, Run=3236836670, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 ['Blocky Mech'] = {Idle=4417977954, Idle2=4417978624, Idle3=4441285342, Walk=2510202577, Run=4417979645, Jump=2510197830, Climb=2510192778, Fall=2510195892, Swim=2510199791, SwimIdle=2510201162, Weight=9, Weight2=1},
 ['Stylized Female'] = {Idle=4708191566, Idle2=4708192150, Idle3=121221, Walk=4708193840, Run=4708192705, Jump=4708188025, Climb=4708184253, Fall=4708186162, Swim=4708189360, SwimIdle=4708190607, Weight=9, Weight2=1},
 R15 = {Idle=4211217646, Idle2=4211218409, Idle3="None", Walk=4211223236, Run=4211220381, Jump=4211219390, Climb=4211214992, Fall=4211216152, Swim=4211221314, SwimIdle=4374694239, Weight=9, Weight2=1},
 Mocap = {Idle=913367814, Idle2=913373430, Idle3="None", Walk=913402848, Run=913376220, Jump=913370268, Climb=913362637, Fall=913365531, Swim=913384386, SwimIdle=913389285, Weight=9, Weight2=1},
 ['Wicked "Dancing Through Life"'] = {Idle=92849173543269,Idle2=132238900951109,Idle3=87867222929430,Walk=73718308412641,Run=135515454877967,Jump=78508480717326,Climb=129447497744818,Fall=78147885297412,Swim=110657013921774,SwimIdle=129183123083281,Weight=9,Weight2=1},
 Unboxed = {Idle=98281136301627,Idle2=138183121662404,Idle3=133117300343405,Walk=90478085024465,Run=134824450619865,Jump=121454505477205,Climb=121145883950231,Fall=94788218468396,Swim=105962919001086,SwimIdle=129126268464847,Weight=9,Weight2=1}
}



local AnimationList = {}

for i,v in pairs(Animations) do
	if i ~= "Weight" and i~= "Weight2" and i ~= "Custom" and i ~= "Emotes" then
		table.insert(AnimationList, i)
		TotalAnimations = TotalAnimations + 1
	end
end

local EmoteList = {}
for i,v in pairs(Emotes) do
	table.insert(EmoteList, i)
	TotalEmotes = TotalEmotes + 1
end

task.spawn(function()
	SendCustomCheck("MOPSI-Hub", "Загружено " .. TotalAnimations .. " анимаций и " .. TotalEmotes .. " эмоций!", 9)
end)

table.sort(AnimationList, function(a,b)
	return a:lower() < b:lower()
end)


local function StopEmotes()
	do
		if not getgenv().AlreadyLoaded then return end
		repeat wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate") and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game:GetService("Players").LocalPlayer.Character.Humanoid:FindFirstChild("Animator")
	    local Animator = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChildOfClass("Animator")
		for i,v in ipairs(Animator:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	end
end

local function RefreshAnims()
	if not getgenv().AlreadyLoaded then return end
	repeat task.wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate") and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):FindFirstChild("Animator")
	game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate").Disabled = true
	for _,v in ipairs(game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPlayingAnimationTracks()) do
		v:Stop()
	end
	game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate").Disabled = false
	local h = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local s = h.WalkSpeed
	h.WalkSpeed = 0
	task.wait()
	h.WalkSpeed = s
	for _,v in ipairs(h:GetPlayingAnimationTracks()) do
		v:AdjustSpeed(Settings.AnimationSpeed)
	end
end

local function PlayAnimationBody(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, weight, weight2)
	do
		repeat wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate")
		local Animate = game:GetService("Players").LocalPlayer.Character.Animate
		if Animate:FindFirstChild("idle") then
			Animate.idle.Animation1.AnimationId = URL..id1
			Animate.idle.Animation1.Weight.Value = tostring(weight)
			Animate.idle.Animation2.Weight.Value = tostring(weight2)
			Animate.idle.Animation2.AnimationId = URL..id2
		end
		if id3 and Animate:FindFirstChild("pose") then
		   Animate.pose:FindFirstChildOfClass("Animation").AnimationId = URL..id3
		end
		Animate.walk:FindFirstChildOfClass("Animation").AnimationId = URL..id4
		Animate.run:FindFirstChildOfClass("Animation").AnimationId = URL..id5
		Animate.jump:FindFirstChildOfClass("Animation").AnimationId = URL..id6
		Animate.climb:FindFirstChildOfClass("Animation").AnimationId = URL..id7
		Animate.fall:FindFirstChildOfClass("Animation").AnimationId = URL..id8
		if Animate:FindFirstChild("swim") then
			Animate.swim:FindFirstChildOfClass("Animation").AnimationId = URL..id9
			Animate.swimidle:FindFirstChildOfClass("Animation").AnimationId = URL..id10
		end
	end
end




local function PlayCustomAnim(name, id)
   repeat wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate")
   local Animate = game:GetService("Players").LocalPlayer.Character.Animate
   if name:match("idle") then
	  if Animate:FindFirstChild("pose") then
		 Animate.pose:FindFirstChildOfClass("Animation").AnimationId = URL..id
	  end
   end
   if name == "idle1" then
	   Animate.idle.Animation1.AnimationId = URL..id
   elseif name == "idle2" then
	   Animate.idle.Animation2.AnimationId = URL..id
   elseif name:match("dance") then
   		for _,v in pairs(Animate[name]:GetChildren()) do
		    if v:IsA("Animation") then
				v.AnimationId = URL..id
			end
		end
   else
	   local anim
	   for _,v in pairs(Animate:GetChildren()) do
		   if v.Name == name then
			  anim = v
			  break
		   end
		end
		if anim then
			anim:FindFirstChildOfClass("Animation").AnimationId = URL..id
		end
   end
   RefreshAnims()
end


local function PlayAnimation(id)
   local Animation = Instance.new("Animation")
   Animation.AnimationId = "rbxassetid://"..id
   _G.LoadAnim = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Animation)
   _G.LoadAnim.Priority = Enum.AnimationPriority.Idle
   if not Settings.PlayAlways then
	  _G.LoadAnim:Stop()
   end
   if Settings.Reversed then
	   _G.LoadAnim:Play(0)
	   _G.LoadAnim:AdjustSpeed(Settings.ReverseSpeed)
   else
	   _G.LoadAnim:Play(0)
	   _G.LoadAnim:AdjustSpeed(Settings.EmoteSpeed)
   end
   if Settings.Looped then
	   _G.LoadAnim.Looped = Settings.Looped
   end
   if Settings.Time then
	   _G.LoadAnim.TimePosition = _G.LoadAnim.TimePosition - Settings.TimePosition
   end
   if not game:GetService("Players").LocalPlayer.Character.Animate.Disabled then
	   game:GetService("Players").LocalPlayer.Character.Animate.Disabled = true
   end
end



local function CheckType()
   local Humanoid = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R15 then
	   return "R15"
	else
		return "R6"
	end
end

local function PlayEmote(Emote)
	PlayAnimation(Emotes[Emote])
end


local function GetAnimation(emote)
	for i,v in pairs(Animations) do
		lower_string = string.lower(i)
		lower_emote = string.lower(emote)
		if string.find(i, emote) or string.find(lower_string, lower_emote) then
		    return i
		end
	end
end

local function GetEmote(emote)
	for i,v in pairs(Emotes) do
		upper_string = string.upper(i)
		upper_emote = string.upper(emote)
		if upper_string == upper_emote then
		return i
		end
	end
	for i,v in pairs(Emotes) do
		lower_string = string.lower(i)
		lower_emote = string.lower(emote)
		if string.find(i, emote) or string.find(lower_string, lower_emote) then
			return i
		end
	end
end

local function getRandomEmote()
    local randomKey
    local count = 0

    for _ in pairs(Emotes) do
        count = count + 1
    end

    local randomIndex = math.random(1, count)

    count = 0
    for key, _ in pairs(Emotes) do
        count = count + 1
        if count == randomIndex then
            randomKey = key
            break
        end
    end

    return randomKey, Emotes[randomKey]
end

if Settings.SelectedAnimation and Settings.SelectedAnimation ~= "" then
	repeat wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate")
    if Settings.SelectedAnimation == "Custom" and CheckType() == "R15" then
		StopEmotes()
		PlayAnimationBody(Settings.Custom.Idle or GetOriginalAnimation(1),
		Settings.Custom.Idle2 or GetOriginalAnimation(2),
		Settings.Custom.Idle3 or GetOriginalAnimation(3),
		Settings.Custom.Walk or GetOriginalAnimation(4),
		Settings.Custom.Run or GetOriginalAnimation(5),
		Settings.Custom.Jump or GetOriginalAnimation(6),
		Settings.Custom.Climb or GetOriginalAnimation(7),
		Settings.Custom.Fall or GetOriginalAnimation(8),
		Settings.Custom.Swim or GetOriginalAnimation(9),
		Settings.Custom.SwimIdle or GetOriginalAnimation(10),
		Settings.Custom.Weight,
		Settings.Custom.Weight2)
		if Settings.Custom.Wave then
			PlayCustomAnim("wave", Settings.Custom.Wave)
		end
		if Settings.Custom.Laugh then
			PlayCustomAnim("laugh", Settings.Custom.Laugh)
		end
		if Settings.Custom.Cheer then
			PlayCustomAnim("cheer", Settings.Custom.Cheer)
		end
		if Settings.Custom.Point then
			PlayCustomAnim("point", Settings.Custom.Point)
		end
		if Settings.Custom.Sit then
			PlayCustomAnim("sit", Settings.Custom.Sit)
		end
		if Settings.Custom.Dance then
			PlayCustomAnim("dance", Settings.Custom.Dance)
		end
		if Settings.Custom.Dance2 then
			PlayCustomAnim("dance2", Settings.Custom.Dance2)
		end
		if Settings.Custom.Dance3 then
			PlayCustomAnim("dance3", Settings.Custom.Dance3)
		end
	elseif CheckType() == "R15" then
		StopEmotes()
        PlayAnimationBody(Animations[Settings.SelectedAnimation].Idle, Animations[Settings.SelectedAnimation].Idle2, Animations[Settings.SelectedAnimation].Idle3, Animations[Settings.SelectedAnimation].Walk, Animations[Settings.SelectedAnimation].Run, Animations[Settings.SelectedAnimation].Jump, Animations[Settings.SelectedAnimation].Climb, Animations[Settings.SelectedAnimation].Fall, Animations[Settings.SelectedAnimation].Swim, Animations[Settings.SelectedAnimation].SwimIdle, Animations[Settings.SelectedAnimation].Weight, Animations[Settings.SelectedAnimation].Weight2)
		if Settings.Custom.Wave then
			PlayCustomAnim("wave", Settings.Custom.Wave)
		 end
		 if Settings.Custom.Laugh then
			 PlayCustomAnim("laugh", Settings.Custom.Laugh)
		 end
		 if Settings.Custom.Cheer then
			 PlayCustomAnim("cheer", Settings.Custom.Cheer)
		 end
		 if Settings.Custom.Point then
			 PlayCustomAnim("point", Settings.Custom.Point)
		 end
		 if Settings.Custom.Sit then
			PlayCustomAnim("sit", Settings.Custom.Sit)
		end
		 if Settings.Custom.Dance then
			 PlayCustomAnim("dance", Settings.Custom.Dance)
		 end
		 if Settings.Custom.Dance2 then
			 PlayCustomAnim("dance2", Settings.Custom.Dance2)
		 end
		 if Settings.Custom.Dance3 then
			 PlayCustomAnim("dance3", Settings.Custom.Dance3)
		 end
		RefreshAnims()
		local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
		local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
		for _, v in pairs(ActiveTracks) do
			v:AdjustSpeed(Settings.AnimationSpeed)
		end
    end
end




game.TextChatService.OnIncomingMessage = function(message)
	local textSource = tostring(message.TextSource)
	local text = tostring(message.Text)
	if textSource == game.Players.LocalPlayer.Name and Settings.Chat and text:match(Settings.EmotePrefix) or textSource == game.Players.LocalPlayer.Name and Settings.Animate and text:match(Settings.AnimationPrefix) then
	   message.Status = Enum.TextChatMessageStatus.InvalidTextChannelPermissions
	end
end









local UIS = game:GetService("UserInputService")

local Window = Rayfield:CreateWindow({
    Name = "MOPSI-Hub",
    LoadingTitle = "MOPSI-Hub",
    LoadingSubtitle = "by @FAUSTssg",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MOPSI_Hub",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

local Home = Window:CreateTab("Главная")

Home:CreateParagraph({Title = "Кодером скрипта является @FAUSTssg", Content = "Скрипт ПОЛНОСТЬЮ БЕСПЛАТНЫЙ, если вы у кого-то его купили, то вы баклан."})

Home:CreateSection("Следите за обновлениями!")

Home:CreateButton({
    Name = "Telegram: t.me/faust_cheats",
    Callback = function()
        if setclipboard then
            setclipboard("https://t.me/faust_cheats")
            SendCheck("Успех", "Ссылка на Telegram скопирована в буфер обмена!")
        else
            SendError("Ошибка", "Ваш исполнитель не поддерживает копирование в буфер обмена")
        end
    end
})


game:GetService("Players").LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started and queue_on_teleport then
        queue_on_teleport("repeat task.wait() until game:IsLoaded() getgenv().Teleported = true")
    end
end)





if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("UpperTorso") then
	local Trolling = Window:CreateTab("Троллинг")
	if CheckType() == "R15" then

		local PlayerDropdown = Trolling:CreateDropdown({
            Name = "Выберите игрока",
            Options = GetPlayerList(),
            CurrentOption = {""},
            MultipleOptions = false,
            Flag = "PlayerDropdown",
            Callback = function(Option)
                Settings.Player = getPlayerFromSelection(Option[1])
            end
        })
        table.insert(allPlayerDropdowns, PlayerDropdown)

        Trolling:CreateButton({
            Name = "Обновить список игроков",
            Callback = function()
                PlayerDropdown:Refresh(GetPlayerList(), true)
            end
        })

		Trolling:CreateButton({Name = "Телепорт",Callback = function()
			if not Settings.Player then return end
			Rayfield:Notify({
				Title = "MOPSI-Hub - Успех",
				Content = "Телепортирован к " .. Settings.Player.DisplayName .. " @" .. Settings.Player.Name,
				Duration = 3
			})
			game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = Settings.Player.Character.HumanoidRootPart.CFrame
		end})


		Trolling:CreateButton({Name = "Осмотреть",Callback = function()
			if not Settings.Player then return end
			Rayfield:Notify({
				Title = "MOPSI-Hub - Успех",
				Content = "Осмотр " .. Settings.Player.DisplayName .. " @" .. Settings.Player.Name,
				Duration = 3
			})
			game:GetService("GuiService"):CloseInspectMenu()
			game:GetService("GuiService"):InspectPlayerFromUserId(Settings.Player.UserId)
		end})

		Trolling:CreateButton({Name = "Fling (Выбранный)",Callback = function()
			if Settings.Player then
				SkidFling(Settings.Player, false)
			else
				SendError("Ошибка", "Игрок не выбран")
			end
		end})

		Trolling:CreateButton({Name = "Fling All",Callback = function()
			for _, v in pairs(game.Players:GetPlayers()) do
				if v ~= game.Players.LocalPlayer then
					SkidFling(v, true)
				end
			end
		end})

		Trolling:CreateToggle({
			Name = "Loop Fling All",
			CurrentValue = false,
			Callback = function(t)
				getgenv().LoopFlingAll = t
				if t then
					task.spawn(function()
						while getgenv().LoopFlingAll do
							for _, v in pairs(game.Players:GetPlayers()) do
								if not getgenv().LoopFlingAll then break end
								if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
									SkidFling(v, true)
								end
							end
							task.wait(0.5)
						end
					end)
				end
			end
		})

		Trolling:CreateToggle({
			Name = "Walk-Fling",
			CurrentValue = Settings.WalkFling,
			Callback = function(t)
				Settings.WalkFling = t
				if t then
					task.spawn(function()
						while Settings.WalkFling do
							local char = game.Players.LocalPlayer.Character
							local Root = char and char:FindFirstChild("HumanoidRootPart")
							local Humanoid = char and char:FindFirstChild("Humanoid")
							if Root and Humanoid then
								Root.CanCollide = false
								Humanoid:ChangeState(11)

								game:GetService("RunService").Heartbeat:Wait()
								local vel = Root.Velocity
								Root.Velocity = vel * 99999999 + Vector3.new(0, 99999999, 0)

								game:GetService("RunService").RenderStepped:Wait()
								Root.Velocity = vel

								game:GetService("RunService").Stepped:Wait()
								Root.Velocity = vel + Vector3.new(0, 0.1, 0)
							else
								task.wait()
							end
						end
					end)
				end
				UpdateFile()
			end
		})









		Trolling:CreateToggle({Name = "Раздражать",CurrentValue = false,Callback = function(t)
			Settings.Annoy = t
			if Settings.Annoy then
				local a = Instance.new("Part",game:GetService("Lighting"))
				a.Name = "niggaAnnoy"
				Settings.PlayAlways = t
				local Emote_Name = GetEmote("Clap")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim:AdjustSpeed(100)
			elseif game:GetService("Lighting"):FindFirstChild("niggaAnnoy") then
				game:GetService("Lighting"):FindFirstChild("niggaAnnoy"):Destroy()
				RefreshAnims()
			end
			while Settings.Annoy do task.wait()
				if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player and Settings.Player.Character and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = Settings.Player.Character.HumanoidRootPart.CFrame
				end
			end
		end
	})


	Trolling:CreateToggle({Name = "Наблюдать",CurrentValue = false,Callback = function(t)
		if not Settings.Player and t == true or Settings.Player and not Settings.Player.Character and t == true then
			SendError("Ошибка!","Игрок не найден! Выберите игрока в выпадающем списке выше.")
		end
		if t == true and Settings.Player then
			if workspace:FindFirstChild("ViewNIG") then
				workspace.ViewNIG:Destroy()
			end
			local a = Instance.new("Part",workspace)
			a.Name = "ViewNIG"
			game:GetService("Workspace").CurrentCamera.CameraSubject = Settings.Player.Character
			Rayfield:Notify({
				Title = "MOPSI-Hub - Успех",
				Content = "Наблюдение за " .. Settings.Player.DisplayName .. " @" .. Settings.Player.Name,
				Duration = 3
			})
		elseif workspace:FindFirstChild("ViewNIG") then
			workspace.ViewNIG:Destroy()
			game:GetService("Workspace").CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character
			Rayfield:Notify({
				Title = "MOPSI-Hub - Успех",
				Content = "Прекращено наблюдение за " .. Settings.Player.DisplayName .. " @" .. Settings.Player.Name,
				Duration = 3
			})
		end
	end
	})

	Trolling:CreateToggle({Name = "Следовать",CurrentValue = false,Callback = function(t)
		LoopGoTo = t
		while LoopGoTo == true do task.wait()
			if Settings.Player and Settings.Player.Character and game.Players.LocalPlayer.Character and Settings.Player.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Settings.Player.Character.HumanoidRootPart.CFrame
			end
		end
	end
	})


    Trolling:CreateToggle({Name = "Орбита", CurrentValue = false, Callback = function(t)
        Settings.Orbit = t
        local angle = 0
        while Settings.Orbit do
            task.wait()
            if Settings.Player and Settings.Player.Character and Settings.Player.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                angle = angle + (Settings.OrbitSpeed / 100)
                local offset = Vector3.new(math.cos(angle) * Settings.OrbitRadius, 0, math.sin(angle) * Settings.OrbitRadius)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Settings.Player.Character.HumanoidRootPart.Position + offset, Settings.Player.Character.HumanoidRootPart.Position)
            end
        end
    end})

    local OrbitRadiusSlider = Trolling:CreateSlider({Name = "Радиус орбиты", Range = {0, 1000}, Increment = 1, CurrentValue = 5, Flag = "OrbitRadius", Callback = function(s)
        Settings.OrbitRadius = s
    end})

    Trolling:CreateInput({Name = "Ввести радиус", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.OrbitRadius = val
            OrbitRadiusSlider:Set(val)
        end
    end})

    local OrbitSpeedSlider = Trolling:CreateSlider({Name = "Скорость орбиты", Range = {0, 1000}, Increment = 1, CurrentValue = 5, Flag = "OrbitSpeed", Callback = function(s)
        Settings.OrbitSpeed = s
    end})

    Trolling:CreateInput({Name = "Ввести скорость", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.OrbitSpeed = val
            OrbitSpeedSlider:Set(val)
        end
    end})


		Trolling:CreateToggle({Name = "Надругаться",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Gem")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 8
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What"
			elseif game.Lighting:FindFirstChild("What") then
				game.Lighting:FindFirstChild("What"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
					end
				end
		end
		})



		Trolling:CreateToggle({Name = "Надругаться 3",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Dolphin Dance")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = (26 / 100) * _G.LoadAnim.Length
				local a = Instance.new("Part",game.Lighting)
				a.Name="What2"
			elseif game.Lighting:FindFirstChild("What2") then
				game.Lighting:FindFirstChild("What2"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -1, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, -1, 2)
					_G.LoadAnim.TimePosition = (26 / 100) * _G.LoadAnim.Length
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Надругаться 4",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("AOK - Tai Verdes")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = (5 / 100) * _G.LoadAnim.Length
				local a = Instance.new("Part",game.Lighting)
				a.Name="What3"
			elseif game.Lighting:FindFirstChild("What3") then
				game.Lighting:FindFirstChild("What3"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
					_G.LoadAnim.TimePosition = (15 / 100) * _G.LoadAnim.Length
					end
				end
		end
		})



		Trolling:CreateToggle({Name = "Быть надруганным",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				local Emote_Name = GetEmote("Sleep")
				RefreshAnims()
				PlayEmote(Emote_Name)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What4"
			elseif game.Lighting:FindFirstChild("What4") then
				game.Lighting:FindFirstChild("What4"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
			if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
				local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

				-- Check if the player is falling
				if playerHRP.Position.Y < targetHRP.Position.Y then
					-- Create invisible platform at targetHRP position if falling
					if not platform then
						platform = Instance.new("Part")
						platform.Size = Vector3.new(5, 0.1, 5)						platform.Transparency = 1
						platform.Anchored = true
						platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)						platform.Parent = game.Workspace
					end
				else
					-- Remove the platform if the player is not falling
					if platform then
						platform:Destroy()
						platform = nil
					end
				end

				playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
				task.wait(.15)
				playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
				task.wait(.15)
				playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
				end
			end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 2",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Gem")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 8
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What5"
			elseif game.Lighting:FindFirstChild("What5") then
				game.Lighting:FindFirstChild("What5"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end

						playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Быть надруганным 3",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Scorpion")
				RefreshAnims()
				PlayEmote(Emote_Name)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What6"
			elseif game.Lighting:FindFirstChild("What6") then
				game.Lighting:FindFirstChild("What6"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					_G.LoadAnim.TimePosition = 83
						playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					_G.LoadAnim.TimePosition = 84
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					_G.LoadAnim.TimePosition = 83
					task.wait(.15)
					_G.LoadAnim.TimePosition = 84
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 4",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("BURBERRY LOLA  ATTITUDE - GEM")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 60
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What7"
			elseif game.Lighting:FindFirstChild("What7") then
				game.Lighting:FindFirstChild("What7"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 5",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("BURBERRY LOLA  ATTITUDE - GEM")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 38
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What8"
			elseif game.Lighting:FindFirstChild("What8") then
				game.Lighting:FindFirstChild("What8"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Быть надруганным 6",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Alo Yoga Pose - Warrior II")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (10 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What9"
			elseif game.Lighting:FindFirstChild("What9") then
				game.Lighting:FindFirstChild("What9"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Быть надруганным 7",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Break Dance")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (53 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What10"
			elseif game.Lighting:FindFirstChild("What10") then
				game.Lighting:FindFirstChild("What10"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 0)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 2)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Быть надруганным 8",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Team USA Breaking Emote")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (15 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga"
			elseif game.Lighting:FindFirstChild("WhatNigga") then
				game.Lighting:FindFirstChild("WhatNigga"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, -math.pi /2, 0) * CFrame.new(-2, 0, 0)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, -math.pi /2, 0) * CFrame.new(-3, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, -math.pi /2, 0) * CFrame.new(-4, 0, 2)
					end
				end
		end
		})





		Trolling:CreateToggle({Name = "Быть надруганным 9",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Olympic Dismount")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (15 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga4"
			elseif game.Lighting:FindFirstChild("WhatNigga4") then
				game.Lighting:FindFirstChild("WhatNigga4"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 0)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 2)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Быть надруганным 10",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Olympic Dismount")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (28 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga5"
			elseif game.Lighting:FindFirstChild("WhatNigga5") then
				game.Lighting:FindFirstChild("WhatNigga5"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 11",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Olympic Dismount")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (27 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga6"
			elseif game.Lighting:FindFirstChild("WhatNigga6") then
				game.Lighting:FindFirstChild("WhatNigga6"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, -1, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, -1, 2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, -1, 3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 12",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("TMNT Dance")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (70 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga7"
			elseif game.Lighting:FindFirstChild("WhatNigga7") then
				game.Lighting:FindFirstChild("WhatNigga7"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, -3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Быть надруганным 13",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Team USA Breaking Emote")
				RefreshAnims()
				PlayEmote(Emote_Name)
				task.wait(.15)
				_G.LoadAnim.TimePosition = (45 / 100) * _G.LoadAnim.Length
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="WhatNigga3"
			elseif game.Lighting:FindFirstChild("WhatNigga3") then
				game.Lighting:FindFirstChild("WhatNigga3"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(1, 0, 1)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(1, 0, 2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(1, 0, 3)
					end
				end
		end
		})

		Trolling:CreateToggle({Name = "Шлепнуть по заднице",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Beauty Touchdown")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = -1
				local a = Instance.new("Part",game.Lighting)
				a.Name="What11"
			elseif game.Lighting:FindFirstChild("What11") then
				game.Lighting:FindFirstChild("What11"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(-2, 0, 2)
					task.wait(.15)
					_G.LoadAnim.TimePosition = -1
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(-2, 0, 3)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.new(-2, 0, 4)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Минет",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Gem")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 8
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What12"
			elseif game.Lighting:FindFirstChild("What12") then
				game.Lighting:FindFirstChild("What12"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait(0.01)
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 2)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 3)
					task.wait(.15)
					playerHRP.CFrame = targetHRP.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, 4)
					end
				end
		end
		})


		Trolling:CreateToggle({Name = "Преследовать",CurrentValue = false,Callback = function(t)
			Settings.RapePlayer = t
			if Settings.RapePlayer then
				if not Settings.Player or Settings.Player and not Settings.Player.Character then
				SendError("Ошибка!","Игрок не найден! Выберите игрока в списке выше.")
				end
				Settings.PlayAlways = true
				Settings.Time = true
				local Emote_Name = GetEmote("Gem")
				RefreshAnims()
				PlayEmote(Emote_Name)
				_G.LoadAnim.TimePosition = 8
				_G.LoadAnim:AdjustSpeed(0)
				local a = Instance.new("Part",game.Lighting)
				a.Name="What45"
			elseif game.Lighting:FindFirstChild("What45") then
				game.Lighting:FindFirstChild("What45"):Destroy()
				RefreshAnims()
				Settings.PlayAlways = false
			end
			while Settings.RapePlayer do task.wait()
				pcall(function()
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
						game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
					end
				end)
				if game:GetService("Players").LocalPlayer.Character and Settings.Player.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.Player.Character:FindFirstChild("HumanoidRootPart") then
					local playerHRP = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local targetHRP = Settings.Player.Character:FindFirstChild("HumanoidRootPart")

					if playerHRP.Position.Y < targetHRP.Position.Y then
						if not platform then
							platform = Instance.new("Part")
							platform.Size = Vector3.new(5, 0.1, 5)
							platform.Transparency = 1
							platform.Anchored = true
							platform.Position = targetHRP.Position + Vector3.new(0, 2, 0)
							platform.Parent = game.Workspace
						end
					else
						if platform then
							platform:Destroy()
							platform = nil
						end
					end
					local direction = (playerHRP.Position - targetHRP.Position).unit

					local offset = direction * 3
					playerHRP.CFrame = CFrame.new(targetHRP.Position + offset, targetHRP.Position)
					end
				end
		end
		})







	end
end

local VisualsTab = Window:CreateTab("Визуал")

local MovementTab = Window:CreateTab("Движение")

VisualsTab:CreateToggle({Name = "Включить ESP", CurrentValue = Settings.ESP, Callback = function(t)
    Settings.ESP = t
    UpdateFile()
end})




VisualsTab:CreateToggle({Name = "Включить ESP2 (Хитбоксы)", CurrentValue = Settings.ESP2, Callback = function(t)
    Settings.ESP2 = t
    if not t then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
    UpdateFile()
end})




VisualsTab:CreateToggle({Name = "Отображать имена", CurrentValue = Settings.ESP_Names, Callback = function(t)
    Settings.ESP_Names = t
    UpdateFile()
end})




VisualsTab:CreateToggle({Name = "Отображать здоровье", CurrentValue = Settings.ESP_Health, Callback = function(t)
    Settings.ESP_Health = t
    UpdateFile()
end})




VisualsTab:CreateSlider({Name = "Цвет ESP (HUE)", Range = {0, 100}, CurrentValue = (Settings.ESPHue or 0) * 100, Increment = 1, Callback = function(s)
    Settings.ESPHue = s / 100
    UpdateFile()
end})




VisualsTab:CreateToggle({Name = "Включить Crosshair", CurrentValue = Settings.Crosshair, Callback = function(t)
    Settings.Crosshair = t
    UpdateCrosshair()
    UpdateFile()
end})




VisualsTab:CreateSlider({Name = "Цвет Crosshair (HUE)", Range = {0, 100}, CurrentValue = (Settings.CrosshairHue or 0) * 100, Increment = 1, Callback = function(s)
    Settings.CrosshairHue = s / 100
    UpdateCrosshair()
    UpdateFile()
end})




    local CrosshairSizeSlider = VisualsTab:CreateSlider({Name = "Размер Crosshair", Range = {0, 1000}, CurrentValue = Settings.CrosshairSize or 10, Increment = 1, Callback = function(s)
        Settings.CrosshairSize = s
        UpdateCrosshair()
        UpdateFile()
    end})

    VisualsTab:CreateInput({Name = "Ввести размер Crosshair", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.CrosshairSize = val
            UpdateCrosshair()
            UpdateFile()
            CrosshairSizeSlider:Set(val)
        end
    end})






local itemSearch = ""
local ItemDropdown = VisualsTab:CreateDropdown({
    Name = "Список предметов",
    Options = {},
    Callback = function(s)
        giveItem(foundItems[s[1]])
    end
})

VisualsTab:CreateInput({
    Name = "Поиск предмета",
    PlaceholderText = "Название предмета",
    Callback = function(s)
        itemSearch = s
        ItemDropdown:Refresh(getItemsList(itemSearch), true)
    end
})

VisualsTab:CreateButton({
    Name = "Обновить список предметов",
    Callback = function()
        ItemDropdown:Refresh(getItemsList(itemSearch), true)
    end
})

VisualsTab:CreateButton({
    Name = "Выдать всё (ReplicatedStorage)",
    Callback = function()
        for _, item in pairs(game.ReplicatedStorage:GetDescendants()) do
            if item:IsA("Tool") or item:IsA("HopperBin") then
                giveItem(item)
            end
        end
    end
})



local recordStatus = MovementTab:CreateParagraph({Title = "Статус записи", Content = "Готово к записи"})

MovementTab:CreateButton({
    Name = "Начать запись",
    Callback = function()
        if isRunning then return end
        startRecording()
        recordStatus:Set({Title = "Статус записи", Content = "Идёт запись..."})
    end
})

MovementTab:CreateButton({
    Name = "Остановить запись",
    Callback = function()
        stopRecording()
        recordStatus:Set({Title = "Статус записи", Content = "Записано кадров: " .. #recordedFrames})
    end
})

MovementTab:CreateButton({
    Name = "Воспроизвести (Цикл)",
    Callback = function()
        if #recordedFrames == 0 then
            recordStatus:Set({Title = "Статус записи", Content = "Нет записи!"})
            return
        end
        playRecording()
        recordStatus:Set({Title = "Статус записи", Content = "Воспроизведение..."})
    end
})

MovementTab:CreateButton({
    Name = "Остановить воспроизведение",
    Callback = function()
        stopRunning()
        recordStatus:Set({Title = "Статус записи", Content = "Остановлено"})
    end
})

MovementTab:CreateButton({
    Name = "Невидимка",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
    end
})

local AnimTab = Window:CreateTab("Анимации")

local AStatus
if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("UpperTorso") then
	AStatus = AnimTab:CreateParagraph({Title = "Информация об анимации", Content = "Выбранная анимация: " .. (Settings.SelectedAnimation or "") .. " // Скорость: " .. tostring(Settings.AnimationSpeed or "") .. " // Заморожено: " .. (Settings.FreezeAnimation and "Да" or "Нет")})

	AnimTab:CreateDropdown({
        Name = "Эмоции (R15)",
        Options = EmoteList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(s)
            if CheckType() ~= "R6" then
                StopEmotes()
                Settings.LastEmote = s[1]
                PlayEmote(s[1])
                UpdateFile()
            end
        end
    })
end




    local WalkSpeedSlider = MovementTab:CreateSlider({
        Name = "Скорость ходьбы",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = Settings.WalkSpeed or 16,
        Callback = function(s)
            Settings.WalkSpeed = s
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = s
            end
            UpdateFile()
        end
    })

    MovementTab:CreateInput({Name = "Ввести скорость ходьбы", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.WalkSpeed = val
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = val
            end
            UpdateFile()
            WalkSpeedSlider:Set(val)
        end
    end})

    local JumpPowerSlider = MovementTab:CreateSlider({
        Name = "Сила прыжка",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = Settings.JumpPower or 50,
        Callback = function(s)
            Settings.JumpPower = s
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character.Humanoid.JumpPower = s
            end
            UpdateFile()
        end
    })

    MovementTab:CreateInput({Name = "Ввести силу прыжка", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.JumpPower = val
            if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
                LP.Character.Humanoid.JumpPower = val
            end
            UpdateFile()
            JumpPowerSlider:Set(val)
        end
    end})


    local GravitySlider = MovementTab:CreateSlider({
        Name = "Гравитация",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = 196,
        Callback = function(s)
            if s>196 then
                game:GetService("Workspace").Gravity = -s
            else
                game:GetService("Workspace").Gravity = s
            end
        end
    })

    MovementTab:CreateInput({Name = "Ввести гравитацию", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            if val>196 then
                game:GetService("Workspace").Gravity = -val
            else
                game:GetService("Workspace").Gravity = val
            end
            GravitySlider:Set(val)
        end
    end})


    local HipHeightSlider = MovementTab:CreateSlider({
        Name = "Высота бедер",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight or 0,
        Callback = function(s)
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = s
            end
        end
    })

    MovementTab:CreateInput({Name = "Ввести высоту бедер", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = val
            end
            HipHeightSlider:Set(val)
        end
    end})

    local FlySpeedSlider = MovementTab:CreateSlider({
        Name = "Скорость полета",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = 50,
        Callback = function(s)
            Settings.FlySpeed = s
        end
    })

    MovementTab:CreateInput({Name = "Ввести скорость полета", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.FlySpeed = val
            FlySpeedSlider:Set(val)
        end
    end})






    local FOVSlider = VisualsTab:CreateSlider({
        Name = "Угол обзора (FOV)",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = game:GetService("Workspace").CurrentCamera.FieldOfView,
        Callback = function(s)
            game:GetService("Workspace").CurrentCamera.FieldOfView = s
        end
    })

    VisualsTab:CreateInput({Name = "Ввести FOV", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            game:GetService("Workspace").CurrentCamera.FieldOfView = val
            FOVSlider:Set(val)
        end
    end})


    if game.Players.LocalPlayer then
        local ZoomSlider = VisualsTab:CreateSlider({
            Name = "Зум",
            Range = {0, 1000},
            Increment = 1,
            CurrentValue = game.Players.LocalPlayer.CameraMaxZoomDistance,
            Callback = function(s)
                game.Players.LocalPlayer.CameraMaxZoomDistance = s
            end
        })

        VisualsTab:CreateInput({Name = "Ввести Зум", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
            local val = tonumber(s)
            if val then
                game.Players.LocalPlayer.CameraMaxZoomDistance = val
                ZoomSlider:Set(val)
            end
        end})
    end


    if setfpscap then
        local FPSSlider = VisualsTab:CreateSlider({
            Name = "FPS",
            Range = {0, 165},
            Increment = 1,
            CurrentValue = 60,
            Callback = function(s)
                setfpscap(s)
            end
        })

        VisualsTab:CreateInput({Name = "Ввести FPS", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
            local val = tonumber(s)
            if val then FPSSlider:Set(val) end
        end})
    end



local c;
local h;
local bv;
local bav;
local cam;
local flying;

local StartFly = function ()
    if not game:GetService("Players").LocalPlayer.Character or not game:GetService("Players").LocalPlayer.Character:FindFirstChild("LowerTorso") or flying then return end;
    c = game:GetService("Players").LocalPlayer.Character;
    h = c:FindFirstChildOfClass("Humanoid");
    local root = c:FindFirstChild("HumanoidRootPart")
    if not root then return end

    h.PlatformStand = true;
    cam = workspace.CurrentCamera;

    bv = Instance.new("BodyVelocity");
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.P = 1250
    bv.Parent = root;

    bav = Instance.new("BodyAngularVelocity");
    bav.AngularVelocity = Vector3.new(0, 0, 0)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 1250
    bav.Parent = root;

    flying = true;
    h.Died:connect(function() flying = false end);
end;

local EndFly = function ()
    flying = false;
    if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false;
    end
    if bv then bv:Destroy() end
    if bav then bav:Destroy() end
end;


game:GetService("UserInputService").InputBegan:connect(function (input, GPE)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Settings.ClickTeleport then
        game:GetService("Players").LocalPlayer.Character:MoveTo(game.Players.LocalPlayer:GetMouse().Hit.p)
    end
end);

game:GetService("UserInputService").InputEnded:connect(function (input, GPE)
end);


local setVec = function (vec)
    return vec * ((Settings.FlySpeed or 50) / vec.Magnitude);
end;

game:GetService("RunService").Heartbeat:connect(function (step)
    if flying and c and c.PrimaryPart and h then
        local cameraCF = cam.CFrame
        c:SetPrimaryPartCFrame(CFrame.new(c.PrimaryPart.Position) * cameraCF.Rotation)

        local velocity = Vector3.new(0,0.1,0)
        if h.MoveDirection.Magnitude > 0 then
            local look = cameraCF.LookVector
            local right = cameraCF.RightVector
            local moveDir = h.MoveDirection

            local forwardAmount = -cameraCF:VectorToObjectSpace(moveDir).Z
            local sideAmount = cameraCF:VectorToObjectSpace(moveDir).X

            velocity = (look * forwardAmount + right * sideAmount) * (Settings.FlySpeed or 50)
        end
        bv.Velocity = velocity
    end
end);


MovementTab:CreateToggle({Name = "Fly",CurrentValue = false,Callback = function(t)
    Fly = t
    if Fly == true then
		local a = Instance.new("Part",game:GetService("Lighting"))
		a.Name = "NiggaFly"
        for Every,Connection in next, getconnections(game.Players.LocalPlayer.Character.Head.ChildAdded) do
            Connection:Disable()
        end
        StartFly();
    elseif game:GetService("Lighting"):FindFirstChild("NiggaFly") then
		game:GetService("Lighting"):FindFirstChild("NiggaFly"):Destroy()
        EndFly();
    end
end})


local Noclipping = nil

MovementTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(t)
        Settings.Noclip = t

        if Settings.Noclip then
            local a = Instance.new("Part", game:GetService("Lighting"))
            a.Name = "niggANOclip"

            local function NoClip()
                if game:GetService("Players").LocalPlayer.Character and Settings.Noclip then
                    for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                        if child:IsA('BasePart') and child.CanCollide and Settings.Noclip then
                            child.CanCollide = false
                        end
                    end
                end
            end

            if Noclipping then
                Noclipping:Disconnect()
            end
            Noclipping = game:GetService("RunService").RenderStepped:Connect(NoClip)
        elseif game:GetService("Lighting"):FindFirstChild("niggANOclip") then
            game:GetService("Lighting"):FindFirstChild("niggANOclip"):Destroy()
            if Noclipping then
                Noclipping:Disconnect()
                Noclipping = nil
            end
            -- Re-enable collision immediately
            if game:GetService("Players").LocalPlayer.Character then
                for _, child in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                    if child:IsA('BasePart') then
                        child.CanCollide = true
                    end
                end
            end
        end
    end
})


MovementTab:CreateToggle({
    Name = "Platform",
    CurrentValue = false,
    Callback = function(t)
        Settings.Platform = t
        if Settings.Platform then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            local platform = Instance.new("Part", workspace)
			platform.Transparency = 1
            platform.Name = tostring(math.random(1, 1115))
			platform.Material = "Plastic"
            platform.Size = Vector3.new(300, 1, 300)
            platform.Anchored = true
            platform.CanCollide = true

            task.spawn(function()
                if character and character:FindFirstChild("HumanoidRootPart") then
					local hrp = character.HumanoidRootPart
					platform.Position = Vector3.new(hrp.Position.X, hrp.Position.Y - hrp.Size.Y / 2 - platform.Size.Y / 2, hrp.Position.Z)
				end
				while Settings.Platform do task.wait() end
                platform:Destroy()
            end)
        end
    end
})


local SpinConnection
MovementTab:CreateToggle({
    Name = "Spin (Вращение)",
    CurrentValue = Settings.Spin,
    Callback = function(t)
        Settings.Spin = t
        if t then
            if SpinConnection then SpinConnection:Disconnect() end
            SpinConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed or 10), 0)
                end
            end)
        else
            if SpinConnection then SpinConnection:Disconnect() end
        end
        UpdateFile()
    end
})

    local SpinSpeedSlider = MovementTab:CreateSlider({
        Name = "Скорость вращения",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = Settings.SpinSpeed or 10,
        Callback = function(s)
            Settings.SpinSpeed = s
            UpdateFile()
        end
    })

    MovementTab:CreateInput({Name = "Ввести скорость вращения", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.SpinSpeed = val
            UpdateFile()
            SpinSpeedSlider:Set(val)
        end
    end})

local AntiFlingConnection
MovementTab:CreateToggle({
    Name = "Anti-Fling (Анти-Флинг)",
    CurrentValue = Settings.AntiFling,
    Callback = function(t)
        Settings.AntiFling = t
        if t then
            if AntiFlingConnection then AntiFlingConnection:Disconnect() end
            AntiFlingConnection = game:GetService("RunService").Stepped:Connect(function()
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                                part.Velocity = Vector3.new(0, 0, 0)
                                part.RotVelocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end
                end
            end)
        else
            if AntiFlingConnection then AntiFlingConnection:Disconnect() end
        end
        UpdateFile()
    end
})

MovementTab:CreateToggle({
    Name = "Sit",
    CurrentValue = false,
    Callback = function(t)
	if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = t
	end
end})

MovementTab:CreateToggle({Name = "Refresh",CurrentValue = false,Callback = function(t)
	Settings.Refresh = t
	if Settings.Refresh then
		SendCheck("When you reset your character, you'll respawn in the same position you", "died in.")
	end
	if Settings.Refresh and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		game.Players.LocalPlayer.Character.Humanoid.Died:Connect(function()
			Settings.DeathPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
		end)
		local Human = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid", true)
		local pos = Human and Human.RootPart and Human.RootPart.CFrame
		local pos1 = workspace.CurrentCamera.CFrame
		local char = game.Players.LocalPlayer.Character
		task.spawn(function()
			local newCharacter = game.Players.LocalPlayer.CharacterAdded:Wait()
			if Settings.Refresh then
				newCharacter:WaitForChild("Humanoid").RootPart.CFrame, workspace.CurrentCamera.CFrame = pos, wait() and pos1
			end
		end)
	end
end})


local oldGrav = workspace.Gravity
local swimBeat
local gravReset
MovementTab:CreateToggle({Name = "Swim", CurrentValue = false, Callback = function(t)
    if t == true then
        local a = Instance.new("Part", workspace)
        a.Name = "Swimaaaaa"
        workspace.Gravity = 0
        local swimDied = function()
            workspace.Gravity = oldGrav
        end
        local Hum = game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        gravReset = Hum.Died:Connect(swimDied)
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for i, v in pairs(enums) do
            Hum:SetStateEnabled(v, false)
        end
        Hum:ChangeState(Enum.HumanoidStateType.Swimming)
        swimBeat = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Velocity = ((Hum.MoveDirection ~= Vector3.new() or Hum.Jump) and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Velocity or Vector3.new())
            end)
        end)
    elseif workspace:FindFirstChild("Swimaaaaa") then
        workspace.Swimaaaaa:Destroy()
        workspace.Gravity = oldGrav
        if gravReset then
            gravReset:Disconnect()
        end
        if swimBeat ~= nil then
            swimBeat:Disconnect()
            swimBeat = nil
        end
        local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        local enums = Enum.HumanoidStateType:GetEnumItems()
        table.remove(enums, table.find(enums, Enum.HumanoidStateType.None))
        for i, v in pairs(enums) do
            Humanoid:SetStateEnabled(v, true)
        end
    end
end})



MovementTab:CreateToggle({Name = "Click Teleport",CurrentValue = false,Callback = function(t)
    Settings.ClickTeleport = t
    if Settings.ClickTeleport then
        Rayfield:Notify({
            Title = "MOPSI-Hub - Успех",
            Content = 'Клик-телепорт включен; Клавиши: CTRL + Клик',
            Image = 10932910166,
            Duration = 10
        })
    end
end})

MovementTab:CreateToggle({Name = "Infinite Jump",CurrentValue = false,Callback = function(t)
    Settings.InfJump = t
end})

MovementTab:CreateToggle({
    Name = "Frog Jump (Лягушка)",
    CurrentValue = Settings.FrogJump,
    Callback = function(t)
        Settings.FrogJump = t
        UpdateFile()
    end
})

    local FrogPowerSlider = MovementTab:CreateSlider({
        Name = "Сила Лягушки",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = Settings.FrogPower or 60,
        Callback = function(s)
            Settings.FrogPower = s
            UpdateFile()
        end
    })

    MovementTab:CreateInput({Name = "Ввести силу лягушки", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.FrogPower = val
            UpdateFile()
            FrogPowerSlider:Set(val)
        end
    end})



MovementTab:CreateToggle({
    Name = "AntiKill Parts", CurrentValue = Settings.AntiKill, Callback = function(t)
    Settings.AntiKill = t
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanTouch = not t
        end
    end
    UpdateFile()
end})






MovementTab:CreateButton({Name = "Skydive",Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 500, 0)
end})


MovementTab:CreateButton({Name = "Reset",Callback = function()
    game.Players.LocalPlayer.Character.Head.Parent = nil
end})

VisualsTab:CreateToggle({Name = "День/Ночь",CurrentValue = false,Callback = function(t)
	Settings.Day = t
	if Settings.Day then
		local a = Instance.new("Part",game.Lighting)
		a.Name = "nigga"
		game.Lighting.ClockTime = 0
	elseif game.Lighting:FindFirstChild("nigga") and not Settings.Day then
		game.Lighting.nigga:Destroy()
		game.Lighting.ClockTime = 14
	elseif game.Lighting.ClockTime == 0 and Settings.Day then
		game.Lighting.ClockTime = 14
	end
end})

VisualsTab:CreateToggle({Name = "Full Bright (Яркий свет)", CurrentValue = false, Callback = function(t)
    if t then
        getgenv().FullBright = true
        task.spawn(function()
            while getgenv().FullBright do
                game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                game.Lighting.Brightness = 2
                game.Lighting.FogEnd = 9e9
                task.wait(1)
            end
        end)
    else
        getgenv().FullBright = false
        game.Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        game.Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        game.Lighting.Brightness = 1
    end
end})

VisualsTab:CreateToggle({Name = "X-ray", CurrentValue = Settings.Xray, Callback = function(t)
    Settings.Xray = t
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.LocalTransparencyModifier = t and 0.5 or 0
        end
    end
    UpdateFile()
end})




local function sendMessage(text)
    if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = game:GetService("TextChatService"):FindFirstChild("RBXGeneral", true)
        if channel and channel:IsA("TextChannel") then
            channel:SendAsync(text)
        end
    else
        local event = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if event and event:FindFirstChild("SayMessageRequest") then
            event.SayMessageRequest:FireServer(text, "All")
        end
    end
end

VisualsTab:CreateToggle({
    Name = "Включить спам",
    CurrentValue = Settings.ChatSpam,
    Callback = function(t)
        Settings.ChatSpam = t
        if t then
            task.spawn(function()
                while Settings.ChatSpam do
                    sendMessage(Settings.SpamMessage or "MOPSI-Hub")
                    task.wait((Settings.SpamDelay or 1000) / 1000)
                end
            end)
        end
        UpdateFile()
    end
})

VisualsTab:CreateInput({
    Name = "Сообщение для спама",
    PlaceholderText = "Текст для спама",
    Callback = function(s)
        Settings.SpamMessage = s
        UpdateFile()
    end
})

    local SpamDelaySlider = VisualsTab:CreateSlider({
        Name = "Задержка (Мс)",
        Range = {0, 1000},
        Increment = 100,
        CurrentValue = Settings.SpamDelay or 1000,
        Callback = function(s)
            Settings.SpamDelay = s
            UpdateFile()
        end
    })

    VisualsTab:CreateInput({Name = "Ввести задержку (Мс)", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.SpamDelay = val
            UpdateFile()
            SpamDelaySlider:Set(val)
        end
    end})











game:GetService("UserInputService").JumpRequest:Connect(function()
    if Settings.InfJump then
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)


local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

UIS.InputBegan:Connect(function(input, GPE)
    if GPE then return end

	local isTeleportPress = (input.UserInputType == Enum.UserInputType.MouseButton1)
    or (input.UserInputType == Enum.UserInputType.Touch and Settings.ClickTeleport)

	if isTeleportPress then
		local target = Mouse.Target

		if Settings.ClickToSelect and target and target.Parent then
			local targetPlayer = Players:GetPlayerFromCharacter(target.Parent)
			if targetPlayer and targetPlayer ~= LocalPlayer then
				SendCheck("Выбран:", targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")")
				Settings.Player = targetPlayer
				Player_Name = targetPlayer
			end
		end

		if Settings.ClickTeleport then
			if LocalPlayer.Character then
				LocalPlayer.Character:MoveTo(Mouse.Hit.p)
			end
		end
	end
end)









function GetRandomAnimation(animations)
	local keys = {}
	for key, _ in pairs(animations) do
	  table.insert(keys, key)
	end

	local randomKey = keys[math.random(1, #keys)]

	return animations[randomKey]
end


if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("UpperTorso") then
	AnimTab:CreateDropdown({
        Name = "Выбрать анимацию",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = SAnimation
            UpdateFile()
            StopEmotes()
            PlayAnimationBody(Animations[SAnimation].Idle, Animations[SAnimation].Idle2, Animations[SAnimation].Idle3, Animations[SAnimation].Walk, Animations[SAnimation].Run, Animations[SAnimation].Jump, Animations[SAnimation].Climb, Animations[SAnimation].Fall, Animations[SAnimation].Swim, Animations[SAnimation].SwimIdle, Animations[SAnimation].Weight, Animations[SAnimation].Weight2)
            RefreshAnims()
            local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
            local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
            for _, v in pairs(ActiveTracks) do
                v:AdjustSpeed(Settings.AnimationSpeed)
            end
            AStatus:Set({Title = "Информация об анимации", Content = "Текущая анимация: " .. Settings.SelectedAnimation .. " // Скорость: " .. tostring(Settings.AnimationSpeed)})
        end
    })

	AnimTab:CreateInput({
        Name = "Играть анимацию (ID)",
        PlaceholderText = "ID анимации",
        Callback = function(s)
            UpdateFile()
            PlayAnimation(s)
        end
    })






    AnimTab:CreateToggle({
        Name = "Случайная анимация",
        CurrentValue = false,
        Callback = function(t)
            Settings.RandomAnim = t
            UpdateFile()
            while Settings.RandomAnim do task.wait()
                if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and Settings.RandomAnim then
                    Settings.Custom = GetRandomAnimation(Animations)
                    StopEmotes()
                    PlayAnimationBody(Settings.Custom.Idle, Settings.Custom.Idle2, Settings.Custom.Idle3, Settings.Custom.Walk, Settings.Custom.Run, Settings.Custom.Jump, Settings.Custom.Climb, Settings.Custom.Fall, Settings.Custom.Swim, Settings.Custom.SwimIdle, Settings.Custom.Weight, Settings.Custom.Weight2)
                    Settings.SelectedAnimation = "Custom"
                    local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
                    local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
                    for _, v in pairs(ActiveTracks) do
                        v:AdjustSpeed(Settings.AnimationSpeed)
                    end
                    AStatus:Set({Title = "Информация об анимации", Content = "Текущая анимация: " .. Settings.SelectedAnimation .. " // Скорость: " .. tostring(Settings.AnimationSpeed)})
                    RefreshAnims()
                    task.wait(6.35)
                end
            end
        end
    })






	AnimTab:CreateButton({Name="Сбросить анимации",Callback=function()
		StopEmotes()
		Settings.SelectedAnimation = ""
		Settings.Custom = {Name=nil,Idle=nil, Idle2=nil, Idle3=nil, Walk=nil, Run=nil, Jump=nil, Climb=nil, Fall=nil, Swim=nil, SwimIdle=nil, Wave=9527883498, Laugh=507770818,Cheer=507770677,Point=507770453,Sit=2506281703,Dance=507771019,Dance2=507776043,Dance3=507777268, Weight=9, Weight2=1}
		UpdateFile()
		local Animate = game:GetService("Players").LocalPlayer.Character.Animate
		Animate.idle.Animation1.AnimationId = getgenv().OriginalAnimations[1] or ""
		Animate.idle.Animation2.AnimationId = getgenv().OriginalAnimations[2] or ""
		if Animate:FindFirstChild("pose") then
			local poseAnimation = game:GetService("Players").LocalPlayer.Character.Animate.pose:FindFirstChildOfClass("Animation")
			if poseAnimation then
				poseAnimation.AnimationId = getgenv().OriginalAnimations[3] or ""
			end
		end
		Animate.walk:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[4] or ""
		Animate.run:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[5] or ""
		Animate.jump:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[6] or ""
		Animate.climb:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[7] or ""
		Animate.fall:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[8] or ""
		Animate.swim:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[9] or ""
		Animate.swimidle:FindFirstChildOfClass("Animation").AnimationId = getgenv().OriginalAnimations[10] or ""
		RefreshAnims()
	end})



	local AnimationSpeedSlider = AnimTab:CreateSlider({
        Name = "Скорость анимации",
        Range = {0, 1000},
        Increment = 1,
        CurrentValue = 1,
        Callback = function(s)
            Settings.AnimationSpeed = s
            AStatus:Set({Title = "Информация об анимации", Content = "Текущая анимация: " .. Settings.SelectedAnimation .. " // Скорость: " .. tostring(Settings.AnimationSpeed)})
        end
	})

    AnimTab:CreateInput({Name = "Ввести скорость анимации", PlaceholderText = "Число", RemoveTextAfterFocusLost = true, Callback = function(s)
        local val = tonumber(s)
        if val then
            Settings.AnimationSpeed = val
            AStatus:Set({Title = "Информация об анимации", Content = "Текущая анимация: " .. Settings.SelectedAnimation .. " // Скорость: " .. tostring(val)})
            AnimationSpeedSlider:Set(val)
        end
    end})












local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")










	AnimTab:CreateToggle({Name = "Sit",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Lotus")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (45 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What13"
		elseif game.Lighting:FindFirstChild("What13") then
			game.Lighting:FindFirstChild("What13"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})

	local hiphh = 2.1
	if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		hiphh = game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight
	end



	AnimTab:CreateToggle({Name = "Sit 2",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Bicycle")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (72 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What14"
		elseif game.Lighting:FindFirstChild("What14") then
			game.Lighting:FindFirstChild("What14"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})

	AnimTab:CreateToggle({Name = "Sit 3",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Quiet Waves")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (12 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What16"
		elseif game.Lighting:FindFirstChild("What16") then
			game.Lighting:FindFirstChild("What16"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})


	AnimTab:CreateToggle({Name = "Sit 4",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Skadoosh")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (77 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What17"
		elseif game.Lighting:FindFirstChild("What17") then
			game.Lighting:FindFirstChild("What17"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})








	AnimTab:CreateToggle({Name = "Float",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Fall Back to Float")
			PlayEmote(Emote_Name)
			game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = 4
			task.wait(.15)
			_G.LoadAnim.TimePosition = (72 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What18"
		elseif game.Lighting:FindFirstChild("What18") then
			game.Lighting:FindFirstChild("What18"):Destroy()
			game:GetService("Players").LocalPlayer.Character.Humanoid.HipHeight = hiphh
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})

	AnimTab:CreateToggle({Name = "Float 2",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Skadoosh")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (43 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What19"
		elseif game.Lighting:FindFirstChild("What19") then
			game.Lighting:FindFirstChild("What19"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})


	AnimTab:CreateToggle({Name = "Float 3",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Cuco - Levitate")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (7 / 100) * _G.LoadAnim.Length
			local a = Instance.new("Part",game.Lighting)
			a.Name="What20"
		elseif game.Lighting:FindFirstChild("What20") then
			game.Lighting:FindFirstChild("What20"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		task.spawn(function()
			while Settings.RapePlayer do
				_G.LoadAnim.TimePosition = (7 / 100) * _G.LoadAnim.Length
				task.wait(6)
			end
		end)
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})



	AnimTab:CreateToggle({Name = "Upside Down",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Hero Landing")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (24.15 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What21"
		elseif game.Lighting:FindFirstChild("What21") then
			game.Lighting:FindFirstChild("What21"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})


	AnimTab:CreateToggle({Name = "Upside Down 2",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Skadoosh")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (44 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What22"
		elseif game.Lighting:FindFirstChild("What22") then
			game.Lighting:FindFirstChild("What22"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})

	AnimTab:CreateToggle({Name = "Lay Down",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Bicycle")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (57 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What23"
		elseif game.Lighting:FindFirstChild("What23") then
			game.Lighting:FindFirstChild("What23"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})




	AnimTab:CreateToggle({Name = "Twerk Ass",CurrentValue = false,Callback = function(t)
		Settings.TwerkAss = t
		if Settings.TwerkAss then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Scorpion")
			PlayEmote(Emote_Name)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What24"
		elseif game.Lighting:FindFirstChild("What24") then
			game.Lighting:FindFirstChild("What24"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.TwerkAss do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
			_G.LoadAnim.TimePosition = 83
			task.wait(.15)
			_G.LoadAnim.TimePosition = 83
			_G.LoadAnim.TimePosition = 83
			task.wait(.15)
			_G.LoadAnim.TimePosition = 83
		end
	end
	})

	AnimTab:CreateToggle({Name = "Twerk Ass 2",CurrentValue = false,Callback = function(t)
		Settings.TwerkAss2 = t
		if Settings.TwerkAss2 then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Scorpion")
			PlayEmote(Emote_Name)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What25"
		elseif game.Lighting:FindFirstChild("What25") then
			game.Lighting:FindFirstChild("What25"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.TwerkAss2 do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
			_G.LoadAnim.TimePosition = 82
			task.wait(.15)
			_G.LoadAnim.TimePosition = 83
			_G.LoadAnim.TimePosition = 82
			task.wait(.15)
			_G.LoadAnim.TimePosition = 83
		end
		end
	})


	AnimTab:CreateToggle({Name = "Strech",CurrentValue = false,Callback = function(t)
		Settings.RapePlayer = t
		if Settings.RapePlayer then
			Settings.PlayAlways = true
			Settings.Time = true
			RefreshAnims()
			local Emote_Name = GetEmote("Quiet Waves")
			PlayEmote(Emote_Name)
			task.wait(.15)
			_G.LoadAnim.TimePosition = (52 / 100) * _G.LoadAnim.Length
			_G.LoadAnim:AdjustSpeed(0)
			local a = Instance.new("Part",game.Lighting)
			a.Name="What26"
		elseif game.Lighting:FindFirstChild("What26") then
			game.Lighting:FindFirstChild("What26"):Destroy()
			RefreshAnims()
			Settings.PlayAlways = false
		end
		while Settings.RapePlayer do task.wait()
			pcall(function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit then
					game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = false
				end
			end)
		end
	end
	})


end


if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("UpperTorso") then
	local Custom = Window:CreateTab("Свои анимации")




	Custom:CreateDropdown({
        Name = "Эмоции (Анимация)",
        Options = {"Idle","Idle 2","Walk","Run","Jump","Climb","Fall","Swim Idle","Swim","Wave","Laugh","Cheer","Point","Sit","Dance",'Dance 2', 'Dance 3'},
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(s_table)
            local s = s_table[1]
            if Settings.LastEmote == "" then
                SendError("Ошибка!","Сначала выберите эмоцию во вкладке (Главная)!")
                return
            end
            if s == "Idle" then
                PlayCustomAnim("idle1", Emotes[Settings.LastEmote])
                Settings.Custom.Idle = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Idle 2" then
                PlayCustomAnim("idle2", Emotes[Settings.LastEmote])
                Settings.Custom.Idle2 = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Walk" then
                PlayCustomAnim("walk", Emotes[Settings.LastEmote])
                Settings.Custom.Walk = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Run" then
                PlayCustomAnim("run", Emotes[Settings.LastEmote])
                Settings.Custom.Run = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Jump" then
                PlayCustomAnim("jump", Emotes[Settings.LastEmote])
                Settings.Custom.Jump = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Climb" then
                PlayCustomAnim("climb", Emotes[Settings.LastEmote])
                Settings.Custom.Climb = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Fall" then
                PlayCustomAnim("fall", Emotes[Settings.LastEmote])
                Settings.Custom.Fall = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Swim Idle" then
                PlayCustomAnim("swimidle", Emotes[Settings.LastEmote])
                Settings.Custom.SwimIdle = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Swim" then
                PlayCustomAnim("swim", Emotes[Settings.LastEmote])
                Settings.Custom.Swim = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Wave" then
                PlayCustomAnim("wave", Emotes[Settings.LastEmote])
                Settings.Custom.Wave = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Laugh" then
                PlayCustomAnim("laugh", Emotes[Settings.LastEmote])
                Settings.Custom.Laugh = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Cheer" then
                PlayCustomAnim("cheer", Emotes[Settings.LastEmote])
                Settings.Custom.Cheer = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Point" then
                PlayCustomAnim("point", Emotes[Settings.LastEmote])
                Settings.Custom.Point = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Sit" then
                PlayCustomAnim("sit", Emotes[Settings.LastEmote])
                Settings.Custom.Sit = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Dance" then
                PlayCustomAnim("dance", Emotes[Settings.LastEmote])
                Settings.Custom.Dance = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Dance 2" then
                PlayCustomAnim("dance2", Emotes[Settings.LastEmote])
                Settings.Custom.Dance2 = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            elseif s == "Dance 3" then
                PlayCustomAnim("dance3", Emotes[Settings.LastEmote])
                Settings.Custom.Dance3 = Emotes[Settings.LastEmote]
                Settings.SelectedAnimation = "Custom"
                UpdateFile()
            end
        end
    })





	local RandomIdle = false

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local RandomIdle = false

Custom:CreateToggle({
	Name = "Случайная анимация покоя",
    CurrentValue = false,
	Callback = function(t)
		RandomIdle = t

		task.spawn(function()
			repeat task.wait() until
				player.Character
				and player.Character:FindFirstChild("Animate")

			local Animate = player.Character.Animate

			while RandomIdle do


				local rand = GetRandomAnimation(Animations)

				local id1 = rand.Idle
				local id2 = rand.Idle2
				local id3 = rand.Idle3

				local weight1 = rand.Weight or 1
				local weight2 = rand.Weight2 or 1

				if Animate:FindFirstChild("idle") then
					Animate.idle.Animation1.AnimationId = URL .. id1
					Animate.idle.Animation1.Weight.Value = tostring(weight1)

					Animate.idle.Animation2.AnimationId = URL .. id2
					Animate.idle.Animation2.Weight.Value = tostring(weight2)
				end

				if Animate:FindFirstChild("pose") and id3 then
					local anim = Animate.pose:FindFirstChildOfClass("Animation")
					if anim then
						anim.AnimationId = URL .. id3
					end
				end
				task.wait(3)
			end
		end)
	end
})



	Custom:CreateButton({
		Name="Выбрать случайные анимации из эмоций",
		Callback=function()
			Settings.Custom.Custom = {}
			RefreshAnims()
			UpdateFile()
			for i = 1, 10 do
				task.wait()
				local randomEmoteKey, randomEmoteValue = getRandomEmote()
				if i == 1 then
					Settings.Custom.Idle = randomEmoteValue
				elseif i == 2 then
					Settings.Custom.Idle2 = randomEmoteValue
				elseif i == 3 then
					Settings.Custom.Idle3 = randomEmoteValue
				elseif i == 4 then
					Settings.Custom.Walk = randomEmoteValue
				elseif i == 5 then
					Settings.Custom.Run = randomEmoteValue
				elseif i == 6 then
					Settings.Custom.Jump = randomEmoteValue
				elseif i == 7 then
					Settings.Custom.Climb = randomEmoteValue
				elseif i == 8 then
					Settings.Custom.Fall = randomEmoteValue
				elseif i == 9 then
					Settings.Custom.Swim = randomEmoteValue
				elseif i == 10 then
					Settings.Custom.SwimIdle = randomEmoteValue
				end
			end
			PlayAnimationBody(Settings.Custom.Idle, Settings.Custom.Idle2, Settings.Custom.Idle3, Settings.Custom.Walk, Settings.Custom.Run, Settings.Custom.Jump, Settings.Custom.Climb, Settings.Custom.Fall, Settings.Custom.Swim, Settings.Custom.SwimIdle, Settings.Custom.Weight, Settings.Custom.Weight2)
			UpdateFile()
			RefreshAnims()
			Settings.SelectedAnimation = "Custom"
			Settings.Custom.Name = "Emotes"
		end
	})




	Custom:CreateDropdown({
        Name = "Установить Idle1",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("idle1", Animations[SAnimation].Idle)
            Settings.Custom.Idle = Animations[SAnimation].Idle
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })

	Custom:CreateDropdown({
        Name = "Установить Idle2",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("idle2", Animations[SAnimation].Idle2)
            Settings.Custom.Idle2 = Animations[SAnimation].Idle2
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })


	Custom:CreateDropdown({
        Name = "Установить Ходьбу",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("walk", Animations[SAnimation].Walk)
            Settings.Custom.Walk = Animations[SAnimation].Walk
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })


	Custom:CreateDropdown({
        Name = "Установить Бег",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("run", Animations[SAnimation].Run)
            Settings.Custom.Run = Animations[SAnimation].Run
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })


	Custom:CreateDropdown({
        Name = "Установить Прыжок",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("jump", Animations[SAnimation].Jump)
            Settings.Custom.Jump = Animations[SAnimation].Jump
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })


	Custom:CreateDropdown({
        Name = "Установить Лазание",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("climb", Animations[SAnimation].Climb)
            Settings.Custom.Climb = Animations[SAnimation].Climb
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })


	Custom:CreateDropdown({
        Name = "Установить Падение",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("fall", Animations[SAnimation].Fall)
            Settings.Custom.Fall = Animations[SAnimation].Fall
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })




	Custom:CreateDropdown({
        Name = "Установить Плавание (Покой)",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("swimidle", Animations[SAnimation].SwimIdle)
            Settings.Custom.SwimIdle = Animations[SAnimation].SwimIdle
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })



	Custom:CreateDropdown({
        Name = "Установить Плавание",
        Options = AnimationList,
        CurrentOption = {""},
        MultipleOptions = false,
        Callback = function(SAnimation_table)
            local SAnimation = SAnimation_table[1]
            Settings.SelectedAnimation = ""
            PlayCustomAnim("swim", Animations[SAnimation].Swim)
            Settings.Custom.Swim = Animations[SAnimation].Swim
            Settings.SelectedAnimation = "Custom"
            Settings.Custom.Name = SAnimation
            UpdateFile()
        end
    })
end


local BABFT = Window:CreateTab("BABFT")

BABFT:CreateToggle({
    Name = "Авто-фарм",
    CurrentValue = Settings.AutoFarm,
    Callback = function(t)
        Settings.AutoFarm = t
        UpdateFile()
        if t then
            task.spawn(function()
                local travelTime = 1.6
                SendCheck("Полет", "Активирован режим фарминга.")

                while Settings.AutoFarm do
                    task.wait(0.5)
                    local char = LP.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
                    local root = char.HumanoidRootPart
                    local stages = workspace:FindFirstChild("BoatStages") and workspace.BoatStages:FindFirstChild("NormalStages")
                    if not stages then continue end

                    local antiGravityConnection
                    antiGravityConnection = RunService.Heartbeat:Connect(function()
                        if not Settings.AutoFarm or not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
                            if antiGravityConnection then antiGravityConnection:Disconnect() end
                            return
                        end
                        LP.Character.HumanoidRootPart.Velocity = Vector3.new(LP.Character.HumanoidRootPart.Velocity.X, 0, LP.Character.HumanoidRootPart.Velocity.Z)
                        for _, child in pairs(LP.Character:GetDescendants()) do
                            if child:IsA("BasePart") then
                                child.CanCollide = false
                            end
                        end
                    end)

                    for i = 1, 10 do
                        if not Settings.AutoFarm then break end
                        local stage = stages:FindFirstChild("CaveStage" .. i)
                        if stage then
                            local platformPart = stage:FindFirstChild("DarknessPart") or stage:FindFirstChildOfClass("BasePart")
                            if platformPart then
                                root.Velocity = Vector3.new(0, 0, 0)
                                local targetPos = platformPart.CFrame + Vector3.new(0, 4, 0)
                                local tween = TweenService:Create(root, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {CFrame = targetPos})
                                tween:Play()
                                tween.Completed:Wait()
                                task.wait(0.3)
                            end
                        end
                    end

                    if Settings.AutoFarm then
                        local theEnd = stages:FindFirstChild("TheEnd")
                        if theEnd then
                            local chestPart = theEnd:FindFirstChildOfClass("BasePart")
                            if chestPart then
                                root.Velocity = Vector3.new(0, 0, 0)
                                local chestPos = chestPart.CFrame + Vector3.new(0, 0.5, 0)
                                local chestTween = TweenService:Create(root, TweenInfo.new(travelTime * 0.8, Enum.EasingStyle.Linear), {CFrame = chestPos})
                                chestTween:Play()
                                chestTween.Completed:Wait()
                                task.wait(6)
                                SendCheck("✓ Успех!", "Золото собрано!")
                            end
                        end
                    end

                    if antiGravityConnection then antiGravityConnection:Disconnect() end
                    if LP.Character then LP.Character:BreakJoints() end
                    LP.CharacterAdded:Wait()
                    task.wait(1.5)
                end
            end)
        end
    end
})


local Misc = Window:CreateTab("Настройки")

local WL_Display = Misc:CreateParagraph({Title = "Участники:", Content = table.concat(getgenv().Settings.WhiteList, ", ")})

local selectedWLPlayer = ""
local AddWLDropdown = Misc:CreateDropdown({
    Name = "Выбрать игрока для WhiteList",
    Options = GetPlayerList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(s_table)
        selectedWLPlayer = s_table[1]:match("@([%w_]+)")
    end
})
table.insert(allPlayerDropdowns, AddWLDropdown)

Misc:CreateButton({
    Name = "Добавить в WhiteList",
    Callback = function()
        if selectedWLPlayer ~= "" and not table.find(getgenv().Settings.WhiteList, selectedWLPlayer) then
            table.insert(getgenv().Settings.WhiteList, selectedWLPlayer)
            UpdateFile()
            WL_Display:Set({Title = "Участники:", Content = table.concat(getgenv().Settings.WhiteList, ", ")})
            SendCheck("WhiteList", "Игрок " .. selectedWLPlayer .. " добавлен")
        end
    end
})

local RemoveWLDropdown = Misc:CreateDropdown({
    Name = "Удалить из WhiteList",
    Options = getgenv().Settings.WhiteList,
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(s_table)
        local s = s_table[1]
        local idx = table.find(getgenv().Settings.WhiteList, s)
        if idx then
            table.remove(getgenv().Settings.WhiteList, idx)
            UpdateFile()
            WL_Display:Set({Title = "Участники:", Content = table.concat(getgenv().Settings.WhiteList, ", ")})
            SendCheck("WhiteList", "Игрок " .. s .. " удален")
        end
    end
})

Misc:CreateButton({
    Name = "Обновить список удаления",
    Callback = function()
        RemoveWLDropdown:Refresh(getgenv().Settings.WhiteList, true)
    end
})


Misc:CreateButton({Name="Перезайти",Callback=function()
    game:GetService('TeleportService'):Teleport(game.PlaceId)
end})

Misc:CreateButton({Name="Сбросить настройки",Callback=function()
    if isfile and isfile("MOPSI-Hub/Animations_Settings.txt") and delfile then
        delfile("MOPSI-Hub/Animations_Settings.txt")
        SendCheck("Успех", "Файл настроек удален. Пожалуйста, перезапустите скрипт или перезайдите в игру.")
    else
        SendError("Ошибка", "Файл настроек не найден или ваше ПО не поддерживает удаление файлов.")
    end
end})


Misc:CreateButton({Name="Сохранить текущие анимации (Файл)",Callback=function()
    if game:GetService("Players").LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character.Animate ~= nil then
		local Animate = game:GetService('Players').LocalPlayer.Character.Animate
		local RandomID = math.random(9e9, 8e8)
		if writefile then
			writefile(game:GetService("Players").LocalPlayer.Name.."_Animations_"..RandomID..".lua", "local Animate = game:GetService('Players').LocalPlayer.Character.Animate".."\n".."Animate.idle.Animation1.AnimationId = ".."'"..Animate.idle.Animation1.AnimationId.."'".."\n".."Animate.idle.Animation2.AnimationId = ".."'"..Animate.idle.Animation2.AnimationId.."'".."\n".."Animate.run:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.run:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.walk:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.walk:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.jump:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.jump:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.climb:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.climb:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.fall:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.fall:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swim:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swim:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId.."'")
			SendCheck("Анимации " .. game:GetService("Players").LocalPlayer.Name .. " @" .. game:GetService("Players").LocalPlayer.DisplayName, "сохранены в папку workspace!")
		else
			SendCheck("Анимации " .. game:GetService("Players").LocalPlayer.Name .. " @" .. game:GetService("Players").LocalPlayer.DisplayName, "скопированы в буфер обмена")
			setclipboard("local Animate = game:GetService('Players').LocalPlayer.Character.Animate".."\n".."Animate.idle.Animation1.AnimationId = ".."'"..Animate.idle.Animation1.AnimationId.."'".."\n".."Animate.idle.Animation2.AnimationId = ".."'"..Animate.idle.Animation2.AnimationId.."'".."\n".."Animate.run:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.run:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.walk:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.walk:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.jump:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.jump:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.climb:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.climb:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.fall:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.fall:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swim:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swim:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId.."'")
		end
	end
end})



local SaveAnimDropdown = Misc:CreateDropdown({
    Name = "Сохранить файл анимаций (Игрок)",
    Options = GetPlayerList(),
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(s_table)
        local s = s_table[1]
        local targetPlayer = getPlayerFromSelection(s)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Animate") then
            local Animate = targetPlayer.Character.Animate
            local RandomID = math.random(9e9, 8e8)
            writefile(targetPlayer.Name.."_Animations_"..RandomID..".lua", "local Players = game:GetService('Players')".."\n".."local Animate = Players['"..targetPlayer.Name.."'].Character.Animate".."\n".."Animate.idle.Animation1.AnimationId = ".."'"..Animate.idle.Animation1.AnimationId.."'".."\n".."Animate.idle.Animation2.AnimationId = ".."'"..Animate.idle.Animation2.AnimationId.."'".."\n".."Animate.run:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.run:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.walk:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.walk:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.jump:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.jump:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.climb:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.climb:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.fall:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.fall:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swim:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swim:FindFirstChildOfClass('Animation').AnimationId.."'".."\n".."Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId = ".."'"..Animate.swimidle:FindFirstChildOfClass('Animation').AnimationId.."'")
            SendCheck("Анимации " .. targetPlayer.Name .. " @" .. targetPlayer.DisplayName, "сохранены в папку workspace!")
        end
    end
})
table.insert(allPlayerDropdowns, SaveAnimDropdown)

Misc:CreateButton({
    Name = "Обновить список игроков (Сохр)",
    Callback = function()
        SaveAnimDropdown:Refresh(GetPlayerList(), true)
    end
})

local selectedScriptPath = ""
local foundScripts = {}
local scriptSearch = ""

local function getScriptsList(filter)
    foundScripts = {}
    local names = {}
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("LocalScript") and v.Name ~= "Animate" then
                local path = v:GetFullName()
                if not filter or path:lower():find(filter:lower()) then
                    foundScripts[path] = v
                    table.insert(names, path)
                end
            end
        end)
    end
    table.sort(names)
    return names
end


local ScriptDropdown = Misc:CreateDropdown({
    Name = "Выберите локальный скрипт",
    Options = {},
    CurrentOption = {""},
    MultipleOptions = false,
    Callback = function(s_table)
        local s = s_table[1]
        selectedScriptPath = s
        local scriptObj = foundScripts[s]
        if scriptObj then
            SendCustomCheck("Скрипт выбран", "Состояние: " .. (scriptObj.Disabled and "Выключен" or "Включен"), 2)
        end
    end
})

Misc:CreateInput({
    Name = "Поиск скрипта (название/путь)",
    PlaceholderText = "Название или путь",
    Callback = function(s)
        scriptSearch = s
        ScriptDropdown:Refresh(getScriptsList(scriptSearch), true)
    end
})

Misc:CreateButton({
    Name = "Включить/Выключить выбранный скрипт",
    Callback = function()
        local scriptObj = foundScripts[selectedScriptPath]
        if scriptObj then
            scriptObj.Disabled = not scriptObj.Disabled
            SendCheck("Скрипт изменен", scriptObj.Name .. " теперь " .. (scriptObj.Disabled and "ВЫКЛЮЧЕН" or "ВКЛЮЧЕН"))
        else
            SendError("Ошибка", "Сначала выберите скрипт из списка!")
        end
    end
})

Misc:CreateButton({
    Name = "Обновить список скриптов",
    Callback = function()
        ScriptDropdown:Refresh(getScriptsList(scriptSearch), true)
        SendCheck("Список обновлен", "Найдено локальных скриптов: " .. #getScriptsList(scriptSearch))
    end
})




game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("MoveDirection"):Connect(function()
	if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > 0 then
		if CheckType() == "R15" then
			if _G.LoadAnim and not Settings.PlayAlways then
				game:GetService("Players").LocalPlayer.Character.Animate.Disabled = false
				_G.LoadAnim:Stop()
			end
		else
			if _G.LoadAnim and not Settings.PlayAlways then
				_G.LoadAnim:Stop()
				RefreshAnims()
			end
		end
	end
end)



game.Players.LocalPlayer.CharacterAdded:Connect(function(chr)
    setupFrog(chr)
	repeat wait() until game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Animate")
    local humanoid = chr:WaitForChild("Humanoid")
    humanoid.WalkSpeed = Settings.WalkSpeed or 16
    humanoid.JumpPower = Settings.JumpPower or 50
	chr.Humanoid.Died:Connect(function()
		Settings.DeathPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	end)
	if Settings.Refresh and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Settings.DeathPosition then
	   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Settings.DeathPosition
	end
	wait(.15)
	StopEmotes()
	if Settings.SelectedAnimation ~= "" and CheckType() == "R15" and Settings.SelectedAnimation ~= "Custom" or Settings.LastEmote == "Play" and CheckType() == "R15" and Settings.SelectedAnimation ~= "Custom" then
		PlayAnimationBody(Animations[Settings.SelectedAnimation].Idle or GetOriginalAnimation(1),
                  Animations[Settings.SelectedAnimation].Idle2 or GetOriginalAnimation(2),
                  Animations[Settings.SelectedAnimation].Idle3 or GetOriginalAnimation(3),
                  Animations[Settings.SelectedAnimation].Walk or GetOriginalAnimation(4),
                  Animations[Settings.SelectedAnimation].Run or GetOriginalAnimation(5),
                  Animations[Settings.SelectedAnimation].Jump or GetOriginalAnimation(6),
                  Animations[Settings.SelectedAnimation].Climb or GetOriginalAnimation(7),
                  Animations[Settings.SelectedAnimation].Fall or GetOriginalAnimation(8),
                  Animations[Settings.SelectedAnimation].Swim or GetOriginalAnimation(9),
                  Animations[Settings.SelectedAnimation].SwimIdle or GetOriginalAnimation(10),
                  Animations[Settings.SelectedAnimation].Weight,
                  Animations[Settings.SelectedAnimation].Weight2)
		if Settings.Custom.Wave then
		   PlayCustomAnim("wave", Settings.Custom.Wave)
		end
		if Settings.Custom.Laugh then
			PlayCustomAnim("laugh", Settings.Custom.Laugh)
		end
		if Settings.Custom.Cheer then
			PlayCustomAnim("cheer", Settings.Custom.Cheer)
		end
		if Settings.Custom.Point then
			PlayCustomAnim("point", Settings.Custom.Point)
		end
		if Settings.Custom.Sit then
			PlayCustomAnim("sit", Settings.Custom.Sit)
		end
		if Settings.Custom.Dance then
			PlayCustomAnim("dance", Settings.Custom.Dance)
		end
		if Settings.Custom.Dance2 then
			PlayCustomAnim("dance2", Settings.Custom.Dance2)
		end
		if Settings.Custom.Dance3 then
			PlayCustomAnim("dance3", Settings.Custom.Dance3)
		end
		RefreshAnims()
		local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
		local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
		for _, v in pairs(ActiveTracks) do
			v:AdjustSpeed(Settings.AnimationSpeed)
		end
	elseif (Animations[Settings.Custom.Name]) and (Settings.Custom.Idle or Settings.Custom.Idle2 or Settings.Custom.Idle3 or Settings.Custom.Walk or Settings.Custom.Run or Settings.Custom.Jump or Settings.Custom.Climb or Settings.Custom.Fall or Settings.Custom.Swim or Settings.Custom.SwimIdle) and Animations[Settings.Custom.Name].Weight and Animations[Settings.Custom.Name].Weight2 and CheckType() == "R15" then
		PlayAnimationBody(Settings.Custom.Idle or OriginalAnimations[1], Settings.Custom.Idle2 or OriginalAnimations[2], Settings.Custom.Idle3 or OriginalAnimations[3] or nil, Settings.Custom.Walk or OriginalAnimations[4], Settings.Custom.Run or OriginalAnimations[5], Settings.Custom.Jump or OriginalAnimations[6], Settings.Custom.Climb or OriginalAnimations[7], Settings.Custom.Fall or OriginalAnimations[8], Settings.Custom.Swim or OriginalAnimations[9], Settings.Custom.SwimIdle or OriginalAnimations[10], Animations[Settings.Custom.Name].Weight, Animations[Settings.Custom.Name].Weight2)
		if Settings.Custom.Wave then
			PlayCustomAnim("wave", Settings.Custom.Wave)
		 end
		 if Settings.Custom.Laugh then
			 PlayCustomAnim("laugh", Settings.Custom.Laugh)
		 end
		 if Settings.Custom.Cheer then
			 PlayCustomAnim("cheer", Settings.Custom.Cheer)
		 end
		 if Settings.Custom.Point then
			 PlayCustomAnim("point", Settings.Custom.Point)
		 end
		 if Settings.Custom.Sit then
			PlayCustomAnim("sit", Settings.Custom.Sit)
		end
		 if Settings.Custom.Dance then
			 PlayCustomAnim("dance", Settings.Custom.Dance)
		 end
		 if Settings.Custom.Dance2 then
			 PlayCustomAnim("dance2", Settings.Custom.Dance2)
		 end
		 if Settings.Custom.Dance3 then
			 PlayCustomAnim("dance3", Settings.Custom.Dance3)
		 end
		RefreshAnims()
		local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
		local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
		for _, v in pairs(ActiveTracks) do
			v:AdjustSpeed(Settings.AnimationSpeed)
		end
	end
	game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("MoveDirection"):Connect(function()
		if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").MoveDirection.Magnitude > 0 then
			if CheckType() == "R15" then
				if _G.LoadAnim and not Settings.PlayAlways then
					game:GetService("Players").LocalPlayer.Character.Animate.Disabled = false
					_G.LoadAnim:Stop()
				end
			else
				if _G.LoadAnim and not Settings.PlayAlways then
					_G.LoadAnim:Stop()
					RefreshAnims()
				end
			end
		end
	end)
end)


if not getgenv().AlreadyLoaded then
	task.spawn(function()
		while task.wait() do
			if Settings.AnimationSpeedToggle and game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Settings.AnimationSpeedToggle and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController") then
				local Humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("AnimationController")
				local ActiveTracks = Humanoid:GetPlayingAnimationTracks()
				for _, v in pairs(ActiveTracks) do
					v:AdjustSpeed(Settings.AnimationSpeed)
				end
			end
		end
	end)
end


if not getgenv().AlreadyLoaded then
	getgenv().AlreadyLoaded = true
end


