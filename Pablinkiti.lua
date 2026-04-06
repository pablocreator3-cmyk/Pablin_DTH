-- [[ ⚡ DTH HUB V13 - RESTAURACIÓN TOTAL DE ISLAS ⚡ ]]
-- Todas las Islas + Todas las Rocas + Auto-Equip + TP Kill

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Restaurando Mapa Completo...",
   LoadingSubtitle = "Muscle Legends - V13 Full",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Variables de Estado
getgenv().fastPunch = false
getgenv().fastWeight = false
getgenv().autoKill = false
getgenv().autoFarm = false
getgenv().killRange = 150
local activeRock = ""

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

-- --- MOTOR DE AUTO-EQUIPACIÓN Y ACCIÓN ---
task.spawn(function()
    while true do
        task.wait(0.01)
        if getgenv().fastPunch then
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
                if tool then
                    if tool.Parent ~= LocalPlayer.Character then tool.Parent = LocalPlayer.Character end
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    ReplicatedStorage.rEvents.punchEvent:FireServer("punchClick")
                end
            end)
        end
        if getgenv().fastWeight then
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild("Weight") or LocalPlayer.Character:FindFirstChild("Weight")
                if tool then
                    if tool.Parent ~= LocalPlayer.Character then tool.Parent = LocalPlayer.Character end
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    ReplicatedStorage.rEvents.weightEvent:FireServer("weightClick")
                end
            end)
        end
    end
end)

-- --- PESTAÑAS ---
local Tab1 = Window:CreateTab("Entrenamiento", 4483362458)
local Tab2 = Window:CreateTab("Rocas (Todas)", 4483362458)
local Tab3 = Window:CreateTab("Combate OP", 4483362458)
local Tab4 = Window:CreateTab("Teleports", 4483362458)
local Tab5 = Window:CreateTab("Regalos", 4483362458)

-- 1. ENTRENAMIENTO
Tab1:CreateSection("Auto-Equipar y Entrenar")
Tab1:CreateToggle({
   Name = "Auto Fast Punch (Saca el Puño)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})
Tab1:CreateToggle({
   Name = "Auto Fast Pesas (Saca la Pesa)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

-- 2. TODAS LAS ROCAS (LISTA RESTAURADA)
Tab2:CreateSection("Rocas de Durabilidad")
local function AddRock(name, dur)
    Tab2:CreateToggle({
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

-- 3. COMBATE OP
Tab3:CreateSection("Killer Mode")
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

-- 4. TELEPORTS (LISTA COMPLETA RESTAURADA)
Tab4:CreateSection("Todas las Islas y Zonas")
local islandLocs = {
    ["SpawnPrincipal"] = CFrame.new(2, 8, 115),
    ["Tiny Island"] = CFrame.new(-34, 7, 1903),
    ["Secret Island"] = CFrame.new(-2545, 15, -5385), -- ISLA SECRETA
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384),
    ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Frozen Island"] = CFrame.new(-2600, 4, -404),
    ["Mythical Island"] = CFrame.new(2270, 15, 715),
    ["Eternal Island"] = CFrame.new(-6670, 15, -1350),
    ["Muscle King (Boss)"] = CFrame.new(-8646, 17, -5738)
}

for name, cf in pairs(islandLocs) do
    Tab4:CreateButton({
       Name = "Viajar a: " .. name,
       Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = cf end
    })
end

-- 5. REGALOS
Tab5:CreateSection("Protein Eggs")
local pNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pNames, p.DisplayName) end end
local target, amt = nil, 0

Tab5:CreateDropdown({
   Name = "Jugador", Options = pNames, CurrentOption = {""},
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

Rayfield:Notify({Title = "DTH HUB V13", Content = "Islas, Rocas y Auto-Equip Restaurados.", Duration = 5})
