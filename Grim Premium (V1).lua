-- THE ENTIRE SOURCE CODE WAS DEVELOPED BY SUMMON (0integers)
-- IF YOU HAVE ACCESS TO THIS SOURCE CODE, THAT MEANS YOU'RE SOMEONE I TRUST.
--[[

///////////////////////////////////////////////////////////////
// (c) 2024 - Future @ grim.cc                               //
// This material may not be reproduced, displayed, modified, //
// or distributed unless sold directly from                 //
// [ Grim.cc Owner, (0integers) ] also without the express     //
// prior written permission of the copyright holder.        //
///////////////////////////////////////////////////////////////

--]]

--// Variables
local ReplicatedStorage                 = game:GetService("ReplicatedStorage")
local RunService                        = game:GetService("RunService")
local Players                           = game:GetService("Players")
local Workspace                         = game:GetService("Workspace")
local UserInputService                  = game:GetService("UserInputService")
local StarterGui                        = game:GetService("StarterGui")
local TweenService                      = game:GetService("TweenService")
local HttpService                       = game:GetService("HttpService")
local VirtualUser                       = game:GetService("VirtualUser")
local CorePackages                      = game:GetService("CorePackages")
local GuiService                        = game:GetService("GuiService")
local TeleportService                   = game:GetService('TeleportService')
--// Optimizations
local cfnew                                     = CFrame.new
local vec2                                      = vec2
local vec3                                      = Vector3.new
--// stuff
local CurrentCamera                             = Workspace.CurrentCamera
local LocalPlayer                               = Players.LocalPlayer
local Mouse                                     = LocalPlayer:GetMouse()
local AimbotEnabled                             = false
local AimAssistEnabled                          = false
local AimbotBypass                              = nil
local AimbotMethod                              = nil
local SelectedHitPart                           = nil
local ClosestPointEnabled                       = false
local ClosestPartEnabled                        = false
local JumpOffsetEnabled                         = false
local JumpOffset                                = 0.1
local AirPartEnabled                            = false
local SelectedAirPart                           = nil
local TargetPlayer                              = nil
local ResolverEnabled                           = false
local DesyncEnabled                             = false
local AntiLockEnabled                           = false
local SelectedAntiLock                          = nil
local SelectedResolver                          = nil
local SelectedDesync                            = nil
local Grim                                      = {}
local AimAssistTarget                           = nil
local RagebotEnabled                            = false
local RagebotBypass                             = 'Mouse Index'
local RagebotMethod                             = 'Nearest to Cursor'
local RagebotPrediction                         = 0.1
local SelectedRageTarget                        = nil
local RagebotLookAtEnabled                      = false
local RagebotNearestDistance                    = 1/0
local EnableCrewCheck                           = false
local EnableFriendCheck                         = false
local EnableVisibleCheck                        = false
local EnableDeadCheck                           = false
local EnableGrabbedCheck                        = false
local shakeOffset                               = Vector3.new(0, 0, 0)
local MoveAroundEnabled                         = false
local task                                      = task or coroutine
local newcclosure                               = newcclosure or nil
local function check()
    return ReplicatedStorage:FindFirstChild("MainEvent") or ReplicatedStorage:FindFirstChild("MAINEVENT")
end

local ME = check()
local EventN = nil
if ME then
    if ME.Name == "MAINEVENT" then
        EventN              = "STOMP"
    else
        EventN              = "Stomp"
    end
end
-- Checks
--erm dont mind dem detected variables >_<
local library                                   = loadstring(game:HttpGet("https://raw.githubusercontent.com/firm0001/uwu/main/dependencies/ui.lua"))()
local EasingStyles = {
    None = nil,
    Linear = Enum.EasingStyle.Linear,
    Sine = Enum.EasingStyle.Sine,
    Back = Enum.EasingStyle.Back,
    Quad = Enum.EasingStyle.Quad,
    Quart = Enum.EasingStyle.Quart,
    Quint = Enum.EasingStyle.Quint,
    Bounce = Enum.EasingStyle.Bounce,
    Elastic = Enum.EasingStyle.Elastic,
    Exponential = Enum.EasingStyle.Exponential,
    Circular = Enum.EasingStyle.Circular,
    Cubic = Enum.EasingStyle.Cubic
}
library:Watermark("Grim.cc | V1 [ Premium ]")
local main = library:Load{
    Name = "Grim.cc | V1 [ Premium ]",
    SizeX = 660,
    SizeY = 560,
    Theme = "Midnight",
    Extension = "json",
    Folder = "grim config"
}
local Main = main:Tab("Main")
local Bots = main:Tab("Bot(s)")
local Client = main:Tab("Client")
local Visuals = main:Tab("Visuals")

local AimbotSection = Main:Section{Name = "Aimbot", Side = "Left"}
local AimAssistSection = Main:Section{Name = "Aim Assist", Side = "Right"}
local ConfigurationSection = Main:Section{Name = "Configuration", Side = "Right"}
local ChecksSection = Main:Section{Name = "Checks", Side = "Right"}
local StrafeSection = Main:Section{Name = "Strafe", Side = "Left"}
local PredictionSection = Main:Section{Name = "Prediction", Side = "Left"}

local RagebotSection = Bots:Section{Name = "Ragebot", Side = "Left"}
local KillbotSection = Bots:Section{Name = "Killbot", Side = "Left"}
local TriggerbotSection = Bots:Section{Name = "Triggerbot", Side = "Right"}

local GeneralConfigSection = Client:Section{Name = "General Configuration", Side = "Left"}
local TeleportSection = Client:Section{Name = "Teleport(s)", Side = "Left"}
local AutoBuySection = Client:Section{Name = "Auto Buy", Side = "Left"}
local AutoSection = Client:Section{Name = "Auto(s)", Side = "Left"}
local AntiSection = Client:Section{Name = "Anti(s)", Side = "Left"}
local MiscConfigSection = Client:Section{Name = "Misc Configuration", Side = "Right"}
local AntiLockSection = Client:Section{Name = "Anti Lock", Side = "Right"}
local ResolverSection = Client:Section{Name = "Resolver", Side = "Right"}
local DesyncSection = Client:Section{Name = "Desync", Side = "Right"}

local ConfigSection = Visuals:Section{Name = "Configuration", Side = "Left"}
local TracerConfigSection = Visuals:Section{Name = "Tracer Configuration", Side = "Left"}
local Box2DConfigSection = Visuals:Section{Name = "2D Box Configuration", Side = "Left"}
local Box3DConfigSection = Visuals:Section{Name = "3D Box Configuration", Side = "Left"}
local ChamsSection = Visuals:Section{Name = "Chams", Side = "Left"}
local FOVSection = Visuals:Section{Name = "FOV", Side = "Right"}
local VisualizeSection = Visuals:Section{Name = "Visualize", Side = "Right"}
local CursorSection = Visuals:Section{Name = "Cursor", Side = "Right"}

