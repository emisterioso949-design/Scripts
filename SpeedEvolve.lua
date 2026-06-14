-- +1 Speed Evolve Script
-- YouTube: Tora IsMe

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- RemoteEvents exactos del juego
local function getRemote(name)
    return RS:WaitForChild("Modules"):WaitForChild("Shared"):WaitForChild("RemoteEventService"):WaitForChild(name)
end

local SpeedRemote   = getRemote("AddSpeedRemoteEvent")
local RebirthRemote = getRemote("RebirthRemoteEvent")
local EvolveRemote  = getRemote("EvolutionRemoteEvent")
local WorldsRemote  = getRemote("WorldsRemoteEvent")

-- STATE
local Toggles = {
    SpeedFarm   = false,
    WinsFarm    = false,
    AutoRebirth = false,
    AutoEvolve  = false,
}

-- COOLDOWNS
local lastSpeed   = 0
local lastRebirth = 0
local lastEvolve  = 0
local lastWins    = 0

-- ============================================================
--  GUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToraIsMe_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 250)
MainFrame.Position = UDim2.new(0, 20, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 6)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "+1 SPEED EVOLVE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.Parent = TitleBar

-- Toggle creator
local function CreateToggle(name, displayName, yPos)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -16, 0, 36)
    Row.Position = UDim2.new(0, 8, 0, yPos)
    Row.BackgroundTransparency = 1
    Row.Parent = MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -44, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = displayName
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local CheckBG = Instance.new("Frame")
    CheckBG.Size = UDim2.new(0, 20, 0, 20)
    CheckBG.Position = UDim2.new(1, -22, 0.5, -10)
    CheckBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CheckBG.BorderSizePixel = 0
    CheckBG.Parent = Row
    Instance.new("UICorner", CheckBG).CornerRadius = UDim.new(0, 4)

    local Check = Instance.new("TextLabel")
    Check.Size = UDim2.new(1, 0, 1, 0)
    Check.BackgroundTransparency = 1
    Check.Text = "âœ“"
    Check.TextColor3 = Color3.fromRGB(255, 255, 255)
    Check.Font = Enum.Font.GothamBold
    Check.TextSize = 14
    Check.Visible = false
    Check.Parent = CheckBG

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = Row

    Btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        CheckBG.BackgroundColor3 = Toggles[name] and Color3.fromRGB(220, 50, 50) or Color3.fromRGB(40, 40, 40)
        Check.Visible = Toggles[name]
    end)
end

CreateToggle("SpeedFarm",   "Speed Farm",   40)
CreateToggle("WinsFarm",    "Wins Farm",    80)
CreateToggle("AutoRebirth", "Auto Rebirth", 120)
CreateToggle("AutoEvolve",  "Auto Evolve",  160)

-- Goto Portal button
local PortalBtn = Instance.new("TextButton")
PortalBtn.Size = UDim2.new(1, -16, 0, 28)
PortalBtn.Position = UDim2.new(0, 8, 0, 205)
PortalBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PortalBtn.BorderSizePixel = 0
PortalBtn.Text = "Goto Portal"
PortalBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
PortalBtn.Font = Enum.Font.Gotham
PortalBtn.TextSize = 13
PortalBtn.Parent = MainFrame
Instance.new("UICorner", PortalBtn).CornerRadius = UDim.new(0, 4)

local Watermark = Instance.new("TextLabel")
Watermark.Size = UDim2.new(1, 0, 0, 18)
Watermark.Position = UDim2.new(0, 0, 1, 2)
Watermark.BackgroundTransparency = 1
Watermark.Text = "by Axel"
Watermark.TextColor3 = Color3.fromRGB(130, 130, 130)
Watermark.Font = Enum.Font.Gotham
Watermark.TextSize = 11
Watermark.Parent = MainFrame

-- Goto Portal
PortalBtn.MouseButton1Click:Connect(function()
    WorldsRemote:FireServer()
end)

-- ============================================================
--  MAIN LOOP
-- ============================================================
RunService.Heartbeat:Connect(function()
    local now = tick()

    -- Speed Farm: spamea AddSpeedRemoteEvent
    if Toggles.SpeedFarm and now - lastSpeed > 0.1 then
        lastSpeed = now
        SpeedRemote:FireServer()
    end

    -- Wins Farm: teletransporta a la zona finish
    if Toggles.WinsFarm and now - lastWins > 1 then
        lastWins = now
        local char = LocalPlayer.Character
        local finish = workspace:FindFirstChild("Finish", true)
            or workspace:FindFirstChild("Win", true)
            or workspace:FindFirstChild("Goal", true)
        if char and char:FindFirstChild("HumanoidRootPart") and finish then
            char.HumanoidRootPart.CFrame = finish.CFrame + Vector3.new(0, 4, 0)
        end
    end

    -- Auto Rebirth
    if Toggles.AutoRebirth and now - lastRebirth > 1 then
        lastRebirth = now
        RebirthRemote:FireServer()
    end

    -- Auto Evolve
    if Toggles.AutoEvolve and now - lastEvolve > 1 then
        lastEvolve = now
        EvolveRemote:FireServer()
    end
end)

print("[ToraIsMe] Script cargado correctamente âœ“")
