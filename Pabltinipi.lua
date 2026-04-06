-- [[ ⚡ SÚPER DTH HUB - VERSIÓN FINAL REPARADA ⚡ ]]
-- Autor: Pablito_DTH | Todo en uno: Fast, Rocks, Kill, TP y Gift.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando Sistema Completo...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables Globales
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().killRange = 150
getgenv().autoFarm = false
local selectrock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- FUNCIÓN DE EQUIPACIÓN SEGURA ---
local function equipTool(name)
    local char = LocalPlayer.Character
    if char then
        local tool = LocalPlayer.Backpack:FindFirstChild(name) or char:FindFirstChild(name)
        if tool and tool.Parent ~= char then
            tool.Parent = char
        end
        return tool
    end
end

-- --- BUCLES DE ENTRENAMIENTO (OPTIMIZADOS) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        if getgenv().fastPunch then
            equipTool("Punch")
            pcall(function() ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick") end)
        end
        if getgenv().fastWeight then
            equipTool("Weight")
            pcall(function() ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick") end)
        end
    end
end)

-- --- CREACIÓN DE PESTAÑAS ---
local FarmTab = Window:CreateTab("Farm & Train", 4483362458)
local CombatTab = Window:CreateTab("Combat OP", 4483362458)
local TPTab = Window:CreateTab("Teleports", 4483362458)
local GiftTab = Window:CreateTab("Gifts", 4483362458)

-- --- PESTAÑA: FARM & TRAIN ---
FarmTab:CreateSection("Auto Entrenamiento")

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

FarmTab:CreateSection("Rocas (Durabilidad)")

local function AddRock(name, dur)
    FarmTab:CreateToggle({
       Name = name,
       CurrentValue = false,
       Callback = function(Value)
           getgenv().autoFarm = Value
           selectrock = name
           if Value then
               task.spawn(function()
                   while getgenv().autoFarm and selectrock == name do
                       task.wait(0.02)
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

AddRock("Starter (100)", 100); AddRock("Beach (5k)", 5000); AddRock("Frost (150k)", 150000); AddRock("Ancient Jungle (10M)", 10000000)

-- --- PESTAÑA: COMBATE ---
CombatTab:CreateSection("Aura Asesina")

CombatTab:CreateToggle({
   Name = "Auto Kill Cercanos",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().autoKill = Value
       if Value then
           task.spawn(function()
               while getgenv().autoKill do
                   task.wait(0.02)
                   pcall(function()
                       for _, plr in pairs(Players:GetPlayers()) do
                           if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                               local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                               if dist < getgenv().killRange then
                                   equipTool("Punch")
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

CombatTab:CreateSlider({
   Name = "Rango de Matanza",
   Min = 50, Max = 500, CurrentValue = 150,
   Callback = function(v) getgenv().killRange = v end,
})

-- --- PESTAÑA: TELEPORTS (REGRESARON) ---
TPTab:CreateSection("Islas y Zonas")

local locations = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Secret Area"] = CFrame.new(1947, 2, 6191),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404)
}

for name, cf in pairs(locations) do
    TPTab:CreateButton({
       Name = "Ir a: " .. name,
       Callback = function()
           if LocalPlayer.Character then
               LocalPlayer.Character.HumanoidRootPart.CFrame = cf
           end
       end,
    })
end

-- --- PESTAÑA: GIFTS (REGRESARON) ---
GiftTab:CreateSection("Enviar Regalos")

local selectedTarget, eggAmount = nil, 0
local pNames = {}

-- Función para actualizar lista de jugadores
local function updatePlayers()
    pNames = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(pNames, p.DisplayName) end
    end
end
updatePlayers()

local GiftDropdown = GiftTab:CreateDropdown({
   Name = "Seleccionar Jugador",
   Options = pNames,
   CurrentOption = {""},
   Callback = function(Option)
       for _, p in ipairs(Players:GetPlayers()) do
           if p.DisplayName == Option[1] then selectedTarget = p end
       end
   end,
})

GiftTab:CreateInput({
   Name = "Cantidad de Eggs",
   PlaceholderText = "Ej: 10",
   Callback = function(t) eggAmount = tonumber(t) or 0 end,
})

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

-- Botón para refrescar jugadores si no aparecen
GiftTab:CreateButton({
   Name = "Actualizar Lista de Jugadores",
   Callback = function()
       updatePlayers()
       GiftDropdown:Set(pNames)
   end,
})

Rayfield:Notify({Title = "DTH HUB COMPLETO", Content = "Fast Punch, TP y Gifts restaurados.", Duration = 5})
