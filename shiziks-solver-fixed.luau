local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TextChatService = game:GetService("TextChatService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local Controls = require(player.PlayerScripts:WaitForChild("PlayerModule")):GetControls()

local presentsFolder = workspace:WaitForChild("Presents", 10)
local collectPresentsEnabled = false
local PRESENT_OFFSET = Vector3.new(0, 3, 0)

for _, name in pairs({"autosolver_euler", "autosolver_final", "autosolver"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name) or player.PlayerGui:FindFirstChild(name)
    if old then old:Destroy() end
end

local isAutoSolving, isWaitingForRound = false, false
local currentTab = "rage"
local calculationMode = "euler"
local freezeEnabled, autoGuess = true, true
local actionDelay, startDelayTime = 0.1, 10
local calculateDelay = 0.5 
local calcOnceTriggered = false 
local waitTimeLeft = 0
local neighborCache = {}
local lastActionTime, lastCalcTime, lastNotifyTime = tick(), 0, 0
local lastProgressTime = tick()
local isGuessing, stopCurrentExecution = false, false

local heatmapEnabled = false
local mineMarkersEnabled = true
local heatmapParts = {}
local mineOverlays = {}
local coloredCells = {}

local statusRage

local function chatNotify(msg)
    if tick() - lastNotifyTime < 0.5 then return end 
    lastNotifyTime = tick()
    local formattedMsg = "<b>[autosolver]: " .. msg .. "</b>"
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXSystem")
        if channel then channel:DisplaySystemMessage("<font color='#B4B4B4'>" .. formattedMsg .. "</font>") return end
    end
    pcall(function()
        StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[autosolver]: " .. msg,
            Color = Color3.fromRGB(180, 180, 180),
            Font = Enum.Font.GothamBold,
            FontSize = Enum.FontSize.Size18
        })
    end)
end

if presentsFolder then
    presentsFolder.ChildAdded:Connect(function(child)
        if not collectPresentsEnabled then return end
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and child then
            local startTime = tick()
            local connection
            connection = RunService.Heartbeat:Connect(function()
                if tick() - startTime >= 5 or not child or not child.Parent or not hrp or not hrp.Parent or not collectPresentsEnabled then
                    connection:Disconnect()
                    return
                end
                local targetCF = child:GetPivot()
                if targetCF then
                    hrp.CFrame = targetCF + PRESENT_OFFSET
                end
            end)
        end
    end)
end

local function handleDeath()
    if not isAutoSolving and currentTab ~= "legit" then return end
    local deathMsg = isGuessing and "didn't guess right." or "accidentally stepped on a mine/reseted."
    chatNotify(deathMsg)
    isGuessing = false
    stopCurrentExecution = true
    neighborCache = {}
    solverFolderCache = nil
    for _, p in pairs(heatmapParts) do if p and p.Parent then p:Destroy() end end
    heatmapParts = {}
    for _, g in pairs(mineOverlays) do if g and g.Parent then g:Destroy() end end
    mineOverlays = {}
end

local cachedCharacterParts = {}

local function cacheCharacterParts(char)
    cachedCharacterParts = {}
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            cachedCharacterParts[#cachedCharacterParts + 1] = p
        end
    end
end

local function setupChar(char)
    if not char then return end
    stopCurrentExecution = false
    cacheCharacterParts(char)
    local hum = char:WaitForChild("Humanoid", 10)
    if hum then hum.Died:Connect(handleDeath) end
end

if player.Character then setupChar(player.Character) end
player.CharacterAdded:Connect(setupChar)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "autosolver_final"
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = player:WaitForChild("PlayerGui") end

local header = Instance.new("Frame", screenGui)
header.Size = UDim2.new(0, 340, 0, 35)
header.Position = UDim2.new(0.5, -170, 0.3, 0)
header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
header.BorderSizePixel = 0
header.Draggable, header.Active = true, true
local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "autosolver | dc: @deadshizik"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

local mainBody = Instance.new("Frame", header)
mainBody.Size = UDim2.new(1, 0, 0, 260)
mainBody.Position = UDim2.new(0, 0, 1, 1)
mainBody.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainBody.BorderSizePixel = 0
local mainBodyCorner = Instance.new("UICorner", mainBody)
mainBodyCorner.CornerRadius = UDim.new(0, 6)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -30, 0, 5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.ZIndex = 20
local minimizeCorner = Instance.new("UICorner", minimizeBtn)
minimizeCorner.CornerRadius = UDim.new(0, 4)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainBody.Visible = not isMinimized
    minimizeBtn.Text = isMinimized and "+" or "-"
end)

