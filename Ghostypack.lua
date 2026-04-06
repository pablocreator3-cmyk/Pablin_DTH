-- [[ ⚡ SÚPER DTH HUB - MEGA RANGE AUTO KILL ⚡ ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Configurando Rango Máximo...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables de Control
getgenv().autoKill = false
getgenv().killRange = 150 -- AQUÍ PUEDES SUBIR EL RANGO (Ejemplo: 200, 300)
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoFarm = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- --- FUNCIÓN DE EQUIPACIÓN ---
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

-- --- BUCLES DE ENTRENAMIENTO ---
task.spawn(function()
    while true do
        task.wait(0.01)
        if getgenv().fastPunch then
            equipTool("Punch")
            ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
        end
        if getgenv().fastWeight then
            equipTool("Weight")
            ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
        end
    end
end)

-- Pestañas
local MainTab = Window:CreateTab("Farm & Train", 4483362458) 
local CombatTab = Window:CreateTab("Combat OP", 4483362458)
local TPTab = Window:CreateTab("TP Areas", 4483362458)

-- --- SECCIÓN: COMBATE (MEGA AUTO KILL) ---
CombatTab:CreateSection("Aura de Muerte")

CombatTab:CreateToggle({
   Name = "Mega Auto Kill (Rango Extendido)",
   CurrentValue = false,
   Callback = function(Value)
       getgenv().autoKill = Value
       if Value then
           task.spawn(function()
               while getgenv().autoKill do
                   task.wait(0.01) -- Velocidad de escaneo rápida
                   pcall(function()
                       for _, plr in pairs(Players:GetPlayers()) do
                           if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                               local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                               
                               if dist < getgenv().killRange then
                                   -- Si está en el rango, lo masacra
                                   equipTool("Punch")
                                   local char = LocalPlayer.Character
                                   -- Firetouch para daño físico masivo a distancia
                                   firetouchinterest(plr.Character.HumanoidRootPart, char.RightHand, 0)
                                   firetouchinterest(plr.Character.HumanoidRootPart, char.RightHand, 1)
                                   firetouchinterest(plr.Character.HumanoidRootPart, char.LeftHand, 0)
                                   firetouchinterest(plr.Character.HumanoidRootPart, char.LeftHand, 1)
                                   -- Remote para asegurar el hit
                                   ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
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
   Name = "Ajustar Rango de Matanza",
   Min = 50,
   Max = 500,
   CurrentValue = 150,
   Flag = "RangeSlider",
   Callback = function(Value)
       getgenv().killRange = Value
   end,
})

-- --- SECCIÓN: ROCAS (CORREGIDAS) ---
MainTab:CreateSection("Rocas (Durabilidad)")

local function AddRock(name, dur)
    MainTab:CreateToggle({
       Name = name,
       CurrentValue = false,
       Callback = function(Value)
           getgenv().autoFarm = Value
           if Value then
               equipTool("Punch")
               task.spawn(function()
                   while getgenv().autoFarm do
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

AddRock("Tiny Island (0)", 0)
AddRock("Starter (100)", 100)
AddRock("Beach (5k)", 5000)
AddRock("Frost (150k)", 150000)
AddRock("Ancient Jungle (10M)", 10000000)

-- Teletransporte
TPTab:CreateButton({Name = "Spawn", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2, 8, 115) end})
TPTab:CreateButton({Name = "Muscle King", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8646, 17, -5738) end})

Rayfield:Notify({Title = "RANGO ACTUALIZADO", Content = "Auto Kill configurado con Mega Rango.", Duration = 5})
