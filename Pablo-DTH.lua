-- 👑 PABLO_DTHPRIME ULTRA HUB

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local rs = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")
local tpService = game:GetService("TeleportService")
local http = game:GetService("HttpService")

-- CONFIG
getgenv().Config = {
    AutoFarmAI = false,
    AutoLift = false,
    AutoSell = false,
    AutoKills = false,
    AutoRebirth = false,
    AutoRock = false,
    AutoZone = false,
    Stealth = false
}

getgenv().KillRange = 25

-- ANTI AFK
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- DRAG GUI
local function dragify(frame)
    local dragToggle, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            dragToggle = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragToggle then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 380, 0, 320)
main.Position = UDim2.new(0.05,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)

dragify(main)

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,35)
title.Text = "👑 PABLO_DTHPRIME ULTRA HUB"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.BackgroundTransparency = 1
title.TextScaled = true

-- TABS
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,35)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-65)
content.Position = UDim2.new(0,0,0,65)

local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0,90,1,0)
    btn.Text = name

    local frame = Instance.new("Frame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false

    tabs[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabs) do f.Visible=false end
        frame.Visible=true
    end)

    return frame
end

local farm = createTab("Farm")
local combat = createTab("Combat")
local misc = createTab("Misc")

tabs["Farm"].Visible = true

-- TOGGLE
local function toggle(parent,name)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-10,0,35)
    b.Text = name..": OFF"

    b.MouseButton1Click:Connect(function()
        Config[name]=not Config[name]
        b.Text = name..": "..(Config[name] and "ON" or "OFF")
    end)
end

-- FARM
toggle(farm,"AutoFarmAI")
toggle(farm,"AutoLift")
toggle(farm,"AutoSell")
toggle(farm,"AutoRebirth")
toggle(farm,"AutoRock")
toggle(farm,"AutoZone")

-- COMBAT
toggle(combat,"AutoKills")

-- MISC
toggle(misc,"Stealth")

-- SERVER HOP
local hop = Instance.new("TextButton", misc)
hop.Size = UDim2.new(1,-10,0,35)
hop.Text = "Server Hop"

hop.MouseButton1Click:Connect(function()
    local servers = game.HttpService:JSONDecode(
        game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    )

    for _,v in pairs(servers.data) do
        if v.playing < v.maxPlayers then
            tpService:TeleportToPlaceInstance(game.PlaceId, v.id)
        end
    end
end)

-- AI SYSTEM 🧠
task.spawn(function()
    while true do
        if Config.AutoFarmAI then
            Config.AutoLift = true
            Config.AutoSell = true
            Config.AutoRebirth = true
            Config.AutoZone = true
            Config.AutoRock = true
        end
        task.wait(5)
    end
end)

-- STEALTH 👻
task.spawn(function()
    while true do
        if Config.Stealth then
            char.Humanoid.WalkSpeed = 12
        else
            char.Humanoid.WalkSpeed = 16
        end
        task.wait(2)
    end
end)

-- AUTO SYSTEMS
task.spawn(function()
    while true do
        if Config.AutoLift then
            rs.rEvents.liftWeight:FireServer()
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoSell then
            rs.rEvents.sellStrength:FireServer()
        end
        task.wait(5)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoRebirth then
            pcall(function()
                rs.rEvents.rebirthRemote:InvokeServer()
            end)
        end
        task.wait(10)
    end
end)

-- KILL AURA
task.spawn(function()
    while true do
        if Config.AutoKills then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if dist < KillRange then
                        rs.rEvents.punchEvent:FireServer()
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

-- ZONAS + ROCAS
local zones = {
    {pos=Vector3.new(0,10,0),req=0},
    {pos=Vector3.new(-2600,20,-600),req=5000},
    {pos=Vector3.new(800,20,2500),req=50000},
    {pos=Vector3.new(-8600,20,-6000),req=500000}
}

local function strength()
    local s=player:FindFirstChild("leaderstats")
    return s and s:FindFirstChild("Strength") and s.Strength.Value or 0
end

local function bestZone()
    local s=strength()
    local best=zones[1]
    for _,z in pairs(zones) do
        if s>=z.req then best=z end
    end
    return best
end

task.spawn(function()
    while true do
        if Config.AutoZone then
            char:MoveTo(bestZone().pos)
        end
        task.wait(10)
    end
end)

task.spawn(function()
    while true do
        if Config.AutoRock or Config.AutoZone then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and v.Name:lower():find("rock") then
                    char:MoveTo(v.Position)
                    rs.rEvents.punchEvent:FireServer()
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.3)
    end
end)
