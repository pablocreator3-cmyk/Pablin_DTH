-- [[ ⚡ SÚPER DTH HUB - FULL UNIFIED ⚡ ]]
-- Autor: Pablito_DTH
-- Sistema: Auto-Equip, Fast Punch, Fast Weight, Rocks (0-10M), Kill, TP & Gift.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando Arsenal de Pablito...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables Globales
getgenv().autoFarm = false
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
local selectrock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- FUNCIÓN MAESTRA: EQUIPAR Y ENTRENAR ---
local function autoTrain(toolName, eventName, remoteName)
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
    if tool then
        if tool.Parent ~= char then
            tool.Parent = char
        end
        tool:Activate()
        ReplicatedStorage.rEvents[eventName]:FireServer(remoteName)
    end
end

-- Tabs
local MainTab = Window:CreateTab("Farm & Train", 4483362458) 
local CombatTab = Window:CreateTab("Combat OP", 4483362458)
local TPTab = Window:CreateTab("TP Areas", 4483362458)
local GiftTab = Window:CreateTab("Gift System", 4483362458)

-- --- SECCIÓN: FAST TRAINING ---
MainTab:CreateSection("Entrenamiento Rápido")

MainTab:CreateToggle({
   Name = "Auto Fast Punch (Fuerza)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().fastPunch = Value
       if Value then
           task.spawn(function()
               while getgenv().fastPunch do
                   task.wait()
                   autoTrain("Punch", "punchEvent", "punchClick")
               end
           end)
       end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Fast Weight (Pesas)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().fastWeight = Value
       if Value then
           task.spawn(function()
               while getgenv().fastWeight do
                   task.wait()
                   autoTrain("Weight", "weightEvent", "weightClick")
               end
           end)
       end
   end,
})

-- --- SECCIÓN: AUTO FARM ROCKS (INTEGRADO CON FAST PUNCH) ---
MainTab:CreateSection("Rocas (Durabilidad)")

local function AddRock(name, dur)
    MainTab:CreateToggle({
       Name = name .. " (" .. tostring(dur) .. ")",
       CurrentValue = false,
       Callback = function(Value)
           getgenv().autoFarm = Value
           selectrock = name
           if Value then
               task.spawn(function()
                   while getgenv().autoFarm and selectrock == name do
                       task.wait()
                       if LocalPlayer.Durability.Value >= dur then
                           for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                               if v.Name == "neededDurability" and v.Value == dur then
                                   local char = LocalPlayer.Character
                                   if char and char:FindFirstChild("RightHand") then
                                       -- Toca la roca
                                       firetouchinterest(v.Parent.Rock, char.RightHand, 0)
                                       firetouchinterest(v.Parent.Rock, char.RightHand, 1)
                                       -- Golpea automáticamente para ganar durabilidad rápido
                                       autoTrain("Punch", "punchEvent", "punchClick")
                                   end
                               end
                           end
                       end
                   end
               end)
           end
       end,
    })
end

-- Lista de todas tus rocas
AddRock("Tiny Island", 0); AddRock("Starter Island", 100); AddRock("Beach Rock", 5000)
AddRock("Frost Gym", 150000); AddRock("Mythical Gym", 400000); AddRock("Eternal Gym", 750000)
AddRock("Legend Gym", 1000000); AddRock("Ancient Jungle", 10000000)

-- --- SECCIÓN: COMBATE & AUTO KILL ---
CombatTab:CreateToggle({
   Name = "Auto Kill Cercanos",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().autoKill = Value
       if Value then
           task.spawn(function()
               while getgenv().autoKill do
                   task.wait(0.01)
                   pcall(function()
                       for _, plr in pairs(Players:GetPlayers()) do
                           if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                               local distance = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                               if distance < 50 then
                                   autoTrain("Punch", "punchEvent", "punchClick")
                                   firetouchinterest(plr.Character.HumanoidRootPart, LocalPlayer.Character.RightHand, 0)
                                   firetouchinterest(plr.Character.HumanoidRootPart, LocalPlayer.Character.RightHand, 1)
                               end
                           end
                       end
                   end)
               end
           end)
       end
   end,
})

-- --- SECCIÓN: TELEPORTS & GIFT ---
local locations = {
    ["Spawn"] = CFrame.new(2, 8, 115), ["Secret Area"] = CFrame.new(1947, 2, 6191),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738), ["Legend Island"] = CFrame.new(4604, 991, -3887)
}
for name, cf in pairs(locations) do
    TPTab:CreateButton({ Name = "Ir a: " .. name, Callback = function() if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = cf end end })
end

local selectedTarget, eggAmount = nil, 0
local playerNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(playerNames, p.DisplayName) end end

GiftTab:CreateDropdown({
   Name = "Seleccionar Jugador",
   Options = playerNames,
   CurrentOption = {""},
   Callback = function(Option)
       for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == Option[1] then selectedTarget = p end end
   end,
})

GiftTab:CreateInput({ Name = "Cantidad", Callback = function(Text) eggAmount = tonumber(Text) or 0 end })
GiftTab:CreateButton({
   Name = "Regalar Protein Eggs",
   Callback = function()
       if selectedTarget and eggAmount > 0 then
           for i = 1, eggAmount do
               local item = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
               if item then 
                   ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", selectedTarget, item)
                   task.wait(0.1)
               else break end
           end
       end
   end,
})

-- Plataforma de seguridad
local p = Instance.new("Part", workspace)
p.Size, p.Position, p.Anchored, p.Transparency = Vector3.new(20000, 1, 20000), Vector3.new(0, -20, 0), true, 1

Rayfield:Notify({ Title = "DTH HUB COMPLETO", Content = "Fast Punch integrado en Rocas y Entrenamiento.", Duration = 5 })
