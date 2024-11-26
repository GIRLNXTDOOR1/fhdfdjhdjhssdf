getgenv().Pentagonist = {
    ['KOCheck'] = true,
    ['Silent Aim'] = {
        ['Enabled'] = true,
        ['Prediction'] = 0.122,
        ['Part'] = "HumanoidRootPart",
        ['EnableJumpPart'] = true,
        ['JumpPart'] = "Head",
        ['Sync Camlock'] = true,
        ['Field Of View'] = {
            ['Visible'] = true,
            ['Color'] = Color3.new(255, 255, 255),
            ['Radius'] = 180,
            ['Transparency'] = 0.07
        },
    },
    ['Camlock'] = {
        ['Enabled'] = true,
        ['Keybind'] = "Q",
        ['Prediction'] = 0.122,
        ['Part'] = "HumanoidRootPart",
        ['Key'] = "Q",
        ['EnableJumpPart'] = true,
        ['JumpPart'] = "Head",
        ['Easing'] = Enum.EasingStyle.Exponential,
        ['Smoothness'] = 0.04,
        ['Field Of View'] = {
            ['Visible'] = true,
            ['Color'] = Color3.new(255, 255, 255),
            ['Radius'] = 90,
            ['Transparency'] = 0.07
        },
    },
}

local players = game.Players
local lp = players.LocalPlayer
local rs = game:GetService("RunService")
local p = getgenv().Pentagonist
local m = lp:GetMouse()
local c = workspace.CurrentCamera
local SilentTarget, CamlockTarget = nil
local CamToggle = false

local Circle = Drawing.new("Circle")
local Circle2 = Drawing.new("Circle")

getgenv().Pentagonist_Connections = {}

local renderSteppedConnection = rs.RenderStepped:Connect(function()
    Circle.Visible = p['Silent Aim']['Field Of View'].Visible
    Circle.Color = p['Silent Aim']['Field Of View'].Color
    Circle.Radius = p['Silent Aim']['Field Of View'].Radius
    Circle.Transparency = p['Silent Aim']['Field Of View'].Transparency
    Circle.Position = Vector2.new(m.X, m.Y + (game:GetService("GuiService"):GetGuiInset().Y))

    Circle2.Visible = p['Camlock']['Field Of View'].Visible
    Circle2.Color = p['Camlock']['Field Of View'].Color
    Circle2.Radius = p['Camlock']['Field Of View'].Radius
    Circle2.Transparency = p['Camlock']['Field Of View'].Transparency
    Circle2.Position = Vector2.new(m.X, m.Y + (game:GetService("GuiService"):GetGuiInset().Y))
end)

table.insert(getgenv().Pentagonist_Connections, renderSteppedConnection)

local function Flags(Plr)
    local Dead = nil
    if Plr and Plr.Character and game.PlaceId == 2788229376 or 7213786345 or 16033173781 or 9825515356 and p.KOCheck then
        if Plr.Character:FindFirstChild("BodyEffects") then
            if Plr.Character.BodyEffects:FindFirstChild("K.O") then
                Dead = Plr.Character.BodyEffects["K.O"].Value
            elseif Plr.Character.BodyEffects:FindFirstChild("KO") then
                Dead = Plr.Character.BodyEffects.KO.Value
            end
        end
    end
    return Dead
end

local function GetClosetsPlr()
    local ClosestTarget = nil
    local MaxDistance = math.huge

    for _, index in pairs(players:GetPlayers()) do
        if index.Name ~= lp.Name and index.Character and index.Character:FindFirstChild("HumanoidRootPart") then
            local Position, OnScreen = c:WorldToScreenPoint(index.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(m.X, m.Y)).Magnitude

            if not OnScreen then
                continue
            end

            if Circle.Radius > Distance and Distance < MaxDistance then
                ClosestTarget = index
                MaxDistance = Distance
            end
        end
    end
    return ClosestTarget
end

