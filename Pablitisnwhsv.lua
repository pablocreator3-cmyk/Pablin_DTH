-- [[ ⚡ DTH HUB V18 - VERSIÓN ORO FINAL ⚡ ]]
-- Todo Incluido: Auto-Equip, Todas las Rocas, Todas las Islas, Lock Pos y Gifts.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando Versión Oro V18...",
   LoadingSubtitle = "Muscle Legends - Full Arsenal",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- [[ VARIABLES ]]
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

-- --- MOTOR MAESTRO (ACCIÓN Y BLOQUEO) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        
        -- AUTO FUERZA (PESAS) - EQUIPA Y LEVANTA SOLO
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

        -- AUTO PUÑO (PUNCH) - EQUIPA Y GOLPEA SOLO
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

        -- LOCK POSITION (CONGELAR)
        if getgenv().lockPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedCFrame
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- PESTAÑAS ---
local TabTrain = Window:CreateTab("Entrenamiento", 4483362458)
local TabRocks = Window:CreateTab("Rocas (TODAS)", 4483362458)
local TabTP = Window:CreateTab("Teleports (MAPA)", 4483362458)
local TabCombat = Window:CreateTab("Combate OP", 4483362458)
local TabGifts = Window:CreateTab("Regalos", 4483362458)
local TabMisc = Window:CreateTab("Misc & Lock", 4483362458)

-- 1. ENTRENAMIENTO
TabTrain:CreateSection("Auto-Equipar y Usar")
TabTrain:CreateToggle({
   Name = "Auto Fuerza (Pesa Automática)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})
TabTrain:CreateToggle({
   Name = "Auto Puño (Golpe Automático)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})

-- 2. ROCAS (LISTA COMPLETA - NO FALTA NINGUNA)
TabRocks:CreateSection("Rocas de Durabilidad")
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

AddRock("Tiny Island", 0); AddRock("Starter", 100); AddRock("Beach", 5000); 
AddRock("Diamond", 20000); AddRock("Frost", 150000); AddRock("Mythical", 400000); 
AddRock("Eternal", 750000); AddRock("Legend", 1000000); AddRock("Ancient Jungle", 10000000)

-- 3. TELEPORTS (MAPA COMPLETO)
TabTP:CreateSection("Viaje Instantáneo")
local locs = {
    ["Spawn Principal"] = CFrame.new(2, 8, 115),
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
    TabTP:CreateButton({ Name = "Ir a: " .. n, Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end })
end

-- 4. COMBATE (TP KILL)
TabCombat:CreateSection("Asesino")
TabCombat:CreateToggle({
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

-- 5. REGALOS (GIFTS)
TabGifts:CreateSection("Enviar Protein Eggs")
local names = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(names, p.DisplayName) end end
local target, amt = nil, 0

TabGifts:CreateDropdown({
   Name = "Elegir Jugador", Options = names, CurrentOption = {""},
   Callback = function(o) for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == o[1] then target = p end end end,
})
TabGifts:CreateInput({ Name = "Cantidad", Callback = function(t) amt = tonumber(t) or 0 end })
TabGifts:CreateButton({
   Name = "Regalar Ahora",
   Callback = function()
       if target and amt > 0 then
           for i = 1, amt do
               local itm = LocalPlayer.consumablesFolder:FindFirstChild("Protein Egg")
               if itm then ReplicatedStorage.rEvents.giftRemote:InvokeServer("giftRequest", target, itm); task.wait(0.1) end
           end
       end
   end,
})

-- 6. MISC & LOCK
TabMisc:CreateSection("Utilidades")
TabMisc:CreateToggle({
   Name = "Lock Position (Fijar personaje)",
   CurrentValue = false,
   Callback = function(v)
       if v then lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
       getgenv().lockPos = v
   end,
})

Rayfield:Notify({Title = "DTH HUB V18", Content = "Todo listo: Islas, Lock, Gifts y Auto-Equip.", Duration = 5})