local function refreshStatusUI()
    pcall(function()
        local text, color
        if isWaitingForRound then
            text = "status: waiting (" .. string.format("%.1f", waitTimeLeft) .. ")"
            color = Color3.fromRGB(200, 100, 0)
        elseif isAutoSolving then
            text = "status: running"
            color = Color3.fromRGB(50, 150, 50)
        else
            text = "status: off"
            color = Color3.fromRGB(150, 50, 50)
        end
        if statusRage then 
            statusRage.Text = text
            statusRage.BackgroundColor3 = color
            statusRage.TextColor3 = Color3.new(1,1,1) 
        end
    end)
end

local function isCellOpen(part)
    if not part or not part.Parent then return true end
    local isBeige = (part.Color.R > 0.7 and part.Color.G > 0.7 and part.Color.B < 0.6)
    return part.Transparency > 0.5 or isBeige or part:FindFirstChild("NumberGui")
end

local function setCharacterAnchored(active)
    for _, p in ipairs(cachedCharacterParts) do
        if p and p.Parent then p.Anchored = active end
    end
end

local function updatePhysics()
    local char = player.Character
    if not char then return end
    if #cachedCharacterParts == 0 then cacheCharacterParts(char) end
    local active = (isAutoSolving and not isWaitingForRound and freezeEnabled and currentTab == "rage")
    setCharacterAnchored(active)
    if active then Controls:Disable() else Controls:Enable() end
end

local function teleportTo(target)
    if stopCurrentExecution or not target or not target.Parent or isCellOpen(target) then return end
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if not stopCurrentExecution and freezeEnabled and currentTab == "rage" then
        setCharacterAnchored(false)
        root.CFrame = target.CFrame * CFrame.new(0, 3.1, 0)
        root.Velocity = Vector3.new(0, -100, 0)
        task.wait(0.01)
        updatePhysics()
    elseif not stopCurrentExecution then
        root.CFrame = target.CFrame * CFrame.new(0, 2.8, 0)
    end
end

local solverFolderCache

