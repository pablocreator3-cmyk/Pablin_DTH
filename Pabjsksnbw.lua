-- [[ ⚡ SÚPER DTH HUB - VERSIÓN TOTAL REPARADA ⚡ ]]
-- Todo funcionando: Fast Punch, Weight, Rocks (Todas), Kill, TP y Gifts.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Restaurando Todo el Sistema...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables Globales (Estado)
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().killRange = 150
getgenv().autoFarm = false
local selectrock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- FUNCIÓN DE EQUIPACIÓN AUTOMÁTICA ---
local function equip(name)
    local char = LocalPlayer.Character
    if char then
        local tool = LocalPlayer.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
        if tool and tool.Parent ~= char then
            tool.Parent = char
        end
        return tool
    end
end

-- --- BUCLE MAESTRO: FAST PUNCH Y WEIGHT ---
task.spawn(function()
    while true do
        task.wait(0.01)
        if getgenv().fastPunch then
            equip("Punch")
            pcall(function() 
                ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick") 
            end)
        end
        if getgenv().fastWeight then
            equip("Weight")
            pcall(function() 
                ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick") 
            end)
        end
    end
end)

-- --- PESTAÑAS (ORDENADAS) ---
local FarmTab = Window:CreateTab("Farm & Train", 4483362458)
local CombatTab = Window:CreateTab("Combat OP", 4483362458)
local TPTab = Window:CreateTab("Teleports", 4483362458)
local GiftTab = Window:CreateTab("Gifts", 4483362458)

-- --- PESTAÑA 1: FARM & TRAINING ---
FarmTab:CreateSection("Entrenamiento Rápido")

FarmTab:CreateToggle({
   Name = "Auto Fast Punch (Fuerza)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})

FarmTab:CreateToggle({
   Name = "Auto Fast Weight (Pesas)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

FarmTab:CreateSection("Todas las Rocas (Durabilidad)")

local function AddRock(name, dur)
    FarmTab:CreateToggle({
       Name = name .. " (" .. tostring(dur) .. ")",
       CurrentValue = false,
       Callback = function(Value)
           getgenv().autoFarm = Value
           selectrock = name
           if Value then
               task.spawn(function()
                   while getgenv().autoFarm and selectrock == name do
                       task.wait(0.01)
                       pcall(function()
                           if LocalPlayer.Durability.Value >= dur then
                               for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                                   if v.Name == "neededDurability" and v.Value == dur then
                                       local rock = v.Parent:FindFirstChild("Rock")
                                       if rock and LocalPlayer.Character:FindFirstChild("RightHand") then
                                           firetouchinterest(rock, LocalPlayer.Character.RightHand, 0)
                                           firetouchinterest(rock, LocalPlayer.Character.RightHand, 1)
                                           ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                                       end
                                   end
                               end
                           end
                       end)
                   end
               end)
           end
       end,
    })
end

-- Lista completa de rocas restaurada
AddRock("Tiny Island", 0); AddRock("Starter Island", 100); AddRock("Beach Rock", 5000)
AddRock("Frost Gym", 150000); AddRock("Mythical Gym", 400000); AddRock("Eternal Gym", 750000)
AddRock("Legend Gym", 1000000); AddRock("Ancient Jungle", 10000000)

-- --- PESTAÑA 2: COMBATE ---
CombatTab:CreateSection("Killer Aura")

CombatTab:CreateToggle({
   Name = "Mega Auto Kill (Rango)",
   CurrentValue = false,
   Callback = function(Value) getgenv().autoKill = Value end,
})

task.spawn(function()
    while true do
        task.wait(0.05)
        if getgenv().autoKill then
            pcall(function()
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if dist < getgenv().killRange then
                            equip("Punch")
                            firetouchinterest(plr.Character.HumanoidRootPart, LocalPlayer.Character.RightHand, 0)
                            firetouchinterest(plr.Character.HumanoidRootPart, LocalPlayer.Character.RightHand, 1)
                        end
                    end
                end
            end)
        end
    end
end)

CombatTab:CreateSlider({
   Name = "Rango de Matanza",
   Min = 50, Max = 500, CurrentValue = 150,
   Callback = function(v) getgenv().killRange = v end,
})

-- --- PESTAÑA 3: TELEPORTS (RESTAURADOS) ---
TPTab:CreateSection("Viaje Instantáneo")

local zones = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Secret Area"] = CFrame.new(1947, 2, 6191),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384)
}

for name, cf in pairs(zones) do
    TPTab:CreateButton({
       Name = "Ir a: " .. name,
       Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end
    })
end

-- --- PESTAÑA 4: GIFTS (RESTAURADOS) ---
GiftTab:CreateSection("Enviar Regalos")

local targetPlayer, eggAmount = nil, 0
local pNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pNames, p.DisplayName) end end

GiftTab:CreateDropdown({
   Name = "Seleccionar Jugador",
   Options = pNames,
   CurrentOption = {""},
   Callback = function(Option)
       for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == Option[1] then targetPlayer = p end end
   end,
})

GiftTab:CreateInput({
   Name = "Cantidad",
   Callback = function(t) eggAmount = tonumber(t) or 0 end,
})

GiftTab:CreateButton({
   Name = "Regalar Protein Eggs",
   Callback = function()
       if targetPlayer and eggAmount > 0 then
           for i = 1, eggAmount do
               local item = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
               if item then 
                   ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", targetPlayer, item)
                   task.wait(0.1)
               end
           end
       end
   end,
})

Rayfield:Notify({Title = "DTH HUB COMPLETO", Content = "Todo restaurado: Fast, Rocks, TP y Gifts.", Duration = 5})
