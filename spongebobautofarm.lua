local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Spongebob Simulator Script by Z33N ( F to Toggle )", "DarkTheme")

local Autofarm = Window:NewTab("Autofarm")
local AutofarmSection = Autofarm:NewSection("Updated: 8/4 12:59")

local clicking = false
local teleporting = false


local nodesContainer = game.Workspace:WaitForChild("Nodes")
local radius = 200

local function getClosestNode()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local closestNode = nil
    local shortestDistance = radiuss

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


local function clickNode(node)
    local args = {
        [1] = node,
        [2] = true,
        [3] = false
    }

    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("NodeService"):WaitForChild("RE"):WaitForChild("NodeClicked"):FireServer(unpack(args))
end


local function startClicking()
    clicking = true
    while clicking do
        local closestNode = getClosestNode()

        if closestNode then
            clickNode(closestNode)
            repeat
                wait(0.1)
            until not closestNode.Parent or not clicking
            wait(0.1) 
        else
            wait(0.5) 
        end
    end
end


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
local AutoPickupSection = AutoPickupTab:NewSection("no morphs if u wanna teleport!!!")

local TweenService = game:GetService("TweenService")
local autoPicking = false
local tweenSpeed = 100
local tweenRadius = 200

-- path to the Terrain container
local terrainContainer = game.Workspace:WaitForChild("Terrain")

-- function to find the closest attachment with the "Currency_" prefix
local function getClosestAttachment()
    local character = game.Players.LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local closestAttachment = nil
    local shortestDistance = tweenRadius -- initialize to the search radius
    
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

-- function to tween to a specific position
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

-- auto pickup func
local function startAutoPicking()
    autoPicking = true
    while autoPicking do
        local closestAttachment = getClosestAttachment()

        if closestAttachment then
            tweenToPosition(closestAttachment.WorldPosition)
            wait(0.1) 
        end
        wait(0.1) 
    end
end

-- stop pickup
local function stopAutoPicking()
    autoPicking = false
end

-- autopickup
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


-----------------------------------------------------------------------


local TweenService = game:GetService("TweenService")

-- area rewards
local autoQuests = Window:NewTab("Auto Quests")
local autoQuestsSection = autoQuests:NewSection("Will teleport to quest items.")

-- quest pathz
local quests = {
    ["Skeleton SpongeBob"] = {"Programmables", "Secrets", "SkeletonSpongeBobQuest", "Spawners"},
    ["Knight SpongeBob"] = {"Programmables", "Secrets", "KnightSpongeBobQuest", "Spawners"},
    ["King Neptune"] = {"Programmables", "Secrets", "KingNeptuneQuest", "Spawners"},
    ["GG Rock SpongeBob"] = {"Programmables", "Secrets", "GGRockSpongeBobQuest", "Spawners"},
    ["Cowboy SpongeBob"] = {"Programmables", "Secrets", "CowboySpongeBobQuest", "Spawners"},
    ["Plankton"] = {"Programmables", "Secrets", "PlanktonQuest", "Spawners"}
}

-- get foldr
local function getFolderFromPath(pathArray)
    local currentFolder = game:GetService("Workspace")
    for _, folderName in ipairs(pathArray) do
        currentFolder = currentFolder:FindFirstChild(folderName)
        if not currentFolder then
            return nil
        end
    end
    return currentFolder
end

-- tween (i love tweens)
local function tweenToSpawner(humanoidRootPart, spawnerCFrame)
    local tweenInfo = TweenInfo.new(
        0.5, 
        Enum.EasingStyle.Linear, -- LINEAR MOTION LETS GOOO
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = spawnerCFrame})
    tween:Play()
    tween.Completed:Wait() -- yay
end

-- tiny move plzzzz
local function smallMovementFixedY(humanoidRootPart, fixedY)
    local center = humanoidRootPart.Position
    local radius = 0.3 -- movement radiussss
    local directions = {
        Vector3.new(1, 0, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(0, 0, 1),
        Vector3.new(0, 0, -1)
    }
    
    for _, direction in ipairs(directions) do
        local newPosition = center + direction * radius
        newPosition = Vector3.new(newPosition.X, fixedY, newPosition.Z)
        
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = CFrame.new(newPosition)})
        tween:Play()
        tween.Completed:Wait()
    end