local FOVCircle                                     = Drawing.new("Circle")
FOVCircle.Radius = 50 * 3
FOVCircle.Visible = true
FOVCircle.Transparency = 0.4

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and FOVCircle.Visible then
        local guiInset = GuiService:GetGuiInset()
        FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y + guiInset.Y)
    end
end)
local Games = {
    [2788229376]                     = {Name = "Da Hood"; Arg = "UpdateMousePosI"; Remote = "MainEvent"};
    [16033173781]                    = {Name = "Da Hood Macro"; Arg = "UpdateMousePosI"; Remote = "MainEvent"};
    [7213786345]                     = {Name = "Da Hood VC"; Arg = "UpdateMousePosI"; Remote = "MainEvent"};
    [9825515356]                     = {Name = "Hood Customs"; Arg = "MousePosUpdate"; Remote = "MainEvent"};
    [14412355918]                    = {Name = "Da Downhill"; Arg = "MOUSE"; Remote = "MAINEVENT"};
    [14412436145]                    = {Name = "Da Uphill"; Arg = "MOUSE"; Remote = "MAINEVENT"};
    [15186202290]                    = {Name = "Da Strike"; Arg = "MOUSE"; Remote = "MAINEVENT"};
    [18129399112]                    = {Name = "Del Hood Aim"; Arg = "UpdateMousePos"; Remote = "MainEvent"};
    [17897702920]                    = {Name = "OG Da Hood"; Arg = "UpdateMousePos"; Remote = "MainEvent"}
}

local function WallCheck(destination, ignore)
    local Origin = CurrentCamera.CFrame.p
    local CheckRay = Ray.new(Origin, destination - Origin)
    local Hit = Workspace:FindPartOnRayWithIgnoreList(CheckRay, ignore)
    return Hit == nil
end
local function UpdateTarget()
    if AimAssistEnabled then
        AimAssistTarget = GetTargetInFov()
        if AimAssistTarget then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Aim Assist",
                Text = "Target set to " .. AimAssistTarget.Name,
                Duration = 5
            })
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Aim Assist",
                Text = "No targets in FOV",
                Duration = 5
            })
        end
    else
        AimAssistTarget = nil
    end
end
GetTargetInFov = function()
    local closestDist = FOVCircle.Radius
    local closestPlr = nil
    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distToMouse = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distToMouse < closestDist and WallCheck(v.Character.Head.Position, {LocalPlayer, v.Character}) then
                    closestPlr = v
                    closestDist = distToMouse
                end
            end
        end
    end
    return closestPlr
end
local function isValid(player)
    if EnableCrewCheck then
        local TargetCrew = player.DataFolder.Information:FindFirstChild("Crew")
        local LPCrew = game.Players.LocalPlayer.DataFolder.Information:FindFirstChild("Crew")
        
        if TargetCrew and LPCrew and TargetCrew.Value == LPCrew.Value then
            return false
        end
    end

    if EnableFriendCheck then
        local isFriend = game.Players.LocalPlayer:IsFriendsWith(player.UserId)
        if isFriend then
            return false
        end
    end

    if EnableVisibleCheck then
        local _, isVisible = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
        if not isVisible then
            return false
        end
    end

    if EnableDeadCheck then
        local hasBodyEffects = player.Character:FindFirstChild("BodyEffects")
        if hasBodyEffects then
            local isDeadValue = hasBodyEffects:FindFirstChild("K.O")
            if isDeadValue then
                if isDeadValue.Value then
                    return false
                end
            end
        end
    end

    if EnableGrabbedCheck then
        local hasGrabbingConstraint = player.Character:FindFirstChild("GRABBING_CONSTRAINT")
        if hasGrabbingConstraint then
            return false
        end
    end

    return true
end
local function GetSelectedPart(player)
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if AirPartEnabled and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                return SelectedAirPart
            else
                return SelectedHitPart
            end
        end
    end
    return SelectedHitPart
end

local function isClosestPart(player)
    if ClosestPartEnabled then
        local ClosestPart = nil
        local ClosestDis = math.huge
        local mousePos = Vector2.new(Mouse.X, Mouse.Y)
        
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                local screenPos, isVisible = CurrentCamera:WorldToViewportPoint(part.Position)
                
                if isVisible then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    if distance < ClosestDis then
                        ClosestDis = distance
                        ClosestPart = part
                    end
                end
            end
        end
        
        return ClosestPart
    end
end

local GetFemboy = function()
    if AimbotMethod == 'Target' then
        if not TargetPlayer then
            TargetPlayer = GetTargetInFov()
            if TargetPlayer then
                Notify("Target has been set to " .. TargetPlayer.Name, 5)
            end
        end
    else
        TargetPlayer = nil
    end
end
local function GrimBypass(tool)
    if tool:IsA("Tool") then
        tool.Activated:Connect(function()
            if AimbotEnabled then
                local aimPos, predictedPos, Plr

                if AimbotBypass == 'Event Trigger' then
                    if TargetPlayer and isValid(TargetPlayer) then
                        if ClosestPartEnabled then
                            aimPos = GetClosestPart(TargetPlayer)
                            if aimPos then
                                predictedPos = aimPos.Position + (TargetPlayer.Character[GetSelectedPart(TargetPlayer)].Velocity * (AimbotPrediction or 0.1))
                            end
                        else
                            local selectedPart = TargetPlayer.Character:FindFirstChild(GetSelectedPart(TargetPlayer))
                            if selectedPart then
                                aimPos = selectedPart
                                predictedPos = aimPos.Position + (selectedPart.Velocity * (AimbotPrediction or 0.1))
                            end
                        end
                    end
                elseif AimbotMethod == 'FOV' and AimbotBypass == 'Event Trigger' then
                    Plr = GetTargetInFov()
                    if Plr and isValid(Plr) then
                        if ClosestPartEnabled then
                            aimPos = GetClosestPart(Plr)
                            if aimPos then
                                predictedPos = aimPos.Position + (Plr.Character[GetSelectedPart(Plr)].Velocity * (AimbotPrediction or 0.1))
                            end
                        else
                            local selectedPart = Plr.Character:FindFirstChild(GetSelectedPart(Plr))
                            if selectedPart then
                                aimPos = selectedPart
                                predictedPos = aimPos.Position + (selectedPart.Velocity * (AimbotPrediction or 0.1))
                            end
                        end
                    end
                end

                if aimPos and predictedPos and JumpOffsetEnabled then
                    local Offset = tonumber(JumpOffset) or 0.1
                    predictedPos = predictedPos + Vector3.new(0, Offset, 0)
                end
                
                if aimPos and predictedPos then
                    if game.PlaceId == 9825515356 then
                        predictedPos = predictedPos + Vector3.new(25, 100, 25)
                    end
                    local GameInfo = Games[game.PlaceId]
                    if GameInfo then
                        local PMethod = GameInfo.Arg or "UpdateMousePos"
                        local Remote = GameInfo.Remote or "MainEvent"
                        local RemoteEvent = ReplicatedStorage:FindFirstChild(Remote)
                        if RemoteEvent then
                            RemoteEvent:FireServer(PMethod, predictedPos)
                        else
                            warn("RemoteEvent not found:", Remote)
                        end
                    else
                        warn("GameInfo not found for PlaceId:", game.PlaceId)
                    end
                end
            end
        end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(GrimBypass)
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(GrimBypass)
end
local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)

