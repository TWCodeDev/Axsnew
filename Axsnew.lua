--// Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "AXS v1.1.0 BETA by Rlyyy",
    SubTitle = "Main Hub",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true,
    Theme = "Dark"
})

--// Tabs
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local AuraTab = Window:AddTab({ Title = "Combat / Aura", Icon = "swords" })

--// Variables
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local ToolDamage = RemoteEvents:WaitForChild("ToolDamageObject")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

local KillAuraEnabled = false
local KillAuraDistance = 200

--// Bring Function
local function bringItem(itemName)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == itemName and obj.PrimaryPart then
            obj:SetPrimaryPartCFrame(HRP.CFrame + Vector3.new(3, 0, 0))
        end
    end
end

--// Kill Aura Function
local function killAuraLoop()
    task.spawn(function()
        while KillAuraEnabled do
            task.wait(0.1)
            for _, mob in pairs(workspace.Characters:GetChildren()) do
                if mob:IsA("Model") and mob.PrimaryPart then
                    local distance = (mob.PrimaryPart.Position - HRP.Position).Magnitude
                    if distance <= KillAuraDistance then
                        local weapon = LocalPlayer.Backpack:FindFirstChild("Old Axe")
                            or LocalPlayer.Backpack:FindFirstChild("Good Axe")
                            or LocalPlayer.Backpack:FindFirstChild("Strong Axe")
                            or LocalPlayer.Backpack:FindFirstChild("Chainsaw")
                            or LocalPlayer.Character:FindFirstChild("Old Axe")
                            or LocalPlayer.Character:FindFirstChild("Good Axe")
                            or LocalPlayer.Character:FindFirstChild("Strong Axe")
                            or LocalPlayer.Character:FindFirstChild("Chainsaw")

                        if weapon then
                            ToolDamage:InvokeServer(mob, weapon, 999, HRP.CFrame)
                        end
                    end
                end
            end
        end
    end)
end

--// UI Buttons

-- Bring Buttons
MainTab:AddButton({
    Title = "Bring Logs",
    Description = "Bring all logs",
    Callback = function() bringItem("Log") end
})

MainTab:AddButton({
    Title = "Bring Coal",
    Description = "Bring all coal",
    Callback = function() bringItem("Coal") end
})

MainTab:AddButton({
    Title = "Bring Carrots",
    Description = "Bring all carrots",
    Callback = function() bringItem("Carrot") end
})

MainTab:AddButton({
    Title = "Bring Rifle",
    Description = "Bring all rifles",
    Callback = function() bringItem("Rifle") end
})

MainTab:AddButton({
    Title = "Bring Rifle Ammo",
    Description = "Bring all rifle ammo",
    Callback = function() bringItem("Rifle Ammo") end
})

MainTab:AddButton({
    Title = "Bring Fuel Canister",
    Description = "Bring all fuel canisters",
    Callback = function() bringItem("Fuel Canister") end
})

-- Kill Aura Toggle
AuraTab:AddToggle("KillAura", {
    Title = "Kill Aura",
    Description = "Automatically attack nearby mobs",
    Default = false,
    Callback = function(state)
        KillAuraEnabled = state
        if state then
            killAuraLoop()
        end
    end
})

-- Kill Aura Distance
AuraTab:AddSlider("AuraDistance", {
    Title = "Kill Aura Range",
    Description = "Adjust the distance for Kill Aura",
    Default = 200,
    Min = 25,
    Max = 1000,
    Rounding = 0,
    Callback = function(value)
        KillAuraDistance = value
    end
})

-- Init UI
Window:SelectTab(1)
Fluent:Notify({
    Title = "AXS Loaded",
    Content = "Bring & Kill Aura are ready.",
    Duration = 5
})