end

-- tele func
local function teleportToSpawners(selectedQuest)
    if not selectedQuest then
        print("No quest selected!")
        return
    end

    -- get char
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")

    -- store state
    local originalWalkSpeed = humanoid.WalkSpeed
    local originalJumpPower = humanoid.JumpPower

    -- disable movement (for the noobz)
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0

    -- get folder w/ parts
    local questPath = quests[selectedQuest]
    local spawnersFolder = getFolderFromPath(questPath)

    if not spawnersFolder then
        print("Quest folder not found for: " .. selectedQuest)
        --restore char state
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
        return
    end

    print("Teleporting for quest: " .. selectedQuest)

    --loop folder
    for _, spawner in ipairs(spawnersFolder:GetChildren()) do
        if spawner:IsA("BasePart") then
            -- tween (🤤) with Y unlocked
            tweenToSpawner(humanoidRootPart, spawner.CFrame)
            print("Tweened to: " .. spawner.Name)

            -- Lock Y for small movements
            local fixedY = humanoidRootPart.Position.Y
            -- run this thingy
            smallMovementFixedY(humanoidRootPart, fixedY)

            -- then wait lets gooo
            wait(0.1) 
        end
    end

    print("Teleportation complete for: " .. selectedQuest)

    -- restore walking
    humanoid.WalkSpeed = originalWalkSpeed
    humanoid.JumpPower = originalJumpPower
end

-- dropdwn
local questItems = {}
for questName, _ in pairs(quests) do
    table.insert(questItems, questName)
end

local selected = nil
autoQuestsSection:NewDropdown("Select Quest", "Select the quest to farm.", questItems, function(currentOption)
    selected = currentOption
end)

-- buttin
autoQuestsSection:NewButton("Start Quest", "Collects all of the items for the selected quest.", function()
    if selected then
        teleportToSpawners(selected)
    else
        print("Please select a quest first!")
    end
end)



-- eggs stuff
local AutoEggsSection = Window:NewTab("Auto Eggs")
local AutoEggsSection = AutoEggsSection:NewSection("Will update most likely each new area")

-- dropdown
local eggOptions = {}
for i = 1, 63 do
	table.insert(eggOptions, "meme buddies")
    table.insert(eggOptions, "area" .. i .. " basic")
    table.insert(eggOptions, "area" .. i .. " golden")
end

local selectedEgg
local autoOpenEggs = false

-- open eggz
local function openEgg(egg)
    local args = {
        [1] = egg,
        [2] = 8
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("ClamService"):WaitForChild("RF"):WaitForChild("Purchase"):InvokeServer(unpack(args))
end

-- start egg open
local function startAutoOpen()
    while autoOpenEggs do
        openEgg(selectedEgg)
        wait(0.1)
    end
end

--dropdown
AutoEggsSection:NewDropdown("Select Egg", "Select the egg to open", eggOptions, function(currentOption)
    selectedEgg = currentOption
    print("Selected Egg: " .. selectedEgg)
end)

-- auto egg
AutoEggsSection:NewButton("Start Auto Open", "Start automatically opening the selected egg", function()
    if selectedEgg then
        autoOpenEggs = true
        startAutoOpen()
    else
        print("Please select an egg first.")
    end
end)

-- stop egg
AutoEggsSection:NewButton("Stop Auto Open", "Stop automatically opening eggs", function()
    autoOpenEggs = false 
    end)
	
-- disable the egg animation
AutoEggsSection:NewButton("Disable Egg Animation", "i wonder what this does 🤔", function()
    game:GetService("Players").LocalPlayer.PlayerGui.RewardScreen:Destroy() 
end)


local Player = Window:NewTab("Player")
local PlayerSection = Player:NewSection("freakybob is behind you")

-- speed/jump
PlayerSection:NewSlider("WalkSpeed", "Adjust the WalkSpeed", 200, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
 
PlayerSection:NewSlider("JumpPower", "Adjust the JumpPower", 200, 50, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)
-- inf yield
PlayerSection:NewButton("Infinite Yield (Admin Commands)", "gives you admin commands", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)