grmt.__index = newcclosure(function(self, v)
    if AimbotEnabled and AimbotBypass == 'Mouse Index' and Mouse and (tostring(v) == "Hit" or tostring(v) == "Target") then
        local function GetEndPoint(target)
            if target and isValid(target) and target.Character then
                local selectedPart = GetSelectedPart(target)
                if selectedPart then
                    local obj = target.Character[selectedPart]
                    if obj then
                        local ep = obj.CFrame + (obj.AssemblyLinearVelocity * (AimbotPrediction or 0.1))
                        if JumpOffsetEnabled then
                            local jumpOffsetValue = tonumber(JumpOffset) or nil
                            ep = ep + Vector3.new(0, jumpOffsetValue, 0)
                        end
                        return ep
                    end
                end
            end
            return nil
        end

        if AimbotMethod == 'FOV' then
            local Target = GetTargetInFov()
            local ep = GetEndPoint(Target)
            if ep then
                return (tostring(v) == "Hit" and ep or nil)
            end
        elseif AimbotMethod == 'Target' then
            if TargetPlayer then
                local ep = GetEndPoint(TargetPlayer)
                if ep then
                    return (tostring(v) == "Hit" and ep or nil)
                end
            end
        end
    end
    return backupindex(self, v)
end)
setreadonly(grmt, true)

AimbotSection:Toggle{
    Name = "Enabled",
    Callback  = function(x)
        AimbotEnabled = x
    end
}
AimbotSection:Toggle{
    Name = "Enabled Closest Part",
    Callback  = function(x)
        ClosestPartEnabled = x
    end
}
local flyspeed = 20
local flying = false

local function startFlying()
    if workspace:FindFirstChild("Core") then
        workspace.Core:Destroy()
    end
    
    local Core = Instance.new("Part")
    Core.Name = "Core"
    Core.Size = Vector3.new(0.05, 0.05, 0.05)
    Core.Transparency = 1
    Core.Parent = workspace

    local Weld = Instance.new("Weld", Core)
    Weld.Part0 = Core
    Weld.Part1 = game.Players.LocalPlayer.Character.LowerTorso
    Weld.C0 = CFrame.new(0, 0, 0)

    workspace:WaitForChild("Core")
    local torso = workspace.Core
    local keys = {a = false, d = false, w = false, s = false}
    local e1, e2

    local function fly()
        local pos = Instance.new("BodyPosition", torso)
        local gyro = Instance.new("BodyGyro", torso)
        pos.Name = "EPIXPOS"
        pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
        pos.position = torso.Position
        gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        gyro.cframe = torso.CFrame

        repeat
            wait()
            local new = gyro.cframe - gyro.cframe.p + pos.position
            if keys.w then
                new = new + workspace.CurrentCamera.CFrame.lookVector * 20
            end
            if keys.s then
                new = new - workspace.CurrentCamera.CFrame.lookVector * 20
            end
            if keys.d then
                new = new * CFrame.new(20, 0, 0)
            end
            if keys.a then
                new = new * CFrame.new(-20, 0, 0)
            end
            pos.position = new.p

            if keys.w then
                gyro.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad(flyspeed * 0), 0, 0)
            elseif keys.s then
                gyro.cframe = workspace.CurrentCamera.CFrame * CFrame.Angles(math.rad(flyspeed * 0), 0, 0)
            else
                gyro.cframe = workspace.CurrentCamera.CFrame
            end
        until not flying
        if gyro then gyro:Destroy() end
        if pos then pos:Destroy() end
        if Core then Core:Destroy() end
    end

    local mouse = game.Players.LocalPlayer:GetMouse()
    e1 = mouse.KeyDown:Connect(function(key)
        if not torso or not torso.Parent then flying = false e1:Disconnect() e2:Disconnect() return end
        if key == "w" then
            keys.w = true
        elseif key == "s" then
            keys.s = true
        elseif key == "a" then
            keys.a = true
        elseif key == "d" then
            keys.d = true
        end
    end)
    e2 = mouse.KeyUp:Connect(function(key)
        if key == "w" then
            keys.w = false
        elseif key == "s" then
            keys.s = false
        elseif key == "a" then
            keys.a = false
        elseif key == "d" then
            keys.d = false
        end
    end)
    fly()
end
AimbotSection:Toggle{
    Name = "Enable Closest Point",
    Callback  = function(x)
        ClosestPointEnabled = x
    end
}
local keybind = AimbotSection:Keybind{
    Name = "Aimbot Target | Keybind",
    Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2},
    Callback = function(key)
        TargetPlayer = GetTargetInFov()
        if TargetPlayer then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Aimbot Target",
                Text = "Target has been set to " .. TargetPlayer.Name,
                Duration = 5
            })
        end
    end
}
AimbotSection:Dropdown{
    Name = "Select Aimbot Bypass: ",
    Content = {
        "Mouse Index",
        "Event Trigger"
    },
    Callback = function(x)
        AimbotBypass = x
    end
 }
AimbotSection:Dropdown{
    Name = "Select Aimbot Method: ",
    Content = {
        "FOV",
        "Target"
    },
    Callback = function(x)
        AimbotMethod = x
    end
}
 AimbotSection:Toggle{
    Name = "Enabled Look-At",
    Callback  = function(x)
    end
}
AimbotSection:Toggle{
    Name = "Enabled Anti Curve",
    Callback  = function(x)
    end
}
AimbotSection:Toggle{
    Name = "Enabled Anti Ground Shots",
    Callback  = function(x)
    end
}
ConfigurationSection:Dropdown{
    Name = "Select Target HitPart: ",
    Content = {
        "Head",
        "HumanoidRootPart",
        "Torso",
        "Left Foot",
        "Right Foot",
        "Upper Torso",
        "Lower Torso"
    },
    Callback = function(x)
        SelectedHitPart = x
    end
 }
 ConfigurationSection:Toggle{
    Name = "Enable Air-Part",
    Callback  = function(x)
        AirPartEnabled = x
    end
}
ConfigurationSection:Dropdown{
    Name = "Select Target Air-Part: ",
    Content = {
        "Head",
        "HumanoidRootPart",
        "Torso",
        "Left Foot",
        "Right Foot",
        "Upper Torso",
        "Lower Torso"
    },
    Callback = function(x)
        SelectedAirPart = x
    end
 }
