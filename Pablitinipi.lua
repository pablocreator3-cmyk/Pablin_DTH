local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "PABLO_DTH Hub",
   LoadingTitle = "Cargando Módulos...",
   LoadingSubtitle = "by Pablo",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PabloDTH_Config"
   }
})

-- Pestañas
local CombatTab = Window:CreateTab("Combate", 4483362458)
local VisualsTab = Window:CreateTab("Visuales", 4483362458)

-- Variables de Estado
local AimbotEnabled = false
local TeamCheck = false
local AimPart = "Head"
local ESPEnabled = false
local Sensitivity = 0.2

-- Función para obtener el jugador más cercano
local function GetClosestPlayer()
    local MaximumDistance = math.huge
    local Target = nil

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if TeamCheck and v.Team == game.Players.LocalPlayer.Team then continue end
            
            local ScreenPoint, OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
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

--- SECCIÓN DE COMBATE ---

CombatTab:CreateToggle({
   Name = "Activar Aimbot",
   CurrentValue = false,
   Callback = function(Value) AimbotEnabled = Value end,
})

CombatTab:CreateToggle({
   Name = "Team Check (Ignorar Equipo)",
   CurrentValue = false,
   Callback = function(Value) TeamCheck = Value end,
})

CombatTab:CreateDropdown({
   Name = "Objetivo del Aim",
   Options = {"Head", "UpperTorso"},
   CurrentOption = {"Head"},
   Callback = function(Option) AimPart = Option[1] end,
})

--- SECCIÓN DE VISUALES (ESP) ---

VisualsTab:CreateToggle({
   Name = "Ver Jugadores (ESP)",
   CurrentValue = false,
   Callback = function(Value)
      ESPEnabled = Value
   end,
})

-- Bucle de Aimbot
game:GetService("RunService").RenderStepped:Connect(function()
    if AimbotEnabled then
        local Target = GetClosestPlayer()
        if Target and Target.Character and Target.Character:FindFirstChild(AimPart) then
            local Camera = game.Workspace.CurrentCamera
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, Target.Character[AimPart].Position), Sensitivity)
        end
    end
end)

-- Bucle de ESP (Highlight)
game:GetService("RunService").Heartbeat:Connect(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            local highlight = v.Character:FindFirstChild("DTH_ESP")
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "DTH_ESP"
                    highlight.Parent = v.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Rojo
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
                -- Si el Team Check está activo, ocultar amigos
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
