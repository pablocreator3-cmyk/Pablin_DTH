local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PABLO_DTH | Universal Combat",
   LoadingTitle = "Cargando Sistema...",
   LoadingSubtitle = "by Pablito",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PabloDTH_Settings"
   }
})

-- Variables Globales
local AimbotEnabled = false
local ESPEnabled = false
local TeamCheck = false
local AimPart = "Head" -- Por defecto a la cabeza
local Sensitivity = 0.15

-- Pestañas
local MainTab = Window:CreateTab("Combate", 4483362458)
local VisualsTab = Window:CreateTab("Visuales", 4483362458)

--- LÓGICA DEL AIMBOT ---
local function GetClosestPlayer()
    local MaximumDistance = math.huge
    local Target = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
            if TeamCheck and v.Team == game.Players.LocalPlayer.Team then continue end
            
            local ScreenPoint, OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character[AimPart].Position)
            if OnScreen then
                local Mouse = game.Players.LocalPlayer:GetMouse()
                local VectorDistance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                
                if VectorDistance < MaximumDistance then
                    Target = v
                    MaximumDistance = VectorDistance
                end
            end
        end
    end
    return Target
end

--- CONTROLES DE COMBATE ---

MainTab:CreateToggle({
   Name = "Activar Aimbot",
   CurrentValue = false,
   Callback = function(Value) AimbotEnabled = Value end,
})

MainTab:CreateDropdown({
   Name = "Apuntar a:",
   Options = {"Head", "UpperTorso"},
   CurrentOption = {"Head"},
   Callback = function(Option)
       AimPart = Option[1] == "Head" and "Head" or "UpperTorso"
   end,
})

MainTab:CreateToggle({
   Name = "Team Check (No amigos)",
   CurrentValue = false,
   Callback = function(Value) TeamCheck = Value end,
})

MainTab:CreateSlider({
   Name = "Suavizado (Smoothness)",
   Range = {0.05, 0.5},
   Increment = 0.05,
   Suffix = "S",
   CurrentValue = 0.15,
   Callback = function(Value) Sensitivity = Value end,
})

--- CONTROLES VISUALES (ESP) ---

VisualsTab:CreateToggle({
   Name = "ESP: Ver Jugadores",
   CurrentValue = false,
   Callback = function(Value) ESPEnabled = Value end,
})

--- BUCLES DE EJECUCIÓN ---

-- Bucle de Aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild(AimPart) then
            local Camera = game.Workspace.CurrentCamera
            -- Interpolación para movimiento suave
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character[AimPart].Position), Sensitivity)
        end
    end
end)

-- Bucle de ESP (Highlighter)
game:GetService("RunService").Heartbeat:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            local highlight = v.Character:FindFirstChild("DTH_ESP")
            
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "DTH_ESP"
                    highlight.Parent = v.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Rojo característico
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                end
                
                -- Ocultar si son del mismo equipo y el Team Check está activo
                if TeamCheck and v.Team == game.Players.LocalPlayer.Team then
                    highlight.Enabled = false
                else
                    highlight.Enabled = true
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

Rayfield:LoadConfiguration()