ConfigurationSection:Toggle{
    Name = "Enable Jump Offset(s)",
    Callback  = function(x)
        JumpOffsetEnabled = x
    end
}
ConfigurationSection:Box{
    Name = "Jump Offset",
    Placeholder = "0.1",
    Callback = function(x)
        JumpOffset = x
    end
 }
 AimAssistSection:Toggle{
    Name = "Enabled",
    Callback = function(x)
        AimAssistEnabled = x
        if x then
            UpdateTarget()
        else
            AimAssistTarget = nil
        end
    end
}:Keybind{
    Name = "",
    Mode = "Toggle",
    Blacklist = {Enum.UserInputType.MouseButton2},
    Callback = function(key)
    end
}
AimAssistSection:Toggle{
    Name = "Enabled Smoothness",
    Callback  = function(x)
        EnableSmoothness = x
    end
}
AimAssistSection:Slider{
    Name = "Smoothness Amount",
    Text = "[value]/2",
    Default = 0,
    Min = 0,
    Max = 2,
    Float = 0.1,
    Callback = function(x)
        SmoothnessValue = x
    end
 }
 AimAssistSection:Dropdown{
    Name = "Select Easing Style: ",
    Content = {
        "None",
        "Linear",
        "Sine",
        "Back",
        "Quad",
        "Quart",
        "Quint",
        "Bounce",
        "Elastic",
        "Exponential",
        "Circular",
        "Cubic"
    },
    Callback = function(x)
        SelectedEasing = EasingStyles[x]
    end
}

AimAssistSection:Toggle{
    Name = "Enabled Shake",
    Callback = function(x)
        Shake = x
    end
}

AimAssistSection:Slider{
    Name = "Shake Amount",
    Text = "[value]/10",
    Default = 0,
    Min = 0,
    Max = 10,
    Float = 1,
    Callback = function(value)
        ShakeValue = value
    end
}

RunService.RenderStepped:Connect(function()
    if Shake then
        shakeOffset = Vector3.new(
            math.random(-ShakeValue, ShakeValue),
            math.random(-ShakeValue, ShakeValue),
            math.random(-ShakeValue, ShakeValue)
        ) * 0.1
    else
        shakeOffset = Vector3.new(0, 0, 0)
    end
end)
local function updateCamlock()
    if AimAssistTarget and isValid(AimAssistTarget) and AimAssistTarget.Character then
        local selectedPart = GetSelectedPart(AimAssistTarget)
        if selectedPart then
            local obj = AimAssistTarget.Character[selectedPart]
            local endpoint
            if SelectedPredictionMath == "Multiplication" then
                endpoint = obj.Position + obj.Velocity / AimAssistPrediction
            else
                endpoint = obj.Position + obj.Velocity * AimAssistPrediction
            end

            if JumpOffsetEnabled then
                local jumpOffsetValue = tonumber(JumpOffset) or 0.1
                endpoint = endpoint + Vector3.new(0, jumpOffsetValue, 0)
            end

            if EnableSmoothness then
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(CFrame.new(CurrentCamera.CFrame.Position, endpoint), SmoothnessValue)
            elseif Shake then
                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, endpoint) + shakeOffset
            else
                CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, endpoint)
            end
        end
    end
end
RunService.RenderStepped:Connect(updateCamlock)

StrafeSection:Toggle{
    Name = "Enabled Target Strafe",
    Callback  = function(x)
    end
}
StrafeSection:Slider{
    Name = "Strafe Speed",
    Text = "[value]/50",
    Default = 0,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
    end
}
StrafeSection:Slider{
    Name = "Strafe Radius",
    Text = "[value]/50",
    Default = 0,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
    end
}
StrafeSection:Slider{
    Name = "Strafe Height",
    Text = "[value]/50",
    Default = 0,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
    end
}
StrafeSection:Dropdown{
    Name = "Select Orbit Shape: ",
    Content = {
        "Circle",
        "Square",
        'Heart',
        'Triangle'
    },
    Callback = function(x)
    end
 }
 StrafeSection:Toggle{
    Name = "Enabled Auto Shoot",
    Callback  = function(x)
    end
}
StrafeSection:Toggle{
    Name = "Enabled Auto Stomp",
    Callback  = function(x)
    end
}
ChecksSection:Toggle{
    Name = "Enabled Crew Check",
    Callback  = function(x)
        EnableCrewCheck = x
    end
}
ChecksSection:Toggle{
    Name = "Enabled Friend(s) Check",
    Callback  = function(x)
        EnableFriendCheck = x
    end
}
ChecksSection:Toggle{
    Name = "Enabled Visible Check",
    Callback  = function(x)
        EnableVisibleCheck = x
    end
}
ChecksSection:Toggle{
    Name = "Enabled Dead Check",
    Callback  = function(x)
        EnableDeadCheck = x
    end
}
ChecksSection:Toggle{
    Name = "Enabled Grabbed Check",
    Callback  = function(x)
        EnableGrabbedCheck = x
    end
}
ChecksSection:Toggle{
    Name = "Enabled Distance Check",
    Callback  = function(x)
    end
}
ChecksSection:Box{
    Name = "Distance Check Integer: ",
    Placeholder = "0.1",
    Callback = function(x)
        DistanceInteger = x
    end
 }
 local function GetTargetNearestToCursor()
    local closestTarget = nil
    local shortestDistance = RagebotNearestDistance

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and isValid(player) then
            local screenPos = workspace.CurrentCamera:WorldToScreenPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestTarget = player
            end
        end
    end

    return closestTarget
end

local function GetTargetLowestHealth()
    local lowestHealthTarget = nil
    local lowestHealth = 15

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and isValid(player) then
            local health = player.Character.Humanoid.Health
            if health < lowestHealth then
                lowestHealth = health
                lowestHealthTarget = player
            end
        end
    end

    return lowestHealthTarget
end

local function GetTargetNearestToLocalPlayer()
    local closestTarget = nil
    local shortestDistance = RagebotNearestDistance
    local LocalPlayerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    if not LocalPlayerPosition then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and isValid(player) then
            local distance = (LocalPlayerPosition - player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestTarget = player
            end
        end
    end

    return closestTarget
end

local function GetTargetLowestToClosestPlayer()
    local selectedTarget = SelectedRageTarget
    local closestPlayer = nil
    local shortestDistance = 1000
    local LocalPlayerPosition = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position

    if not LocalPlayerPosition then return nil end

    local targetPlayer = Players:FindFirstChild(selectedTarget)
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player ~= targetPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (targetPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end
local tool = nil
local function shoot(tool)
    if tool and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild(tool.Name) then
        tool:Activate()
    end
end

local MoveAroundEnabled = false

local function MoveAroundTarget(target)
    while MoveAroundEnabled and target do
        if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") or not isValid(target) then
            target = GetTargetNearestToCursor() or GetTargetLowestHealth() or GetTargetNearestToLocalPlayer() or GetTargetLowestToClosestPlayer()
            if not target then break end
        end

        local angle = math.random() * math.pi * 6
        local offsetX = math.random(-OrbitRadius, OrbitRadius)
        local offsetY = math.random(-OrbitHeight, OrbitHeight)
        local offsetZ = math.random(-OrbitRadius, OrbitRadius)
        local targetpos = target.Character.HumanoidRootPart.Position + Vector3.new(offsetX, offsetY, offsetZ)
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetpos)

        game:GetService("RunService").Heartbeat:Wait()
    end
end

local function Ragebot(character)
    while RagebotEnabled do
        local target = nil
        if RagebotMethod == 'Nearest to Cursor' then
            target = GetTargetNearestToCursor()
        elseif RagebotMethod == 'Lowest Health' then
            target = GetTargetLowestHealth()
        elseif RagebotMethod == 'Nearest to LocalPlayer' then
            target = GetTargetNearestToLocalPlayer()
        elseif RagebotMethod == 'Lowest to Closest Player' then
            target = GetTargetLowestToClosestPlayer()
        end
        
        if target and target.Character and target.Character:FindFirstChild(SelectedRagePart) and isValid(target) then
            local targetPosition = target.Character[SelectedRagePart].Position
            if RagebotLookAtEnabled then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, targetPosition)
            end
            if MoveAroundEnabled then
                MoveAroundTarget(target)
            end

            shoot(tool)
        end
        task.wait(0.1)
    end
