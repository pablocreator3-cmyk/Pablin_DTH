-- [[ ⚡ DTH HUB V11 - VERSIÓN ULTRA ESTABLE ⚡ ]]
-- REPARADO: Fast Punch, Fast Weight, Teleports, Gifts y TODAS las Rocas.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando TODO el Arsenal...",
   LoadingSubtitle = "Muscle Legends - Fix Final",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ VARIABLES DE ESTADO ]]
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().killRange = 150
local selectedRock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR DE EJECUCIÓN (REPARADO Y SEPARADO) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        
        -- AUTO FAST PUNCH (REPARADO)
        if getgenv().fastPunch then
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
                if tool then
                    tool.Parent = LocalPlayer.Character
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                end
            end)
        end

        -- AUTO FAST WEIGHT (REPARADO)
        if getgenv().fastWeight then
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Weight") or LocalPlayer.Character:FindFirstChild("Weight")
                if tool then
                    tool.Parent = LocalPlayer.Character
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
                end
            end)
        end

        -- TP KILL (ACTIVO)
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

-- --- CREACIÓN DE PESTAÑAS (ORDEN ASEGURADO) ---
local Tab1 = Window:CreateTab("Entrenamiento", 4483362458)
local Tab2 = Window:CreateTab("Rocas (Todas)", 4483362458)
local Tab3 = Window:CreateTab("Combate OP", 4483362458)
local Tab4 = Window:CreateTab("Teleports", 4483362458)
local Tab5 = Window:CreateTab("Regalos", 4483362458)

-- 1. ENTRENAMIENTO
Tab1:CreateSection("Fuerza y Tamaño")
Tab1:CreateToggle({
   Name = "Auto Fast Punch + AutoClick",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})
Tab1:CreateToggle({
   Name = "Auto Fast Fuerza (Pesas)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

-- 2. TODAS LAS ROCAS (LISTA COMPLETA)
Tab2:CreateSection("Selecciona tu Roca de Entrenamiento")
local function AddRock(name, dur)
    Tab2:CreateToggle({
       Name = name .. " (" .. dur .. ")",
       CurrentValue = false,
       Callback = function(v)
           getgenv().autoFarm = v
           selectedRock = name
           if v then
               task.spawn(function()
                   while getgenv().autoFarm and selectedRock == name do
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

AddRock("Tiny Island", 0); AddRock("Starter Rock", 100); AddRock("Beach Rock", 5000)
AddRock("Diamond Rock", 20000); AddRock("Frost Gym", 150000); AddRock("Mythical Gym", 400000)
AddRock("Eternal Gym", 750000); AddRock("Legend Gym", 1000000); AddRock("Ancient Jungle", 10000000)

-- 3. COMBATE
Tab3:CreateSection("Killer Aura")
Tab3:CreateToggle({
   Name = "TP Kill (Traer Jugadores)",
   CurrentValue = false,
   Callback = function(v) getgenv().autoKill = v end,
})
Tab3:CreateSlider({
   Name = "Rango de Detección",
   Min = 50, Max = 500, CurrentValue = 150,
   Callback = function(v) getgenv().killRange = v end,
})

-- 4. TELEPORTS (REPARADO)
Tab4:CreateSection("Islas Disponibles")
local zones = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903)
}
for n, cf in pairs(zones) do
    Tab4:CreateButton({
       Name = "Teleport a " .. n,
       Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end
    })
end

-- 5. REGALOS
Tab5:CreateSection("Envío de Protein Eggs")
local pNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pNames, p.DisplayName) end end
local target, amt = nil, 0

Tab5:CreateDropdown({
   Name = "Elegir Jugador", Options = pNames, CurrentOption = {""},
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

Rayfield:Notify({Title = "DTH HUB V11", Content = "TODO FUNCIONANDO: Fast, TP y Rocas.", Duration = 5})
