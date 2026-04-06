-- [[ ⚡ DTH HUB V16 - VERSIÓN FINAL INTEGRADA ⚡ ]]
-- Todo en uno: Auto-Equip, Todas las Rocas, TP Kill, Lock Pos e Islas.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando Sistema Completo V16...",
   LoadingSubtitle = "Muscle Legends Edition",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ VARIABLES GLOBALES ]]
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().lockPos = false
getgenv().killRange = 150
local activeRock = ""
local lockedCFrame = nil

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR MAESTRO (ENTRENAMIENTO Y LOCK) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        
        -- AUTO PUÑO (EQUIPA Y GOLPEA)
        if getgenv().fastPunch then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                if tool then
                    if tool.Parent ~= char then tool.Parent = char end
                    ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end

        -- AUTO FUERZA (EQUIPA Y LEVANTA PC)
        if getgenv().fastWeight then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = LocalPlayer.Backpack:FindFirstChild("Weight") or char:FindFirstChild("Weight")
                if tool then
                    if tool.Parent ~= char then tool.Parent = char end
                    ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end

        -- LOCK POSITION
        if getgenv().lockPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedCFrame
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- PESTAÑAS ---
local TabTrain = Window:CreateTab("Entrenamiento", 4483362458)
local TabRocks = Window:CreateTab("Rocas (TODAS)", 4483362458)
local TabCombat = Window:CreateTab("Combate OP", 4483362458)
local TabTP = Window:CreateTab("Teleports", 4483362458)
local TabMisc = Window:CreateTab("Misc & Lock", 4483362458)

-- 1. PESTAÑA: ENTRENAMIENTO
TabTrain:CreateSection("Auto-Acción Híbrida")
TabTrain:CreateToggle({
   Name = "Auto Fast Punch (Auto-Equip)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})
TabTrain:CreateToggle({
   Name = "Auto Fast Fuerza (Auto-Equip)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

-- 2. PESTAÑA: ROCAS (LISTA COMPLETA SIN BORRAR NADA)
TabRocks:CreateSection("Lista de Durabilidad Total")
local function AddRock(name, dur)
    TabRocks:CreateToggle({
       Name = name .. " (" .. dur .. ")",
       CurrentValue = false,
       Callback = function(v)
           getgenv().autoFarm = v
           activeRock = name
           if v then
               task.spawn(function()
                   while getgenv().autoFarm and activeRock == name do
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
AddRock("Frost Gym Rock", 150000)
AddRock("Mythical Gym Rock", 400000)
AddRock("Eternal Gym Rock", 750000)
AddRock("Legend Gym Rock", 1000000)
AddRock("Ancient Jungle Rock", 10000000)

-- 3. PESTAÑA: COMBATE (TP KILL)
TabCombat:CreateSection("Killer Mode")
TabCombat:CreateToggle({
   Name = "TP Kill (Traer al frente)",
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

-- 4. PESTAÑA: TELEPORTS (TODAS LAS ISLAS)
TabTP:CreateSection("Mapa Completo")
local islandLocs = {
    ["Spawn"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Mythical Island"] = CFrame.new(2270, 15, 715),
    ["Eternal Island"] = CFrame.new(-6670, 15, -1350),
    ["Muscle King (Boss)"] = CFrame.new(-8646, 17, -5738)
}
for name, cf in pairs(islandLocs) do
    TabTP:CreateButton({
       Name = "Ir a: " .. name,
       Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end
    })
end

-- 5. PESTAÑA: MISC & LOCK
TabMisc:CreateSection("Utilidades Especiales")
TabMisc:CreateToggle({
   Name = "Lock Position (Congelar posición)",
   CurrentValue = false,
   Callback = function(v)
       if v then lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
       getgenv().lockPos = v
   end,
})

Rayfield:Notify({Title = "DTH HUB V16 FINAL", Content = "Todo integrado con éxito, Pablito.", Duration = 5})