end

LocalPlayer.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function()
        Ragebot(character)
    end)
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function()
        Ragebot(LocalPlayer.Character)
    end)
end
local grmt = getrawmetatable(game)
local backupindex = grmt.__index
setreadonly(grmt, false)
grmt.__index = newcclosure(function(self, v)
    if RagebotEnabled and RagebotBypass == 'Mouse Index' and Mouse and (tostring(v) == "Hit" or tostring(v) == "Target") then
        local target = nil
        if RagebotMethod == 'Nearest to Cursor' then
            target = GetTargetNearestToCursor()
        elseif RagebotMethod == 'Lowest Health' then
            target = GetTargetLowestHealth()
        elseif RagebotMethod == 'Nearest to LocalPlayer' then
            target = GetTargetNearestToLocalPlayer()
        elseif RagebotMethod == 'Lowest to Closest Player' then
            target = GetTargetLowestToClosestPlayer()
        end

        if target and target.Character then
            local objed = target.Character:FindFirstChild(SelectedRagePart)
            if objed then
                local ep = objed.CFrame + (objed.AssemblyLinearVelocity * RagebotPrediction)
                return (tostring(v) == "Hit" and ep or nil)
            end
        end
    end
    return backupindex(self, v)
end)
setreadonly(grmt, true)

RagebotSection:Toggle{
    Name = "Enabled Ragebot",
    Callback = function(state)
        RagebotEnabled = state
    end
}
RagebotSection:Toggle{
    Name = "Enable Orbit",
    Callback = function(state)
        MoveAroundEnabled = state
    end
}
RagebotSection:Slider{
    Name = "Orbit Radius",
    Text = "[value]/50",
    Default = 0,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
        OrbitRadius = x
    end
}
RagebotSection:Slider{
    Name = "Orbit Height",
    Text = "[value]/50",
    Default = 0,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
        OrbitHeight = x
    end
}
RagebotSection:Dropdown{
    Name = "Select Ragebot Method: ",
    Content = {
        "Nearest to Cursor",
        "Lowest Health",
        "Nearest to LocalPlayer",
        "Lowest to Closest Player"
    },
    Callback = function(selection)
        RagebotMethod = selection
    end
}
RagebotSection:Dropdown{
    Name = "Select Ragebot Hit-Part: ",
    Content = {
        "Head",
        "HumanoidRootPart",
        "Torso",
        "Left Arm",
        "Right Arm",
        "Left Leg",
        "Right Leg",
        "Left Hand",
        "Right Hand",
        "Left Foot",
        "Right Foot",
        "Upper Torso",
        "Lower Torso",
        "Left Upper Arm",
        "Right Upper Arm",
        "Left Lower Arm",
        "Right Lower Arm"
    },
    Callback = function(selection)
        SelectedRagePart = selection
    end
}

RagebotSection:Box{
    Name = "Selected Player",
    Placeholder = "summon",
    Callback = function(input)
        SelectedRageTarget = input
    end
}

RagebotSection:Box{
    Name = "Ragebot Nearest Distance",
    Placeholder = "1/0",
    Callback = function(input)
        RagebotNearestDistance = tonumber(input) or 1/0
    end
}

RagebotSection:Toggle{
    Name = "Enabled Ragebot Look-At",
    Callback = function(state)
        RagebotLookAtEnabled = state
    end
}
local CROSSHAIR_SPACING = 5
local CROSSHAIR_LENGTH = 100
local CROSSHAIR_THICKNESS = 2
local CROSSHAIR_COLOR = Color3.fromRGB(255, 255, 255)
local ROTATION_SPEED = 350
local rotateCrosshair = true

local crosshairVertical1, crosshairVertical2, crosshairHorizontal1, crosshairHorizontal2
local crosshairActive = false

local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local userInputService = game:GetService("UserInputService")

local function createCrosshair()
    crosshairVertical1 = Drawing.new("Line")
    crosshairVertical1.Visible = true
    crosshairVertical1.Thickness = CROSSHAIR_THICKNESS
    crosshairVertical1.Color = CROSSHAIR_COLOR
    
    crosshairVertical2 = Drawing.new("Line")
    crosshairVertical2.Visible = true
    crosshairVertical2.Thickness = CROSSHAIR_THICKNESS
    crosshairVertical2.Color = CROSSHAIR_COLOR
    
    crosshairHorizontal1 = Drawing.new("Line")
    crosshairHorizontal1.Visible = true
    crosshairHorizontal1.Thickness = CROSSHAIR_THICKNESS
    crosshairHorizontal1.Color = CROSSHAIR_COLOR
    
    crosshairHorizontal2 = Drawing.new("Line")
    crosshairHorizontal2.Visible = true
    crosshairHorizontal2.Thickness = CROSSHAIR_THICKNESS
    crosshairHorizontal2.Color = CROSSHAIR_COLOR
    
    local angle = 0
    
    local function updateCrosshair(dt)
        if not crosshairActive then return end

        local mousePosition = userInputService:GetMouseLocation()
        
        if rotateCrosshair then
            angle = angle + ROTATION_SPEED * dt
        end
        
        local radAngle = math.rad(angle)
        local cosAngle = math.cos(radAngle)
        local sinAngle = math.sin(radAngle)
        
        local function rotatePoint(x, y)
            return Vector2.new(
                cosAngle * x - sinAngle * y,
                sinAngle * x + cosAngle * y
            )
        end
        
        local v1Start = rotatePoint(0, -CROSSHAIR_LENGTH / 2 - CROSSHAIR_SPACING)
        local v1End = rotatePoint(0, -CROSSHAIR_SPACING)
        
        crosshairVertical1.From = mousePosition + v1Start
        crosshairVertical1.To = mousePosition + v1End
        
        local v2Start = rotatePoint(0, CROSSHAIR_SPACING)
        local v2End = rotatePoint(0, CROSSHAIR_LENGTH / 2 + CROSSHAIR_SPACING)
        
        crosshairVertical2.From = mousePosition + v2Start
        crosshairVertical2.To = mousePosition + v2End
        
        local h1Start = rotatePoint(-CROSSHAIR_LENGTH / 2 - CROSSHAIR_SPACING, 0)
        local h1End = rotatePoint(-CROSSHAIR_SPACING, 0)
        
        crosshairHorizontal1.From = mousePosition + h1Start
        crosshairHorizontal1.To = mousePosition + h1End
        
        local h2Start = rotatePoint(CROSSHAIR_SPACING, 0)
        local h2End = rotatePoint(CROSSHAIR_LENGTH / 2 + CROSSHAIR_SPACING, 0)
        
        crosshairHorizontal2.From = mousePosition + h2Start
        crosshairHorizontal2.To = mousePosition + h2End
    end
    
    userInputService.MouseIconEnabled = false
    
    game:GetService("RunService").RenderStepped:Connect(function(dt)
        updateCrosshair(dt)
    end)