local function GetClosetsPlr2()
    local ClosestTarget = nil
    local MaxDistance = math.huge

    for _, index in pairs(players:GetPlayers()) do
        if index.Name ~= lp.Name and index.Character and index.Character:FindFirstChild("HumanoidRootPart") then
            local Position, OnScreen = c:WorldToScreenPoint(index.Character.HumanoidRootPart.Position)
            local Distance = (Vector2.new(Position.X, Position.Y) - Vector2.new(m.X, m.Y)).Magnitude

            if not OnScreen then
                continue
            end

            if Circle2.Radius > Distance and Distance < MaxDistance then
                ClosestTarget = index
                MaxDistance = Distance
            end
        end
    end
    return ClosestTarget
end

local renderSteppedSilentAimConnection = rs.RenderStepped:Connect(function()
    if p['Silent Aim'].Enabled and not p['Silent Aim']['Sync Camlock'] then
        SilentTarget = GetClosetsPlr()
    end
end)

table.insert(getgenv().Pentagonist_Connections, renderSteppedSilentAimConnection)

local inputBeganConnection = game:GetService("UserInputService").InputBegan:Connect(function(input, Processed)
    if Processed then return end

    if input.KeyCode == Enum.KeyCode[p.Camlock.Keybind] then
        CamToggle = not CamToggle

        if p['Silent Aim'].Enabled and p['Silent Aim']['Sync Camlock'] and p.Camlock.Enabled then
            if CamToggle then
                SilentTarget = GetClosetsPlr()
                CamlockTarget = GetClosetsPlr2()
            else
                SilentTarget = nil
                CamlockTarget = nil
            end
        end
    end
end)

table.insert(getgenv().Pentagonist_Connections, inputBeganConnection)

local function args()
    local arg = nil

    if game.PlaceId == 2788229376 then
        arg = "UpdateMousePosI"
    elseif game.PlaceId == 16033173781 then
        arg = "UpdateMousePosI"
    elseif game.PlaceId == 7213786345 then
        arg = "UpdateMousePosI"
    elseif game.PlaceId == 9825515356 then
        arg = "MousePosUpdate"
    else
        arg = "MousePosUpdate"
    end

    return arg
end

local function Velocity(Plr, Part)
    local VELLLL = Plr.Character[Part].Velocity
    return VELLLL
end

local OldPart = p['Silent Aim'].Part
local function SilentMain(index)
    local Event = game.ReplicatedStorage:FindFirstChild("MainEvent")
    local Arguements = args()
    if index:IsA("Tool") then
        index.Activated:Connect(function()
            if SilentTarget and SilentTarget.Character and Event and not Flags(SilentTarget) then
                if p['Silent Aim'].EnableJumpPart then
                    if SilentTarget.Character[p['Silent Aim'].Part].Velocity.Y < -20 then
                        p['Silent Aim'].Part = p['Silent Aim'].JumpPart
                    else
                        p['Silent Aim'].Part = OldPart
                    end
                end

                local EndPosition = SilentTarget.Character[p['Silent Aim'].Part].Position + Velocity(SilentTarget, p['Silent Aim'].Part) * p['Silent Aim'].Prediction
                Event:FireServer(Arguements, EndPosition)
            end
        end)
    end
end

local OldPart2 = p.Camlock.Part
local function Camlock()
    if CamlockTarget and CamlockTarget.Character and not Flags(CamlockTarget) then
        if p.Camlock.EnableJumpPart then
            if CamlockTarget.Character[p.Camlock.Part].Velocity.Y < -20 then
                p.Camlock.Part = p.Camlock.JumpPart
            else
                p.Camlock.Part = OldPart2
            end
        end

        local EndPosition = CFrame.new(c.CFrame.Position, CamlockTarget.Character[p.Camlock.Part].Position + Velocity(CamlockTarget, p.Camlock.Part) * p.Camlock.Prediction)
        c.CFrame = c.CFrame:Lerp(EndPosition, p.Camlock.Smoothness)
    end
end

local renderSteppedCamlockConnection = rs.RenderStepped:Connect(Camlock)

table.insert(getgenv().Pentagonist_Connections, renderSteppedCamlockConnection)

local function onCharacterAdded(character)
    character.ChildAdded:Connect(SilentMain)
    for _, tool in pairs(character:GetChildren()) do
        SilentMain(tool)
    end
end

local characterAddedConnection = lp.CharacterAdded:Connect(onCharacterAdded)

table.insert(getgenv().Pentagonist_Connections, characterAddedConnection)

if lp.Character then
    onCharacterAdded(lp.Character)
end
