-- [[ ⚡ DTH HUB V10 - VERSIÓN DEFINITIVA Y COMPLETA ⚡ ]]
-- Todas las Rocas + Teleports + Gifts + AutoClick Híbrido

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando TODO el Arsenal...",
   LoadingSubtitle = "Muscle Legends - Versión Completa",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables Globales
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().killRange = 150
local currentRock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR DE ACCIÓN (SIEMPRE ACTIVO) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        -- Golpe Rápido + Click
        if getgenv().fastPunch then
            local tool = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
            if tool then 
                tool.Parent = LocalPlayer.Character
                VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                pcall(function() ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick") end)
            end
        end
        -- Pesas Rápidas + Click
        if getgenv().fastWeight then
            local tool = LocalPlayer.Backpack:FindFirstChild("Weight") or LocalPlayer.Character:FindFirstChild("Weight")
            if tool then 
                tool.Parent = LocalPlayer.Character
                VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                pcall(function() ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick") end)
            end
        end
        -- TP Kill (Traer al frente)
        if getgenv().autoKill then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < getgenv().killRange then
                        pcall(function()
                            plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                            ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                        end)
                    end
                end
            end
        end
    end
end)

-- --- PESTAÑAS ---
local TabTrain = Window:CreateTab("Entrenamiento", 4483362458)
local TabRocks = Window:CreateTab("Rocas (TODAS)", 4483362458)
local TabCombat = Window:CreateTab("Combate OP", 4483362458)
local TabTP = Window:CreateTab("Teleports", 4483362458)
local TabGift = Window:CreateTab("Regalos", 4483362458)

-- 1. PESTAÑA ENTRENAMIENTO
TabTrain:CreateSection("Fuerza e Incremento")
TabTrain:CreateToggle({
   Name = "Auto Fast Punch + AutoClick",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})
TabTrain:CreateToggle({
   Name = "Auto Fast Pesas + AutoClick",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

-- 2. PESTAÑA ROCAS (LISTA COMPLETA REINSTALADA)
TabRocks:CreateSection("Selecciona tu Roca")
local function AddRock(name, dur)
    TabRocks:CreateToggle({
       Name = name .. " (" .. dur .. ")",
       CurrentValue = false,
       Callback = function(v)
           getgenv().autoFarm = v
           currentRock = name
           if v then
               task.spawn(function()
                   while getgenv().autoFarm and currentRock == name do
                       task.wait(0.01)
                       pcall(function()
                           for _, m in pairs(workspace.machinesFolder:GetDescendants()) do
                               if m.Name == "neededDurability" and m.Value == dur then
                                   local r = m.Parent:FindFirstChild("Rock")
                                   if r and LocalPlayer.Character:FindFirstChild("RightHand") then
                                       firetouchinterest(r, LocalPlayer.Character.RightHand, 0)
                                       firetouchinterest(r, LocalPlayer.Character.RightHand, 1)
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
end

AddRock("Tiny Island", 0)
AddRock("Starter Rock", 100)
AddRock("Beach Rock", 5000)
AddRock("Diamond Rock", 20000)
AddRock("Frost Gym", 150000)
AddRock("Mythical Gym", 400000)
AddRock("Eternal Gym", 750000)
AddRock("Legend Gym", 1000000)
AddRock("Ancient Jungle", 10000000)

-- 3. PESTAÑA COMBATE
TabCombat:CreateSection("Killer Aura")
TabCombat:CreateToggle({
   Name = "TP Kill (Traer Jugadores)",
   CurrentValue = false,
   Callback = function(v) getgenv().autoKill = v end,
})
TabCombat:CreateSlider({
   Name = "Rango del Aura",
   Min = 50, Max = 500, CurrentValue = 150,
   Callback = function(v) getgenv().killRange = v end,
})

-- 4. PESTAÑA TELEPORTS
TabTP:CreateSection("Islas Disponibles")
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384)
}
for n, cf in pairs(locs) do
    TabTP:CreateButton({ Name = "Ir a " .. n, Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end })
end

-- 5. PESTAÑA REGALOS
TabGift:CreateSection("Envío Masivo de Protein Eggs")
local names = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.DisplayName) end end
local target, count = nil, 0

TabGift:CreateDropdown({
   Name = "Elegir Jugador", Options = names, CurrentOption = {""},
   Callback = function(o) for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == o[1] then target = p end end end,
})
TabGift:CreateInput({ Name = "Cantidad", Callback = function(t) count = tonumber(t) or 0 end })
TabGift:CreateButton({
   Name = "Regalar Ahora",
   Callback = function()
       if target and count > 0 then
           for i = 1, count do
               local itm = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
               if itm then ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", target, itm); task.wait(0.1) end
           end
       end
   end,
})

Rayfield:Notify({Title = "DTH HUB V10", Content = "Todo activado: Rocas, TP, Kill y Entrenamiento.", Duration = 5})