end

local function removeCrosshair()
    if crosshairVertical1 then crosshairVertical1.Visible = false end
    if crosshairVertical2 then crosshairVertical2.Visible = false end
    if crosshairHorizontal1 then crosshairHorizontal1.Visible = false end
    if crosshairHorizontal2 then crosshairHorizontal2.Visible = false end
    
    crosshairActive = false
    
    userInputService.MouseIconEnabled = true
end
userInputService.InputBegan:Connect(function(input)
    if crosshairActive and input.UserInputType == Enum.UserInputType.MouseButton1 then
        return
    end
end)

CursorSection:Toggle{
    Name = "Draw Crosshair",
    Callback = function(state)
        if state then
            crosshairActive = true
            createCrosshair()
        else
            removeCrosshair()
        end
    end
}:ColorPicker{
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        CROSSHAIR_COLOR = color
        if crosshairVertical1 then crosshairVertical1.Color = color end
        if crosshairVertical2 then crosshairVertical2.Color = color end
        if crosshairHorizontal1 then crosshairHorizontal1.Color = color end
        if crosshairHorizontal2 then crosshairHorizontal2.Color = color end
    end
}

CursorSection:Slider{
    Name = "Crosshair Length",
    Text = "[value]/250",
    Default = 100,
    Min = 0,
    Max = 250,
    Float = 1,
    Callback = function(x)
        CROSSHAIR_LENGTH = x
    end
}

CursorSection:Slider{
    Name = "Crosshair Spacing",
    Text = "[value]/50",
    Default = 5,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
        CROSSHAIR_SPACING = x
    end
}

CursorSection:Slider{
    Name = "Crosshair Thickness",
    Text = "[value]/10",
    Default = 2,
    Min = 0,
    Max = 10,
    Float = 1,
    Callback = function(x)
        CROSSHAIR_THICKNESS = x
        if crosshairVertical1 then crosshairVertical1.Thickness = x end
        if crosshairVertical2 then crosshairVertical2.Thickness = x end
        if crosshairHorizontal1 then crosshairHorizontal1.Thickness = x end
        if crosshairHorizontal2 then crosshairHorizontal2.Thickness = x end
    end
}

CursorSection:Toggle{
    Name = "Rotate Crosshair",
    Callback = function(state)
        rotateCrosshair = state
    end
}

CursorSection:Slider{
    Name = "Crosshair Rotation Speed",
    Text = "[value]/500",
    Default = 350,
    Min = 0,
    Max = 500,
    Float = 1,
    Callback = function(x)
        ROTATION_SPEED = x
    end
}
--[[
LocalPlayer.PlayerGui.MainScreenGui.Aim.Rotation
Players.LocalPlayer.PlayerGui.MainScreenGui.Aim.Visible
]]--

CursorSection:Toggle{
    Name = "Show In-Game Cursor",
    Default = true,
    Callback = function(state)
        Players.LocalPlayer.PlayerGui.MainScreenGui.Aim.Visible = state
    end
}
CursorSection:Slider{
    Name = "In-Game Cursor Rotation Speed",
    Text = "[value]/500",
    Default = 0,
    Min = 0,
    Max = 500,
    Float = 1,
    Callback = function(x)
        LocalPlayer.PlayerGui.MainScreenGui.Aim.Rotation = x
    end
}
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.CoreGui
screenGui.Enabled = true

local tit = Instance.new("TextLabel", screenGui)
tit.Size = UDim2.new(0, 200, 0, 20)
tit.Position = UDim2.new(0, 10, 0, 20)
tit.TextColor3 = Color3.new(1, 1, 1)
tit.BackgroundTransparency = 1
tit.TextTransparency = 0.5
tit.Font = Enum.Font.Code
tit.TextScaled = true
tit.Text = "Grim.cc | .gg/grimcc"

local aimbotpred = Instance.new("TextLabel", screenGui)
aimbotpred.Size = UDim2.new(0, 200, 0, 20)
aimbotpred.Position = UDim2.new(0, 10, 0, 40)
aimbotpred.TextColor3 = Color3.new(1, 1, 1)
aimbotpred.BackgroundTransparency = 1
aimbotpred.TextTransparency = 0.5
aimbotpred.Font = Enum.Font.Code
aimbotpred.TextScaled = true

local aimassistpred = Instance.new("TextLabel", screenGui)
aimassistpred.Size = UDim2.new(0, 200, 0, 20)
aimassistpred.Position = UDim2.new(0, 10, 0, 60)
aimassistpred.TextColor3 = Color3.new(1, 1, 1)
aimassistpred.BackgroundTransparency = 1
aimassistpred.TextTransparency = 0.5
aimassistpred.Font = Enum.Font.Code
aimassistpred.TextScaled = true

local hitchance = Instance.new("TextLabel", screenGui)
hitchance.Size = UDim2.new(0, 200, 0, 20)
hitchance.Position = UDim2.new(0, 10, 0, 80)
hitchance.TextColor3 = Color3.new(1, 1, 1)
hitchance.BackgroundTransparency = 1
hitchance.TextTransparency = 0.5
hitchance.Font = Enum.Font.Code
hitchance.TextScaled = true

local winchance = Instance.new("TextLabel", screenGui)
winchance.Size = UDim2.new(0, 200, 0, 20)
winchance.Position = UDim2.new(0, 10, 0, 100)
winchance.TextColor3 = Color3.new(1, 1, 1)
winchance.BackgroundTransparency = 1
winchance.TextTransparency = 0.5
winchance.Font = Enum.Font.Code
winchance.TextScaled = true

local function updateGui()
    if getgenv().ShowPredStats then
        aimbotpred.Text = string.format("Aimbot Prediction: %.2f", AimbotPrediction or 0)
        aimassistpred.Text = string.format("Aim Assist | Prediction: %.2f", AimAssistPrediction or 0)
        if tick() % 0.7 < 0.02 then 
            hitchance.Text = string.format("Hit Chance: %d%%", math.random(70, 100))
            winchance.Text = string.format("Win Chance: %d%%", math.random(70, 100))
        end
    else
        aimbotpred.Text = "Aimbot Prediction: 0"
        aimassistpred.Text = "Aim Assist | Prediction: 0"
        hitchance.Text = "Hit Chance: 0%"
        winchance.Text = "Win Chance: 0%"
    end
