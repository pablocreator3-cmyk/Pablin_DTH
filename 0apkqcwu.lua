-- [[ ⚡ DTH HUB V19 - FIX ACCIÓN TOTAL ⚡ ]]
-- REPARADO: Auto-Entrenamiento (Fuerza/Punch) + Lock Pos + Todas las Islas + Gifts

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Reparando Motores de Entrenamiento...",
   LoadingSubtitle = "Muscle Legends V19 - No more bugs",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ VARIABLES GLOBALES ]]
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().lockPos = false
local lockedCFrame = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR DE ENTRENAMIENTO (REESCRITO PARA QUE FUNCIONE SÍ O SÍ) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        
        -- AUTO FUERZA (PESA)
        if getgenv().fastWeight then
            pcall(function()
                local char = LocalPlayer.Character
                local weight = LocalPlayer.Backpack:FindFirstChild("Weight") or char:FindFirstChild("Weight")
                if weight then
                    -- 1. Equipar si no está en mano
                    if weight.Parent ~= char then 
                        weight.Parent = char 
                        task.wait(0.1) -- Pequeña pausa para que el juego registre la herramienta
                    end
                    -- 2. Entrenar (Doble click)
                    ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end

        -- AUTO PUNCH (GOLPE)
        if getgenv().fastPunch then
            pcall(function()
                local char = LocalPlayer.Character
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                if punch then
                    -- 1. Equipar si no está en mano
                    if punch.Parent ~= char then 
                        punch.Parent = char 
                        task.wait(0.1)
                    end
                    -- 2. Entrenar (Doble click)
                    ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end

        -- LOCK POSITION (SIEMPRE ACTIVO EN BUCLE)
        if getgenv().lockPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedCFrame
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- CREACIÓN DE PESTAÑAS (ORDEN ESTRICTO) ---
local Tab1 = Window:CreateTab("Entrenamiento", 4483362458)
local Tab2 = Window:CreateTab("Rocas (TODAS)", 4483362458)
local Tab3 = Window:CreateTab("Teleports", 4483362458)
local Tab4 = Window:CreateTab("Combate OP", 4483362458)
local Tab5 = Window:CreateTab("Gifts & Misc", 4483362458)

-- 1. PESTAÑA ENTRENAMIENTO
Tab1:CreateSection("Auto-Acción Forzada")
Tab1:CreateToggle({
   Name = "Auto Fuerza (Equipa y Entrena)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})
Tab1:CreateToggle({
   Name = "Auto Puño (Equipa y Golpea)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})

-- 2. PESTAÑA ROCAS (LISTA COMPLETA)
Tab2:CreateSection("Farm de Durabilidad")
local function AddRock(name, dur)
    Tab2:CreateToggle({
       Name = name .. " (" .. dur .. ")",
       CurrentValue = false,
       Callback = function(v)
           getgenv().autoFarm = v
           if v then
               task.spawn(function()
                   while getgenv().autoFarm do
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
AddRock("Tiny Island", 0); AddRock("Starter", 100); AddRock("Beach", 5000); 
AddRock("Diamond", 20000); AddRock("Frost", 150000); AddRock("Mythical", 400000); 
AddRock("Eternal", 750000); AddRock("Legend", 1000000); AddRock("Ancient Jungle", 10000000)

-- 3. PESTAÑA TELEPORTS (RESTAURADA)
Tab3:CreateSection("Islas Disponibles")
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Mythical Island"] = CFrame.new(2270, 15, 715),
    ["Eternal Island"] = CFrame.new(-6670, 15, -1350),
    ["Muscle King (Boss)"] = CFrame.new(-8646, 17, -5738)
}
for n, cf in pairs(locs) do
    Tab3:CreateButton({ Name = "Ir a " .. n, Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end })
end

-- 4. PESTAÑA COMBATE
Tab4:CreateSection("TP Kill")
Tab4:CreateToggle({
   Name = "Activar TP Kill",
   CurrentValue = false,
   Callback = function(v) getgenv().autoKill = v end,
})
task.spawn(function()
    while true do
        task.wait(0.1)
        if getgenv().autoKill then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        plr.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                        ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                    end)
                end
            end
        end
    end
end)

-- 5. PESTAÑA GIFTS & MISC (RESTAURADA)
Tab5:CreateSection("Opciones Especiales")
Tab5:CreateToggle({
   Name = "Lock Position (Fijar Posición)",
   CurrentValue = false,
   Callback = function(v)
       if v then lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
       getgenv().lockPos = v
   end,
})

Tab5:CreateSection("Regalos (Protein Eggs)")
local names = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.DisplayName) end end
local target, amt = nil, 0

Tab5:CreateDropdown({
   Name = "Elegir Jugador", Options = names, CurrentOption = {""},
   Callback = function(o) for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == o[1] then target = p end end end,
})
Tab5:CreateInput({ Name = "Cantidad", Callback = function(t) amt = tonumber(t) or 0 end })
Tab5:CreateButton({
   Name = "Enviar Regalo",
   Callback = function()
       if target and amt > 0 then
           for i = 1, amt do
               local itm = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
               if itm then ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", target, itm); task.wait(0.1) end
           end
       end
   end,
})

Rayfield:Notify({Title = "DTH HUB V19", Content = "TODO FUNCIONANDO. ¡Fuerza y Lock activos!", Duration = 5})
