-- [[ ⚡ SÚPER DTH HUB - VERSIÓN TOTAL REPARADA ⚡ ]]
-- Autor: Pablito_DTH | Todo en uno.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Súper DTH Hub | By Pablito ⚡",
   LoadingTitle = "Cargando Todas las Funciones...",
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

-- --- BUCLES DE ENTRENAMIENTO (FONDO) ---
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

-- --- PESTAÑAS ---
local FarmTab = Window:CreateTab("Farm & Train", 4483362458)
local CombatTab = Window:CreateTab("Combat OP", 4483362458)
local TPTab = Window:CreateTab("Teleports", 4483362458)
local GiftTab = Window:CreateTab("Gifts", 4483362458)

-- --- SECCIÓN: ENTRENAMIENTO (FarmTab) ---
FarmTab:CreateSection("Fuerza y Tamaño")

FarmTab:CreateToggle({
   Name = "Auto Fast Punch (Equipa y Golpea)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastPunch = v end,
})

FarmTab:CreateToggle({
   Name = "Auto Fast Weight (Equipa y Levanta)",
   CurrentValue = false,
   Callback = function(v) getgenv().fastWeight = v end,
})

FarmTab:CreateSection("Rocas (Durabilidad)")

local function AddRock(name, dur)
    FarmTab:CreateToggle({
       Name = name .. " (" .. tostring(dur) .. ")",
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

AddRock("Tiny Island", 0); AddRock("Starter", 100); AddRock("Beach", 5000); 
AddRock("Frost", 150000); AddRock("Mythical", 400000); AddRock("Eternal", 750000); 
AddRock("Legend", 1000000); AddRock("Ancient Jungle", 10000000)

-- --- SECCIÓN: COMBATE (CombatTab) ---
CombatTab:CreateSection("Killer Aura")

CombatTab:CreateToggle({
   Name = "Mega Auto Kill (Rango)",
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
   Name = "Rango de Kill",
   Min = 50, Max = 500, CurrentValue = 150,
   Callback = function(v) getgenv().killRange = v end,
})

-- --- SECCIÓN: TELEPORTS (TPTab) ---
local locations = {
    ["Spawn"] = CFrame.new(2, 8, 115), ["Secret Area"] = CFrame.new(1947, 2, 6191),
    ["Muscle King"] = CFrame.new(-8646, 17, -5738), ["Legend Island"] = CFrame.new(4604, 991, -3887),
    ["Jungle Island"] = CFrame.new(-8659, 6, 2384)
}
for name, cf in pairs(locations) do
    TPTab:CreateButton({ Name = name, Callback = function() if LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = cf end end })
end

-- --- SECCIÓN: REGALOS (GiftTab) ---
local selectedTarget, eggAmount = nil, 0
local pNames = {}
for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(pNames, p.DisplayName) end end

GiftTab:CreateDropdown({
   Name = "Seleccionar Jugador",
   Options = pNames, CurrentOption = {""},
   Callback = function(Option)
       for _, p in ipairs(Players:GetPlayers()) do if p.DisplayName == Option[1] then selectedTarget = p end end
   end,
})

GiftTab:CreateInput({ Name = "Cantidad", Callback = function(t) eggAmount = tonumber(t) or 0 end })
GiftTab:CreateButton({
   Name = "Enviar Protein Eggs",
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

-- Seguridad
local p = Instance.new("Part", workspace)
p.Size, p.Position, p.Anchored, p.Transparency = Vector3.new(20000, 1, 20000), Vector3.new(0, -30, 0), true, 1

Rayfield:Notify({Title = "DTH HUB COMPLETO", Content = "Todas las pestañas y funciones listas.", Duration = 5})