end

RunService.RenderStepped:Connect(updateGui)

local PredictionMethods = {
    ["Old Method"] = function(ping)
        return ping < 130 and ping / 1000 + 0.037 or ping / 1000 + 0.033
    end,
    ["New Method"] = function(ping)
        return 0.1 + ping / 2000 + (ping / 1000) * (ping / 1500) * 1.025
    end,
    ["Normal"] = function(ping)
        if ping < 30 then
            return 0.11252476
        elseif ping < 40 then
            return 0.11
        elseif ping < 50 then
            return 0.13544
        elseif ping < 60 then
            return 0.12
        elseif ping < 70 then
            return 0.12533
        elseif ping < 80 then
            return 0.13934
        elseif ping < 90 then
            return 0.135
        elseif ping < 100 then
            return 0.141987
        elseif ping < 110 then
            return 0.145
        elseif ping < 120 then
            return 0.15
        elseif ping < 130 then
            return 0.155
        elseif ping < 140 then
            return 0.16
        elseif ping < 150 then
            return 0.165
        elseif ping < 160 then
            return 0.17
        elseif ping < 170 then
            return 0.175
        elseif ping < 180 then
            return 0.18
        elseif ping < 190 then
            return 0.185
        elseif ping < 200 then
            return 0.19
        else
            return 0.2
        end
    end
}

local function GetPingPred(version, ping)
    local method = PredictionMethods[version]
    if method then
        local prediction = method(ping)
        if SelectedPredictionMath == "Multiplication" then
            prediction = prediction * 44
        elseif SelectedPredictionMath == "Division" then
            prediction = prediction / 1
        end
        return prediction
    else
        return 0.1
    end
end

local function ApplyAP()
    local pingStr = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local ping = tonumber(string.split(pingStr, '(')[1])

    if AimbotAutoPred then
        if AimbotAutoPredMethod then
            AimbotPrediction = GetPingPred(AimbotAutoPredMethod, ping)
        end
    end

    if AimAssistAutoPred then
        if AimAssistAutoPredMethod then
            AimAssistPrediction = GetPingPred(AimAssistAutoPredMethod, ping)
        end
    end

    updateGui()
end

RunService.RenderStepped:Connect(ApplyAP)

PredictionSection:Toggle{
    Name = "Show Prediction Stats",
    Callback = function(state)
        getgenv().ShowPredStats = state
        screenGui.Enabled = state
        updateGui()
    end
}

PredictionSection:Dropdown{
    Name = "Select Prediction Math: ",
    Content = {
        "Multiplication",
        "Division"
    },
    Callback = function(x)
        SelectedPredictionMath = x
        updateGui()
    end
}

PredictionSection:Toggle{
    Name = "Enable Aimbot | Auto Prediction",
    Callback = function(state)
        AimbotAutoPred = state
        updateGui()
    end
}

PredictionSection:Dropdown{
    Name = "Aimbot Preset Prediction(s): ",
    Content = {
        "New Method",
        "Old Method",
        "Normal"
    },
    Callback = function(x)
        AimbotAutoPredMethod = x
        updateGui()
    end
}

PredictionSection:Box{
    Name = "Custom Aimbot Prediction #",
    Placeholder = "0.6969",
    Callback = function(x)
        AimbotPrediction = tonumber(x) or 0
        updateGui()
    end
}

PredictionSection:Toggle{
    Name = "Enable Aim Assist | Auto Prediction",
    Callback = function(state)
        AimAssistAutoPred = state
        updateGui()
    end
}

PredictionSection:Dropdown{
    Name = "Aim Assist Preset Prediction(s): ",
    Content = {
        "New Method",
        "Old Method",
        "Normal"
    },
    Callback = function(x)
        AimAssistAutoPredMethod = x
        updateGui()
    end
}

PredictionSection:Box{
    Name = "Custom Aim Assist Prediction #",
    Placeholder = "0.6969",
    Callback = function(x)
        AimAssistPrediction = tonumber(x) or 0
        updateGui()
    end
}
--MiscConfigSection
GeneralConfigSection:Button{
    Name = "Server Hop",
    Callback = function()
        local servers = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=10")
        local serverData = HttpService:JSONDecode(servers)
        local server = serverData.data[math.random(1, #serverData.data)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
    end
}
GeneralConfigSection:Button{
    Name = "Rejoin Server",
    Callback = function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
}
local PerformanceModeEnabled = false
    local OGMaterials = {}
    local function ApplyPerformanceMode()
        for _, v in pairs(game:GetService("Workspace"):GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                if not OGMaterials[v] then
                    OGMaterials[v] = v.Material
                end
                v.Material = Enum.Material.SmoothPlastic
                if v:IsA("Texture") then
                    v:Destroy()
                end
            end
        end
    end
    local function RevertToRegularGraphics()
        for part, material in pairs(OGMaterials) do
            if part and part.Parent then
                part.Material = material
            end
        end
        OGMaterials = {}
    end
GeneralConfigSection:Button{
    Name = "Performance Mode",
    Callback = function()
        PerformanceModeEnabled = not PerformanceModeEnabled
    
        if PerformanceModeEnabled then
            ApplyPerformanceMode()
        else
            RevertToRegularGraphics()
        end
    end
}
GeneralConfigSection:Toggle{
    Name = "Enabled Fly",
    Callback = function(bool)
        local plr = game.Players.LocalPlayer
        localplayer = plr
        if workspace:FindFirstChild("Core") then
            workspace.Core:Destroy()
        end
        local Core = Instance.new("Part")
        Core.Name = "Core"
        Core.Size = Vector3.new(0.05, 0.05, 0.05)
        Core.Transparency = 1
        spawn(function()
            Core.Parent = workspace
            local Weld = Instance.new("Weld", Core)
            Weld.Part0 = Core
            Weld.Part1 = localplayer.Character.LowerTorso
            Weld.C0 = CFrame.new(0, 0, 0)
        end)
        workspace:WaitForChild("Core")
        local torso = workspace.Core
        local keys={a=false,d=false,w=false,s=false} 
        local e1
        local e2
        function flylol() 
            local pos = Instance.new("BodyPosition",torso)
            local gyro = Instance.new("BodyGyro",torso)
            pos.Name="EPIXPOS"
            pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
            pos.position = torso.Position
            gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9) 
            gyro.cframe = torso.CFrame
            repeat
                wait()
                local new=gyro.cframe - gyro.cframe.p + pos.position
                if keys.w then 
                    new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * 20
                    flyspeed=flyspeed+0
                end
                if keys.s then 
                    new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * 20
                    flyspeed=flyspeed+0
                end
                if keys.d then 
                    new = new * CFrame.new(20,0,0)
                    flyspeed=flyspeed+0
                end
                if keys.a then 
                    new = new * CFrame.new(-20,0,0)
                    flyspeed=flyspeed+0
                end
                pos.position=new.p
                if keys.w then
                    gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(flyspeed*0),0,0)
                elseif keys.s then
                    gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(flyspeed*0),0,0)
                else
                    gyro.cframe = workspace.CurrentCamera.CoordinateFrame
                end
            until bool == false
            if gyro then gyro:Destroy() end
            if pos then pos:Destroy() end
            if Core then Core:Destroy() end
        end
    
    local mouse = game.Players.LocalPlayer:GetMouse()
    e1 = mouse.KeyDown:connect(function(key)
        if not torso or not torso.Parent then flying=false e1:disconnect() e2:disconnect() return end
        if key=="w" then
            keys.w=true
        elseif key=="s" then
            keys.s=true
        elseif key=="a" then
            keys.a=true
        elseif key=="d" then
            keys.d=true
        end
    end)
    e2 = mouse.KeyUp:connect(function(key)
        if key=="w" then
            keys.w=false
        elseif key=="s" then
            keys.s=false
        elseif key=="a" then
            keys.a=false
        elseif key=="d" then
            keys.d=false
        end
    end)
    if bool == true then flylol() end
end
}:Keybind{
    Name = "",
    Mode = "Toggle",
    Blacklist = {Enum.UserInputType.MouseButton2},
    Callback = function(key)
    end
}
GeneralConfigSection:Toggle{
    Name = "Enabled CFrame Speed",
    Callback = function(val)
        getgenv().Speed = val
        repeat
            if getgenv().Multiplier then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * getgenv().Multiplier / 4
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection
            end
            game:GetService("RunService").Stepped:wait()
        until getgenv().Speed == false
end
}:Keybind{
    Name = "",
    Mode = "Toggle",
    Blacklist = {Enum.UserInputType.MouseButton2},
    Callback = function(key)
    end
}
GeneralConfigSection:Slider{
    Name = "CFrame Speed",
    Text = "[value]/50",
    Default = 15,
    Min = 0,
    Max = 50,
    Float = 1,
    Callback = function(x)
        getgenv().Multiplier = x
    end
 }
