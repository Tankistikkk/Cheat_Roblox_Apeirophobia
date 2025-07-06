local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local connections = {}

if CoreGui:FindFirstChild("SyndicateDynastyGUI") then
    CoreGui.SyndicateDynastyGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SyndicateDynastyGUI"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 0))
})
Gradient.Rotation = 90
Gradient.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 4)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Text = "SYNDICATE DYNASTY"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center
Title.Parent = MainFrame

local function CreateButton(text, yPos, hotkey)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.Position = UDim2.new(0, 10, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.AutoButtonColor = false
    Button.Parent = MainFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 5)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(80, 0, 0)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button

    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ButtonLabel.Position = UDim2.new(0, 15, 0, 0)
    ButtonLabel.Text = text
    ButtonLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Font = Enum.Font.GothamBold
    ButtonLabel.TextSize = 14
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = Button

    local HotkeyLabel = Instance.new("TextLabel")
    HotkeyLabel.Size = UDim2.new(0.3, -15, 1, 0)
    HotkeyLabel.Position = UDim2.new(0.7, 0, 0, 0)
    HotkeyLabel.Text = hotkey
    HotkeyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    HotkeyLabel.BackgroundTransparency = 1
    HotkeyLabel.Font = Enum.Font.GothamMedium
    HotkeyLabel.TextSize = 14
    HotkeyLabel.TextXAlignment = Enum.TextXAlignment.Right
    HotkeyLabel.Parent = Button

    local StatusLight = Instance.new("Frame")
    StatusLight.Size = UDim2.new(0, 10, 0, 10)
    StatusLight.Position = UDim2.new(0, 5, 0.5, -5)
    StatusLight.AnchorPoint = Vector2.new(0, 0.5)
    StatusLight.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    StatusLight.BorderSizePixel = 0
    StatusLight.Parent = Button

    local StatusCorner = Instance.new("UICorner")
    StatusCorner.CornerRadius = UDim.new(1, 0)
    StatusCorner.Parent = StatusLight

    local enterConn = Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        }):Play()
    end)
    table.insert(connections, enterConn)

    local leaveConn = Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        }):Play()
    end)
    table.insert(connections, leaveConn)

    return Button, StatusLight
end

local FlyButton, FlyStatus = CreateButton("Fly Hack", 50, "[NUM 0]")
local SpeedButton, SpeedStatus = CreateButton("Speed Hack", 90, "[NUM 1]")
local WallButton, WallStatus = CreateButton("Wall Hack", 130, "[NUM 2]")
local NoclipButton, NoclipStatus = CreateButton("NoClip", 170, "[NUM 3]")
local ToggleButton, _ = CreateButton("Toggle Menu", 210, "[INSERT]")
local UnloadButton, _ = CreateButton("Unload Cheat", 250, "[HOME]")

local function UpdateStatus(indicator, enabled)
    TweenService:Create(indicator, TweenInfo.new(0.2), {
        BackgroundColor3 = enabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    }):Play()
end

local FlyEnabled = false
local FlySpeed = 50
local FlyBodyVelocity

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        FlyBodyVelocity = Instance.new("BodyVelocity")
        FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        FlyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        FlyBodyVelocity.Parent = HumanoidRootPart
        
        Humanoid.PlatformStand = true
    else
        if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
        Humanoid.PlatformStand = false
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    
    UpdateStatus(FlyStatus, FlyEnabled)
end

local function HandleFly()
    if not FlyEnabled or not FlyBodyVelocity then return end
    
    local direction = Vector3.new(0, 0, 0)
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction = direction + workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction = direction - workspace.CurrentCamera.CFrame.LookVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction = direction - workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction = direction + workspace.CurrentCamera.CFrame.RightVector
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit * FlySpeed
    end
    FlyBodyVelocity.Velocity = direction
end

local SpeedEnabled = false
local SpeedValue = 30
local SpeedBodyVelocity
local OriginalWalkSpeed = Humanoid.WalkSpeed

local function ToggleSpeed()
    SpeedEnabled = not SpeedEnabled
    
    if SpeedEnabled then
        SpeedBodyVelocity = Instance.new("BodyVelocity")
        SpeedBodyVelocity.MaxForce = Vector3.new(math.huge, 0, math.huge)
        SpeedBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        SpeedBodyVelocity.Parent = HumanoidRootPart
        OriginalWalkSpeed = Humanoid.WalkSpeed
        Humanoid.WalkSpeed = 0
    else
        if SpeedBodyVelocity then SpeedBodyVelocity:Destroy() end
        Humanoid.WalkSpeed = OriginalWalkSpeed
    end
    
    UpdateStatus(SpeedStatus, SpeedEnabled)
end