local function rebuildNeighborCache(folder, allParts)
    neighborCache = {}
    solverFolderCache = folder
    for _, cell in ipairs(allParts) do
        local nbs = {}
        local radius = cell.Size.X * 1.8
        local radiusSq = radius * radius
        local pos = cell.Position
        for _, n in ipairs(allParts) do
            if n ~= cell then
                local d = n.Position - pos
                if d.X*d.X + d.Y*d.Y + d.Z*d.Z < radiusSq then
                    nbs[#nbs + 1] = n
                end
            end
        end
        neighborCache[cell] = nbs
    end
end

local function getSolverData()
    local folder = workspace:FindFirstChild("Flag") and workspace.Flag:FindFirstChild("Parts")
    if not folder then return {} end
    flaggedDebounce = {}
    local numberData = {}
    local allParts = folder:GetChildren()

    -- Rebuild only when the board/folder contents actually change.
    local cacheValid = solverFolderCache == folder
    if cacheValid then
        for cell in pairs(neighborCache) do
            if not cell or cell.Parent ~= folder then
                cacheValid = false
                break
            end
        end
        if cacheValid then
            local cachedCount = 0
            for _ in pairs(neighborCache) do cachedCount += 1 end
            cacheValid = cachedCount == #allParts
        end
    end
    if not cacheValid then
        rebuildNeighborCache(folder, allParts)
    end

    for _, cell in ipairs(allParts) do
        if not isCellOpen(cell) then continue end
        local label = cell:FindFirstChild("NumberGui") and cell.NumberGui:FindFirstChildOfClass("TextLabel")
        local val = (label and tonumber(label.Text)) or 0
        local hidden, mines = {}, 0
        local nbs = neighborCache[cell] or {}
        for _, n in ipairs(nbs) do
            if not isCellOpen(n) then
                if n.Color == Color3.new(0,0,0) then
                    mines += 1
                else
                    hidden[#hidden + 1] = n
                end
            end
        end
        if #hidden > 0 then
            numberData[#numberData + 1] = {obj = cell, eVal = val - mines, hidden = hidden}
        end
    end
    return numberData
end

local function calculateProbabilities(data)
    local probabilities = {}
    local constraintCount = {}
    local mineSum = {}
    
    for _, d in ipairs(data) do
        for _, h in ipairs(d.hidden) do
            if not constraintCount[h] then constraintCount[h] = 0; mineSum[h] = 0 end
            constraintCount[h] = constraintCount[h] + 1
            mineSum[h] = mineSum[h] + (d.eVal / math.max(#d.hidden, 1))
        end
    end
    
    for cell, count in pairs(constraintCount) do
        probabilities[cell] = math.clamp(mineSum[cell] / count, 0, 1)
    end
    
    return probabilities
end

local function renderHeatmap(probabilities, excludeCells)
    for _, p in pairs(heatmapParts) do if p and p.Parent then p:Destroy() end end
    heatmapParts = {}
    
    if not heatmapEnabled then return end
    excludeCells = excludeCells or {}
    
    for cell, prob in pairs(probabilities) do
        if cell and cell.Parent and not isCellOpen(cell) then
            if cell.Color == Color3.new(0,0,0) or cell.Color == Color3.new(1,1,1) then
                continue
            end
            if excludeCells[cell] then
                continue
            end
            
            local hue = (1 - prob) * 0.33
            local color = Color3.fromHSV(hue, 0.8, 0.9)
            
            local overlay = Instance.new("Part")
            overlay.Name = "HeatmapOverlay"
            overlay.Size = Vector3.new(cell.Size.X * 0.9, 0.1, cell.Size.Z * 0.9)
            overlay.CFrame = cell.CFrame * CFrame.new(0, cell.Size.Y / 2 + 0.05, 0)
            overlay.Anchored = true
            overlay.CanCollide = false
            overlay.Material = Enum.Material.Neon
            overlay.Color = color
            overlay.Transparency = 0.4
            overlay.Parent = workspace
            
            table.insert(heatmapParts, overlay)
        end
    end
end

local function updateMineOverlays()
    if not mineMarkersEnabled then
        for _, g in pairs(mineOverlays) do if g and g.Parent then g:Destroy() end end
        mineOverlays = {}
        return
    end
    
    local folder = workspace:FindFirstChild("Flag") and workspace.Flag:FindFirstChild("Parts")
    if not folder then return end
    
    local currentMines = {}
    for _, cell in ipairs(folder:GetChildren()) do
        if cell.Color == Color3.new(0,0,0) and not isCellOpen(cell) then
            currentMines[cell] = true
            if not mineOverlays[cell] then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "MineMarker"
                billboard.Size = UDim2.new(0, 30, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = cell
                billboard.Parent = cell
                
                local icon = Instance.new("TextLabel", billboard)
                icon.Size = UDim2.new(1, 0, 1, 0)
                icon.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
                icon.BackgroundTransparency = 0.2
                icon.Text = "⚠"
                icon.TextColor3 = Color3.new(1, 1, 1)
                icon.Font = Enum.Font.GothamBold
                icon.TextSize = 18
                icon.TextScaled = false
                
                local corner = Instance.new("UICorner", icon)
                corner.CornerRadius = UDim.new(0.2, 0)
                
                mineOverlays[cell] = billboard
            end
        end
    end
    
    for cell, gui in pairs(mineOverlays) do
        if not currentMines[cell] then
            if gui and gui.Parent then gui:Destroy() end
            mineOverlays[cell] = nil
        end
    end
end

local function clearHeatmap()
    for _, p in pairs(heatmapParts) do if p and p.Parent then p:Destroy() end end
    heatmapParts = {}
end

local function clearMineOverlays()
    for _, g in pairs(mineOverlays) do if g and g.Parent then g:Destroy() end end
    mineOverlays = {}
end

local function revertColors()
    local folder = workspace:FindFirstChild("Flag") and workspace.Flag:FindFirstChild("Parts")
    if not folder then return end
    for _, cell in ipairs(folder:GetChildren()) do
        if coloredCells[cell] and cell.Parent then
            if cell.Color == Color3.new(0,0,0) or cell.Color == Color3.new(1,1,1) then
                cell.Color = coloredCells[cell]
            end
        end
    end
    coloredCells = {}
end

function mainLoop()
    if stopCurrentExecution then return end
    if currentTab == "legit" and not calcOnceTriggered then
        if tick() - lastCalcTime < calculateDelay then return end
    end
    if (not isAutoSolving and currentTab ~= "legit" and not calcOnceTriggered) or isWaitingForRound then return end
    
    local timeSinceProgress = tick() - lastProgressTime
    if timeSinceProgress > 1 and tick() - lastCalcTime < 0.5 then return end
    lastCalcTime = tick()
    local data = getSolverData()
    local safeQueue, mineQueue, riskyCells = {}, {}, {}
    local foundAnything = false

    for i = 1, #data do
        for j = 1, #data do
            if i ~= j then
                local d1, d2 = data[i], data[j]
                if (d1.obj.Position - d2.obj.Position).Magnitude < 12 then
                    local s1, s2 = d1.hidden, d2.hidden
                    if #s2 > #s1 then
                        local set1, set2 = {}, {}
                        for _, x in ipairs(s1) do set1[x] = true end
                        for _, x in ipairs(s2) do set2[x] = true end

                        local isSubset = true
                        for _, x in ipairs(s1) do
                            if not set2[x] then isSubset = false; break end
                        end

                        if isSubset then
                            local diffMines = d2.eVal - d1.eVal
                            local diffCells = {}
                            for _, x in ipairs(s2) do
                                if not set1[x] then diffCells[#diffCells + 1] = x end
                            end
                        if diffMines == 0 then
                            for _, n in ipairs(diffCells) do table.insert(safeQueue, n); foundAnything = true end
                        elseif diffMines == #diffCells then
                            for _, n in ipairs(diffCells) do table.insert(mineQueue, n); foundAnything = true end
                        end
                        end
                    end
                end
            end
        end
    end

    local basicSafe, basicMines = {}, {}
    for _, d in ipairs(data) do
        if #d.hidden > 0 then
            if #d.hidden == d.eVal then
                for _, n in ipairs(d.hidden) do table.insert(basicMines, n); foundAnything = true end
            elseif d.eVal <= 0 then
                for _, n in ipairs(d.hidden) do table.insert(basicSafe, n); foundAnything = true end
            end
        end
    end

    if currentTab == "rage" and isAutoSolving then
        for _, m in ipairs(mineQueue) do m.Color = Color3.new(0,0,0) end
        for _, m in ipairs(basicMines) do m.Color = Color3.new(0,0,0) end
        local targetQueue = #safeQueue > 0 and safeQueue or basicSafe
        if #targetQueue > 0 then
            isGuessing = false
            lastProgressTime = tick()
            for _, s in ipairs(targetQueue) do 
                if stopCurrentExecution or not isAutoSolving then break end 
                if not isCellOpen(s) then teleportTo(s); task.wait(actionDelay) end
            end
        elseif autoGuess and not foundAnything and tick() - lastActionTime > 0.8 then
            for _, d in ipairs(data) do for _, n in ipairs(d.hidden) do if n.Color ~= Color3.new(0,0,0) then riskyCells[n] = (riskyCells[n] or 0) + 1 end end end
            local best, maxW = nil, -1
            for c, w in pairs(riskyCells) do if w > maxW then maxW = w; best = c end end
            if best then isGuessing = true; teleportTo(best); lastActionTime = tick(); lastProgressTime = tick() end
        end
    elseif currentTab == "legit" or calcOnceTriggered then
        local finalMines = (calculationMode == "euler" and #mineQueue > 0) and mineQueue or basicMines
        local finalSafe = (calculationMode == "euler" and #safeQueue > 0) and safeQueue or basicSafe
        
        local excludeFromHeatmap = {}
        for _, m in ipairs(finalMines) do excludeFromHeatmap[m] = true end
        for _, s in ipairs(finalSafe) do excludeFromHeatmap[s] = true end
        
        if heatmapEnabled then
            local probs = calculateProbabilities(data)
            renderHeatmap(probs, excludeFromHeatmap)
        end
        
        if mineMarkersEnabled then
            for _, m in ipairs(finalMines) do 
                if not coloredCells[m] then coloredCells[m] = m.Color end
                m.Color = Color3.new(0, 0, 0)
            end
            
            for _, s in ipairs(finalSafe) do 
                if not coloredCells[s] then coloredCells[s] = s.Color end
                s.Color = Color3.new(1, 1, 1) 
            end
            
            updateMineOverlays()
        end
        
        calcOnceTriggered = false
    end
end

local sideBar = Instance.new("Frame", mainBody)
sideBar.Size = UDim2.new(0, 80, 1, -10)
sideBar.Position = UDim2.new(0, 5, 0, 5)
sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sideBar.BorderSizePixel = 0
local sideBarCorner = Instance.new("UICorner", sideBar)
sideBarCorner.CornerRadius = UDim.new(0, 4)

local rageTabBtn = Instance.new("TextButton", sideBar)
rageTabBtn.Size = UDim2.new(1, -10, 0, 40)
rageTabBtn.Position = UDim2.new(0, 5, 0, 5)
rageTabBtn.Text = "rage"
rageTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rageTabBtn.TextColor3 = Color3.new(1, 1, 1)
rageTabBtn.Font = Enum.Font.GothamBold
rageTabBtn.TextSize = 12
rageTabBtn.BorderSizePixel = 0
local rageCorner = Instance.new("UICorner", rageTabBtn)
rageCorner.CornerRadius = UDim.new(0, 4)

local legitTabBtn = Instance.new("TextButton", sideBar)
legitTabBtn.Size = UDim2.new(1, -10, 0, 40)
legitTabBtn.Position = UDim2.new(0, 5, 0, 50)
legitTabBtn.Text = "legit"
legitTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
legitTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
legitTabBtn.Font = Enum.Font.GothamBold
legitTabBtn.TextSize = 12
legitTabBtn.BorderSizePixel = 0
local legitCorner = Instance.new("UICorner", legitTabBtn)
legitCorner.CornerRadius = UDim.new(0, 4)

local eventTabBtn = Instance.new("TextButton", sideBar)
eventTabBtn.Size = UDim2.new(1, -10, 0, 40)
eventTabBtn.Position = UDim2.new(0, 5, 0, 95)
eventTabBtn.Text = "event"
eventTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
eventTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
eventTabBtn.Font = Enum.Font.GothamBold
eventTabBtn.TextSize = 12
eventTabBtn.BorderSizePixel = 0
local eventCorner = Instance.new("UICorner", eventTabBtn)
eventCorner.CornerRadius = UDim.new(0, 4)

local rageFrame = Instance.new("Frame", mainBody)
rageFrame.Size = UDim2.new(1, -100, 1, -20)
rageFrame.Position = UDim2.new(0, 90, 0, 10)
rageFrame.BackgroundTransparency = 1

local legitFrame = Instance.new("Frame", mainBody)
legitFrame.Size = UDim2.new(1, -100, 1, -20)
legitFrame.Position = UDim2.new(0, 90, 0, 10)
legitFrame.BackgroundTransparency = 1
legitFrame.Visible = false

local eventFrame = Instance.new("Frame", mainBody)
eventFrame.Size = UDim2.new(1, -100, 1, -20)
eventFrame.Position = UDim2.new(0, 90, 0, 10)
eventFrame.BackgroundTransparency = 1
eventFrame.Visible = false

statusRage = Instance.new("TextButton", rageFrame)
statusRage.Size = UDim2.new(1, 0, 0, 32)
statusRage.Font = Enum.Font.GothamBold
statusRage.BorderSizePixel = 0

local function createStrictToggle(parent, text, pos, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0, 120, 1, 0)
    lbl.Text = text:lower()
    lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local bg = Instance.new("Frame", frame)
    bg.Size = UDim2.new(0, 34, 0, 16)
    bg.Position = UDim2.new(1, -34, 0.5, -8)
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BorderSizePixel = 1
    bg.BorderColor3 = Color3.fromRGB(50, 50, 50)
    local box = Instance.new("Frame", bg)
    box.Size = UDim2.new(0, 8, 0, 8)
    box.Position = default and UDim2.new(1, -11, 0.5, -4) or UDim2.new(0, 3, 0.5, -4)
    box.BackgroundColor3 = default and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(60, 60, 60)
    box.BorderSizePixel = 0
    local btn = Instance.new("TextButton", bg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        default = not default
        box.Position = default and UDim2.new(1, -11, 0.5, -4) or UDim2.new(0, 3, 0.5, -4)
        box.BackgroundColor3 = default and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(60, 60, 60)
        callback(default)
    end)
end

local function createStrictSlider(parent, text, pos, minV, maxV, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, 0, 0, 15)
    lbl.Text = text:lower()
    lbl.TextColor3 = Color3.fromRGB(130, 130, 130)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.BackgroundTransparency = 1
    local sBack = Instance.new("Frame", frame)
    sBack.Size = UDim2.new(1, -60, 0, 1)
    sBack.Position = UDim2.new(0, 0, 0, 30)
    sBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sBack.BorderSizePixel = 0
    local sBtn = Instance.new("Frame", sBack)
    sBtn.Size = UDim2.new(0, 2, 0, 10)
    sBtn.Position = UDim2.new((default - minV)/(maxV - minV), -1, 0.5, -5)
    sBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sBtn.BorderSizePixel = 0
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 50, 0, 20)
    input.Position = UDim2.new(1, -50, 0, 21)
    input.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(40, 40, 40)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Code
    input.TextSize = 11
    local function update(val)
        val = math.clamp(math.round(val * 100) / 100, minV, maxV)
        input.Text = tostring(val)
        sBtn.Position = UDim2.new((val - minV)/(maxV - minV), -1, 0.5, -5)
        callback(val)
    end
    local dragBtn = Instance.new("TextButton", sBack)
    dragBtn.Size = UDim2.new(1, 20, 1, 30)
    dragBtn.Position = UDim2.new(0, -10, 0, -15)
    dragBtn.BackgroundTransparency = 1
    dragBtn.Text = ""
    local dragging = false
    dragBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((i.Position.X - sBack.AbsolutePosition.X) / sBack.AbsoluteSize.X, 0, 1)
            update(minV + (maxV - minV) * rel)
        end
    end)
    input.FocusLost:Connect(function() update(tonumber(input.Text) or default) end)
end

statusRage.MouseButton1Click:Connect(function() isAutoSolving = not isAutoSolving; isWaitingForRound = false; updatePhysics(); refreshStatusUI() end)

createStrictToggle(rageFrame, "freeze", UDim2.new(0,0,0,45), freezeEnabled, function(v) freezeEnabled = v; updatePhysics() end)
createStrictToggle(rageFrame, "auto guess", UDim2.new(0,0,0,75), autoGuess, function(v) autoGuess = v end)
createStrictSlider(rageFrame, "action delay", UDim2.new(0,0,0,110), 0, 2, actionDelay, function(v) actionDelay = v end)
createStrictSlider(rageFrame, "spawn delay", UDim2.new(0,0,0,160), 0, 60, startDelayTime, function(v) startDelayTime = v end)

createStrictSlider(legitFrame, "calculate delay", UDim2.new(0,0,0,10), 0.05, 5, calculateDelay, function(v) calculateDelay = v end)
createStrictToggle(legitFrame, "heatmap", UDim2.new(0,0,0,60), heatmapEnabled, function(v) heatmapEnabled = v; if not v then clearHeatmap() end end)
createStrictToggle(legitFrame, "mine markers", UDim2.new(0,0,0,90), mineMarkersEnabled, function(v) mineMarkersEnabled = v; if not v then clearMineOverlays(); revertColors() end end)

createStrictToggle(eventFrame, "collect presents", UDim2.new(0,0,0,10), collectPresentsEnabled, function(v) collectPresentsEnabled = v end)

rageTabBtn.MouseButton1Click:Connect(function()
    currentTab = "rage"
    rageFrame.Visible, legitFrame.Visible, eventFrame.Visible = true, false, false
    rageTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    rageTabBtn.TextColor3 = Color3.new(1, 1, 1)
    legitTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    legitTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    eventTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    eventTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    updatePhysics(); refreshStatusUI()
end)

legitTabBtn.MouseButton1Click:Connect(function()
    currentTab = "legit"
    rageFrame.Visible, legitFrame.Visible, eventFrame.Visible = false, true, false
    legitTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    legitTabBtn.TextColor3 = Color3.new(1, 1, 1)
    rageTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    rageTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    eventTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    eventTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    updatePhysics(); refreshStatusUI()
end)

eventTabBtn.MouseButton1Click:Connect(function()
    currentTab = "event"
    rageFrame.Visible, legitFrame.Visible, eventFrame.Visible = false, false, true
    eventTabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    eventTabBtn.TextColor3 = Color3.new(1, 1, 1)
    rageTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    rageTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    legitTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    legitTabBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
    updatePhysics(); refreshStatusUI()
end)

player.CharacterAdded:Connect(function()
    if isAutoSolving or currentTab == "legit" then
        isWaitingForRound = true; waitTimeLeft = startDelayTime
        task.spawn(function()
            while waitTimeLeft > 0 do 
                refreshStatusUI()
                task.wait(0.1)
                waitTimeLeft = waitTimeLeft - 0.1 
            end
            isWaitingForRound = false; neighborCache = {}; solverFolderCache = nil; updatePhysics(); refreshStatusUI()
        end)
    end
end)

refreshStatusUI()
task.spawn(function()
    while true do
        local ok, err = pcall(mainLoop)
        if not ok then
            warn("[autosolver] mainLoop error:", err)
        end
        task.wait(0.05)
    end
end)
chatNotify("loaded.")