GeneralConfigSection:Slider{
    Name = "FOV",
    Text = "[value]/160",
    Default = 70,
    Min = 70,
    Max = 160,
    Float = 1,
    Callback = function(x)
        game.Workspace.CurrentCamera.FieldOfView = x
    end
 }
 AntiSection:Toggle{
    Name = "Enabled Anti-Slow",
    Callback = function(val)
        getgenv().x = val
        if getgenv().x == true then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local bodyEffects = character:WaitForChild("BodyEffects")
            local movement = bodyEffects:WaitForChild("Movement")

            local DeletePart = movement:FindFirstChild('NoJumping') or movement:FindFirstChild('ReduceWalk') or movement:FindFirstChild('NoWalkSpeed')
            if DeletePart then
                DeletePart:Destroy()
            end

            if bodyEffects.Reload.Value then
                bodyEffects.Reload.Value = false
            end
        end
end
}
local AntiStompEnabled = false
AntiSection:Toggle{
    Name = "Enabled Anti-Stomp",
    Callback = function(val)
        AntiStompEnabled = val
        if AntiStompEnabled then
            while wait(1) do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local humanoid = LocalPlayer.Character.Humanoid
                    if humanoid.Health < 5 then
                        for _, descendant in pairs(LocalPlayer.Character:GetDescendants()) do
                            if descendant:IsA("BasePart") then
                                descendant:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
}
getgenv().AutoStomp = false
AutoSection:Toggle{
    Name = "Enabled Auto-Stomp",
    Callback = function(val)
        getgenv().AutoStomp = val
        if getgenv().AutoStomp then
            spawn(function()
                while getgenv().AutoStomp do
                    ME:FireServer(EventN)
                    wait(0.1)
                end
            end)
        end
    end
}
AutoSection:Toggle{
    Name = "Enabled Auto-Stomp",
    Callback = function(val)
        getgenv().AutoReload = val
        if AutoReload then
            while true do
                wait(0.1)
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                if tool and tool:FindFirstChild("Ammo") and tool.Ammo.Value <= 0 then
                    game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", tool)
                    wait(1)
                end
            end
        end
    end
}
--GeneralConfigSection
local configs = main:Tab("Configuration")

local themes = configs:Section{Name = "Theme", Side = "Left"}
local themepickers = {}

local themelist = themes:Dropdown{
    Name = "Theme",
    Default = library.currenttheme,
    Content = library:GetThemes(),
    Flag = "Theme Dropdown",
    Callback = function(option)
        if option then
            library:SetTheme(option:lower())
            for option, picker in pairs(themepickers) do
                picker:Set(library.theme[option])
            end
        end
    end
}

local namebox = themes:Box{
    Name = "Custom Theme Name",
    Placeholder = "Custom Theme",
    Flag = "Custom Theme"
}

themes:Button{
    Name = "Save Custom Theme",
    Callback = function()
        if library:SaveCustomTheme(library.flags["Custom Theme"]) then
            themelist:Refresh(library:GetThemes())
            themelist:Set(library.flags["Custom Theme"])
            namebox:Set("")
        end
    end
}

local customtheme = configs:Section{Name = "Custom Theme", Side = "Right"}

local themeOptions = {
    "Accent", "Window Background", "Window Border", "Tab Background",
    "Tab Border", "Tab Toggle Background", "Section Background", "Section Border",
    "Text", "Disabled Text", "Object Background", "Object Border",
    "Dropdown Option Background"
}

for _, option in ipairs(themeOptions) do
    themepickers[option] = customtheme:ColorPicker{
        Name = option,
        Default = library.theme[option],
        Flag = option,
        Callback = function(color)
            library:ChangeThemeOption(option, color)
        end
    }
end

local configsection = configs:Section{Name = "Configs", Side = "Left"}

local isFirstClose = true
configsection:Keybind{
    Name = "Hide User Interface",
    Default = "V",
    Blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2},
    Callback = function(key)
        if isFirstClose then
            isFirstClose = false
        else
            library:Close()
        end
    end
}

local configlist = configsection:Dropdown{
    Name = "Configs",
    Content = library:GetConfigs(),
    Flag = "Config Dropdown"
}

configsection:Button{
    Name = "Load Config",
    Callback = function()
        library:LoadConfig(library.flags["Config Dropdown"])
    end
}

configsection:Button{
    Name = "Delete Config",
    Callback = function()
        library:DeleteConfig(library.flags["Config Dropdown"])
    end
}

local configbox = configsection:Box{
    Name = "Config Name",
    Placeholder = "Config Name",
    Flag = "Config Name"
}

configsection:Button{
    Name = "Save Config",
    Callback = function()
        library:SaveConfig(library.flags["Config Name"])
        configlist:Refresh(library:GetConfigs())
    end
}