local WallhackEnabled = false
local MonsterNames = {
    "Phantom Smiler", "Howler", "Cameraman", "Starfish", "Hound", 
    "Skin Walker", "Titan Smiler", "Skin Stealer", "Partygoer", 
    "Stalker", "Orison", "Kameloha", "Deformed Howler",
    "Watcher", "Caretaker", "Hoax", "Keeper", "Party Jelly", 
    "Phaser", "Cruelest", "Memory Worm"
}

local HighlightParts = {}

local function ToggleWallhack()
    WallhackEnabled = not WallhackEnabled
    
    for _, highlight in pairs(HighlightParts) do
        highlight:Destroy()
    end
    HighlightParts = {}
    
    if WallhackEnabled then
        for _, name in pairs(MonsterNames) do
            local monster = workspace:FindFirstChild(name, true)
            if monster then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.OutlineColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.Parent = monster
                table.insert(HighlightParts, highlight)
            end
        end
    end
    
    UpdateStatus(WallStatus, WallhackEnabled)
end

local NoclipEnabled = false

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not NoclipEnabled
        end
    end
    
    if NoclipEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
    
    UpdateStatus(NoclipStatus, NoclipEnabled)
end

local function HandleSpeed()
    if not SpeedEnabled or not SpeedBodyVelocity then return end
    SpeedBodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * SpeedValue
end

local function HandleNoclip()
    if NoclipEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function UnloadCheat()
    if FlyEnabled then
        if FlyBodyVelocity then 
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
        Humanoid.PlatformStand = false
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        FlyEnabled = false
        UpdateStatus(FlyStatus, false)
    end

    if SpeedEnabled then
        if SpeedBodyVelocity then 
            SpeedBodyVelocity:Destroy()
            SpeedBodyVelocity = nil
        end
        Humanoid.WalkSpeed = OriginalWalkSpeed
        SpeedEnabled = false
        UpdateStatus(SpeedStatus, false)
    end

    if WallhackEnabled then
        for _, highlight in pairs(HighlightParts) do
            highlight:Destroy()
        end
        HighlightParts = {}
        WallhackEnabled = false
        UpdateStatus(WallStatus, false)
    end

    if NoclipEnabled then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        NoclipEnabled = false
        UpdateStatus(NoclipStatus, false)
    end

    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    table.clear(connections)

    if ScreenGui then
        ScreenGui:Destroy()
    end

    warn("[Syndicate Dynasty] Cheat menu has been unloaded successfully!")
end

local flyConn = FlyButton.MouseButton1Click:Connect(ToggleFly)
table.insert(connections, flyConn)

local speedConn = SpeedButton.MouseButton1Click:Connect(ToggleSpeed)
table.insert(connections, speedConn)

local wallConn = WallButton.MouseButton1Click:Connect(ToggleWallhack)
table.insert(connections, wallConn)

local noclipConn = NoclipButton.MouseButton1Click:Connect(ToggleNoclip)
table.insert(connections, noclipConn)

local toggleConn = ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)
table.insert(connections, toggleConn)

local unloadConn = UnloadButton.MouseButton1Click:Connect(UnloadCheat)
table.insert(connections, unloadConn)

local inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    elseif input.KeyCode == Enum.KeyCode.Home then
        UnloadCheat()
    elseif input.KeyCode == Enum.KeyCode.KeypadZero then
        ToggleFly()
    elseif input.KeyCode == Enum.KeyCode.KeypadOne then
        ToggleSpeed()
    elseif input.KeyCode == Enum.KeyCode.KeypadTwo then
        ToggleWallhack()
    elseif input.KeyCode == Enum.KeyCode.KeypadThree then
        ToggleNoclip()
    end
end)
table.insert(connections, inputConn)

local heartbeatConn = RunService.Heartbeat:Connect(function()
    if FlyEnabled then HandleFly() end
    if SpeedEnabled then HandleSpeed() end
    if NoclipEnabled then HandleNoclip() end
end)
table.insert(connections, heartbeatConn)

local charConn = Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    OriginalWalkSpeed = Humanoid.WalkSpeed
    
    if FlyEnabled then
        local wasEnabled = FlyEnabled
        ToggleFly()
        if wasEnabled then ToggleFly() end
    end
    
    if SpeedEnabled then
        local wasEnabled = SpeedEnabled
        ToggleSpeed()
        if wasEnabled then ToggleSpeed() end
    end
    
    if WallhackEnabled then
        local wasEnabled = WallhackEnabled
        ToggleWallhack()
        if wasEnabled then ToggleWallhack() end
    end
    
    if NoclipEnabled then
        local wasEnabled = NoclipEnabled
        ToggleNoclip()
        if wasEnabled then ToggleNoclip() end
    end
end)
table.insert(connections, charConn)