-- [[ ⚡ DTH HUB V14 - FIX TOTAL & LOCK POSITION ⚡ ]]
-- Reparado: Auto Fuerza, Auto Puño. Nuevo: Lock Position.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Reparando Motores de Fuerza...",
   LoadingSubtitle = "Muscle Legends - V14 Pro",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables de Estado
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

-- --- MOTOR DE FUERZA Y PUÑO (REESCRITO) ---
task.spawn(function()
    while true do
        task.wait(0.01)
        
        -- AUTO PUÑO (FIXED)
        if getgenv().fastPunch then
            pcall(function()
                local char = LocalPlayer.Character
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or char:FindFirstChild("Punch")
                if punch then
                    punch.Parent = char
                    -- Usamos una combinación de Click Remoto y Click de Pantalla
                    ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                    VirtualUser:ClickButton1(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end

        -- AUTO FUERZA (FIXED)
        if getgenv().fastWeight then
            pcall(function()
                local char = LocalPlayer.Character
                local weight = LocalPlayer.Backpack:FindFirstChild("Weight") or char:FindFirstChild("Weight")
                if weight then
                    weight.Parent = char
                    -- Evento directo de pesas
                    ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
                    VirtualUser:ClickButton1(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
        
        -- LOCK POSITION (NUEVO)
        if getgenv().lockPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = lockedCFrame
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- --- PESTAÑAS ---
local Tab1 = Window:CreateTab("Entrenamiento", 4483362458)
local Tab2 = Window:CreateTab("Rocas (Todas)", 4483362458)
local Tab3 = Window:CreateTab("Combate OP", 4483362458)
local Tab4 = Window:CreateTab("Teleports", 4483362458)
local Tab5 = Window:CreateTab("Misc & Lock", 4483362458)

-- 1. ENTRENAMIENTO
Tab1:CreateSection("Reparación de Fuerza")
Tab1:CreateToggle({
   Name = "Auto Fast Punch (Reparado)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})
Tab1:CreateToggle({
   Name = "Auto Fast Pesas (Reparado)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

-- 2. ROCAS
Tab2:CreateSection("Auto Durabilidad")
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
AddRock("Diamond", 20000); AddRock("Frost", 150000); AddRock("Ancient Jungle", 10000000)

-- 3. COMBATE
Tab3:CreateSection("Killer Aura")
Tab3:CreateToggle({
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

-- 4. TELEPORTS
Tab4:CreateSection("Islas y Zonas")
local locs = {
    ["Spawn"] = CFrame.new(2, 8, 115), ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385), ["Jungle"] = CFrame.new(-8659, 6, 2384),
    ["Legend"] = CFrame.new(4604, 991, -3887), ["Muscle King"] = CFrame.new(-8646, 17, -5738)
}
for n, cf in pairs(locs) do
    Tab4:CreateButton({ Name = "Ir a " .. n, Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end })
end

-- 5. MISC & LOCK (NUEVO)
Tab5:CreateSection("Utilidades")
Tab5:CreateToggle({
   Name = "Lock Position (Congelar)",
   CurrentValue = false,
   Callback = function(v)
       if v then
           lockedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
       end
       getgenv().lockPos = v
   end,
})

Tab5:CreateButton({
   Name = "Enviar Protein Eggs (Dropdown en Regalos)",
   Callback = function() Rayfield:Notify({Title = "Info", Content = "Usa la pestaña Regalos para enviar Eggs.", Duration = 3}) end
})

Rayfield:Notify({Title = "DTH HUB V14", Content = "Fuerza Reparada y Lock Position añadido.", Duration = 5})
