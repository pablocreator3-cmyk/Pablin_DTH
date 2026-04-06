-- [[ ⚡ SÚPER DTH HUB - FULL AUTO TRAIN ⚡ ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Optimizando Entrenamiento...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables Globales
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoFarm = false
local selectrock = ""
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- FUNCIÓN DE AUTO-EQUIPAR Y ACTIVAR ---
local function autoEquipAndUse(toolName, eventName, remoteName)
    local char = LocalPlayer.Character
    if not char then return end
    
    local tool = LocalPlayer.Backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
    if tool then
        -- Equipa si no está en la mano
        if tool.Parent ~= char then
            tool.Parent = char
        end
        -- Ejecuta la acción (Click Rápido)
        tool:Activate()
        ReplicatedStorage.rEvents[eventName]:FireServer(remoteName)
    end
end

-- Tabs
local MainTab = Window:CreateTab("Farm & Train", 4483362458) 

-- --- SECCIÓN: ENTRENAMIENTO RÁPIDO ---
MainTab:CreateSection("Auto Fuerza & Tamaño")

MainTab:CreateToggle({
   Name = "Auto Fast Punch (Equipa y Golpea)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().fastPunch = Value
       if Value then
           task.spawn(function()
               while getgenv().fastPunch do
                   task.wait()
                   autoEquipAndUse("Punch", "punchEvent", "punchClick")
               end
           end)
       end
   end,
})

MainTab:CreateToggle({
   Name = "Auto Fast Weight (Equipa y Levanta)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().fastWeight = Value
       if Value then
           task.spawn(function()
               while getgenv().fastWeight do
                   task.wait()
                   autoEquipAndUse("Weight", "weightEvent", "weightClick")
               end
           end)
       end
   end,
})

-- --- SECCIÓN: ROCAS (DURABILIDAD) ---
MainTab:CreateSection("Auto Rocas")

local function AddRock(name, dur)
    MainTab:CreateToggle({
       Name = name,
       CurrentValue = false,
       Callback = function(Value)
           getgenv().autoFarm = Value
           selectrock = name
           if Value then
               task.spawn(function()
                   while getgenv().autoFarm and selectrock == name do
                       task.wait()
                       pcall(function()
                           if LocalPlayer.Durability.Value >= dur then
                               for _, v in pairs(workspace.machinesFolder:GetDescendants()) do
                                   if v.Name == "neededDurability" and v.Value == dur then
                                       local char = LocalPlayer.Character
                                       if char and char:FindFirstChild("RightHand") then
                                           -- Toca la roca
                                           firetouchinterest(v.Parent.Rock, char.RightHand, 0)
                                           firetouchinterest(v.Parent.Rock, char.RightHand, 1)
                                           -- Asegura que el puño esté equipado para registrar el golpe
                                           autoEquipAndUse("Punch", "punchEvent", "punchClick")
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

-- Lista rápida de rocas (puedes añadir las otras siguiendo el mismo formato)
AddRock("Starter Island (100)", 100)
AddRock("Beach (5k)", 5000)
AddRock("Frost (150k)", 150000)
AddRock("Legend (1M)", 1000000)
AddRock("Ancient Jungle (10M)", 10000000)

Rayfield:Notify({
   Title = "TODO LISTO",
   Content = "Las pesas y el puño ahora se equipan solos al activar el toggle.",
   Duration = 5
})
