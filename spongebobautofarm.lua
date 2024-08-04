local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Spongebob Simulator Script by Z33N", "DarkTheme") -- for different colors, use these: "GrapeTheme" "DarkTheme" "LightTheme" "BloodTheme" "Ocean" "Midnight" "Sentinel" "Synapse" "Serpent"
-- Autofarm
local Autofarm = Window:NewTab("Autofarm")
local AutofarmSection = Autofarm:NewSection("made with love by z33n")


-- Define variables for clicking and teleporting states
local clicking = false
local teleporting = false

-- Path to the Nodes container
local nodesContainer = game.Workspace:WaitForChild("Nodes")
local radius = 200

-- Function to find the closest node within the specified radius
local function getClosestNode()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local closestNode = nil
    local shortestDistance = radius -- Initialize to the search radius

    for _, node in ipairs(nodesContainer:GetChildren()) do
        if node:IsA("Part") then
            local distance = (node.Position - character.HumanoidRootPart.Position).Magnitude
            if distance <= shortestDistance then
                shortestDistance = distance
                closestNode = node
            end
        end
    end

    return closestNode
end

-- Function to click a node
local function clickNode(node)
    local args = {
        [1] = node,
        [2] = true,
        [3] = false
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("NodeService"):WaitForChild("RE"):WaitForChild("NodeClicked"):FireServer(unpack(args))
end

-- Function to start the clicking loop
local function startClicking()
    clicking = true
    while clicking do
        local closestNode = getClosestNode()

        if closestNode then
            clickNode(closestNode)
            -- Wait until the node is destroyed
            repeat
                wait(0.1)
            until not closestNode.Parent or not clicking
            wait(0.1) -- Optional: Wait a short delay before targeting the next node
        else
            wait(0.5) -- Check again after a short delay if no node found within radius
        end
    end
end

-- Function to stop the clicking loop
local function stopClicking()
    clicking = false
end



-- Add buttons to start and stop the clicking loop
AutofarmSection:NewButton("Start Autofarm", "Start clicking closest node", function()
    startClicking()
end)

AutofarmSection:NewButton("Stop Autofarm", "Stop clicking closest node", function()
    stopClicking()
end)

AutofarmSection:NewSlider("Autofarm Range", "Adjust the Autofarm range ", 1000, 10, function(value)
    radius = value
end)    


local AutoPickupTab = Window:NewTab("Auto Pickup")
local AutoPickupSection = AutoPickupTab:NewSection("DONT USE MORPHS!!!")

local TweenService = game:GetService("TweenService")
local autoPicking = false
local tweenSpeed = 100 -- Default tween speed
local tweenRadius = 200 -- Default radius for detecting coins

-- Path to the Terrain container
local terrainContainer = game.Workspace:WaitForChild("Terrain")

-- Function to find the closest attachment with the "Currency_" prefix
local function getClosestAttachment()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closestAttachment = nil
    local shortestDistance = tweenRadius -- Initialize to the search radius
    
    for _, item in ipairs(terrainContainer:GetChildren()) do
        if item:IsA("Attachment") and item.Name:match("Currency_") then
            local distance = (item.WorldPosition - character.HumanoidRootPart.Position).Magnitude
            if distance <= shortestDistance then
                shortestDistance = distance
                closestAttachment = item
            end
        end
    end
    
    return closestAttachment
end

-- Function to tween to a specific position
local function tweenToPosition(targetPosition)
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = character.HumanoidRootPart
    local tweenInfo = TweenInfo.new(
        (targetPosition - humanoidRootPart.Position).Magnitude / tweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    tween.Completed:Wait()
end

-- Function to start the auto picking loop
local function startAutoPicking()
    autoPicking = true
    while autoPicking do
        local closestAttachment = getClosestAttachment()

        if closestAttachment then
            tweenToPosition(closestAttachment.WorldPosition)
            wait(0.1) -- Adjust the delay if necessary
        end
        wait(0.1) -- Adjust this delay if necessary
    end
end

-- Function to stop the auto picking loop
local function stopAutoPicking()
    autoPicking = false
end

-- Create UI elements for the AutoPickup section
AutoPickupSection:NewSlider("Tween Speed", "Adjust the tween speed", 200, 1, function(value)
    tweenSpeed = value
end)

AutoPickupSection:NewSlider("Tween Radius", "Adjust the tween radius", 500, 50, function(value)
    tweenRadius = value
end)

AutoPickupSection:NewButton("Start AutoPickup", "Start auto picking up closest currency", function()
    startAutoPicking()
end)

AutoPickupSection:NewButton("Stop AutoPickup", "Stop auto picking up closest currency", function()
    stopAutoPicking()
end)

local AutoEggsSection = Window:NewTab("Auto Eggs")
local AutoEggsSection = AutoEggsSection:NewSection("Will update most likely each new area")


-- Create dropdown options for eggs
local eggOptions = {}
for i = 1, 63 do
    table.insert(eggOptions, "area" .. i .. " basic")
    table.insert(eggOptions, "area" .. i .. " golden")
end

local selectedEgg
local autoOpenEggs = false

-- Function to open eggs
local function openEgg(egg)
    local args = {
        [1] = egg,
        [2] = 8
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ClamService"):WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(unpack(args))
end

-- Function to start auto opening eggs
local function startAutoOpen()
    while autoOpenEggs do
        openEgg(selectedEgg)
        wait(0.1)
    end
end

-- Dropdown for selecting egg
AutoEggsSection:NewDropdown("Select Egg", "Select the egg to open", eggOptions, function(currentOption)
    selectedEgg = currentOption
    print("Selected Egg: " .. selectedEgg)
end)

-- Button to start auto opening eggs
AutoEggsSection:NewButton("Start Auto Open", "Start automatically opening the selected egg", function()
    if selectedEgg then
        autoOpenEggs = true
        startAutoOpen()
    else
        print("Please select an egg first.")
    end
end)

-- Button to stop auto opening eggs
AutoEggsSection:NewButton("Stop Auto Open", "Stop automatically opening eggs", function()
    autoOpenEggs = false 
    end)


local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("freakybob is behind you")

-- WalkSpeed and JumpPower sliders
PlayerSection:NewSlider("WalkSpeed", "Adjust the WalkSpeed", 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
 
PlayerSection:NewSlider("JumpPower", "Adjust the JumpPower", 200, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

PlayerSection:NewButton("Infinite Yield (Admin Commands)", "gives you admin commands", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)