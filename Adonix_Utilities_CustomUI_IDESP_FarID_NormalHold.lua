--[[
    CustomHub - Pure Roblox UI (No Rayfield / No External Libraries)
    Updated: August 2026
    
    Features:
    - Fully Instance-based (ScreenGui, Frame, TextButton, TextLabel, etc.)
    - Draggable window
    - Minimize / Close
    - Sidebar tabs
    - Buttons, Toggles, Sections, Labels
    - Smooth tweens
    - Clean dark theme
]]

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Destroy old UI if it exists
if playerGui:FindFirstChild("CustomHub") then
	playerGui.CustomHub:Destroy()
end

--// Main ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = playerGui

--// Main Window
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 540, 0, 360)
Main.Position = UDim2.new(0.5, -270, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 58)
MainStroke.Thickness = 1.2
MainStroke.Parent = Main

--// Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 46)
TitleBar.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 14)
TitleBarCorner.Parent = TitleBar

-- Bottom fix so only top corners are rounded
local TitleBarFix = Instance.new("Frame")
TitleBarFix.Size = UDim2.new(1, 0, 0, 14)
TitleBarFix.Position = UDim2.new(0, 0, 1, -14)
TitleBarFix.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
TitleBarFix.BorderSizePixel = 0
TitleBarFix.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -110, 1, 0)
Title.Position = UDim2.new(0, 18, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Custom Hub"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 17
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Close button removed; the remaining title-bar button minimizes the UI.

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -42, 0.5, -17)
MinBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
MinBtn.Text = "–"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 20
MinBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
MinBtn.AutoButtonColor = false
MinBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 9)
MinCorner.Parent = MinBtn

local minimized = false
local originalSize = UDim2.new(0, 540, 0, 360)

MinBtn.MouseEnter:Connect(function()
	TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 80)}):Play()
end)
MinBtn.MouseLeave:Connect(function()
	TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 42, 55)}):Play()
end)

MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 540, 0, 46)}):Play()
	else
		TweenService:Create(Main, TweenInfo.new(0.28, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
	end
end)

--// Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 148, 1, -46)
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 7)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 14)
SidebarPadding.PaddingLeft = UDim.new(0, 12)
SidebarPadding.PaddingRight = UDim.new(0, 12)
SidebarPadding.Parent = Sidebar

--// Content Area
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -148, 1, -46)
Content.Position = UDim2.new(0, 148, 0, 46)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
Content.BorderSizePixel = 0
Content.ClipsDescendants = true
Content.Parent = Main

--// Helper Functions
local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
	btn.Text = name
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(195, 195, 210)
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = Sidebar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = btn

	return btn
end

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 5
	page.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 95)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = Content

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 11)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 16)
	padding.PaddingLeft = UDim.new(0, 16)
	padding.PaddingRight = UDim.new(0, 16)
	padding.PaddingBottom = UDim.new(0, 16)
	padding.Parent = page

	return page
end

local function createSection(parent, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 22)
	label.BackgroundTransparency = 1
	label.Text = string.upper(text)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 12
	label.TextColor3 = Color3.fromRGB(130, 130, 155)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
	btn.Text = text
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(235, 235, 245)
	btn.AutoButtonColor = false
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(38, 38, 52)}):Play()
	end)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

local function createToggle(parent, text, default, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 42)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0)
	label.Position = UDim2.new(0, 14, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(225, 225, 235)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local toggleBg = Instance.new("Frame")
	toggleBg.Size = UDim2.new(0, 46, 0, 24)
	toggleBg.Position = UDim2.new(1, -58, 0.5, -12)
	toggleBg.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(48, 48, 62)
	toggleBg.Parent = frame

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleBg

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 18, 0, 18)
	circle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.Parent = toggleBg

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	local enabled = default
	local hitbox = Instance.new("TextButton")
	hitbox.Size = UDim2.new(1, 0, 1, 0)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.Parent = frame

	hitbox.MouseButton1Click:Connect(function()
		enabled = not enabled
		TweenService:Create(toggleBg, TweenInfo.new(0.2), {
			BackgroundColor3 = enabled and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(48, 48, 62)
		}):Play()
		TweenService:Create(circle, TweenInfo.new(0.2), {
			Position = enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
		}):Play()
		callback(enabled)
	end)

	return frame
end

local function createLabel(parent, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextColor3 = Color3.fromRGB(170, 170, 190)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent
	return label
end

--// Dragging
local dragging = false
local dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// Adonix compatibility layer for the custom Instance-based UI
Title.Text = "Adonix Utilities"

local Rayfield = {}

local function notify(data)
	local titleText = data.Title or "Adonix Utilities"
	local contentText = data.Content or ""
	local duration = data.Duration or 3

	local holder = Instance.new("Frame")
	holder.Size = UDim2.new(0, 300, 0, 78)
	holder.Position = UDim2.new(1, -320, 1, -100)
	holder.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	holder.BorderSizePixel = 0
	holder.Parent = ScreenGui
	holder.ZIndex = 50
	Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 130, 255)
	stroke.Parent = holder

	local nt = Instance.new("TextLabel")
	nt.Size = UDim2.new(1, -24, 0, 26)
	nt.Position = UDim2.new(0, 12, 0, 8)
	nt.BackgroundTransparency = 1
	nt.Text = titleText
	nt.Font = Enum.Font.GothamBold
	nt.TextSize = 14
	nt.TextColor3 = Color3.fromRGB(245,245,250)
	nt.TextXAlignment = Enum.TextXAlignment.Left
	nt.ZIndex = 51
	nt.Parent = holder

	local nc = Instance.new("TextLabel")
	nc.Size = UDim2.new(1, -24, 0, 36)
	nc.Position = UDim2.new(0, 12, 0, 32)
	nc.BackgroundTransparency = 1
	nc.Text = contentText
	nc.TextWrapped = true
	nc.Font = Enum.Font.Gotham
	nc.TextSize = 12
	nc.TextColor3 = Color3.fromRGB(190,190,205)
	nc.TextXAlignment = Enum.TextXAlignment.Left
	nc.TextYAlignment = Enum.TextYAlignment.Top
	nc.ZIndex = 51
	nc.Parent = holder

	TweenService:Create(holder, TweenInfo.new(0.2), {Position = UDim2.new(1, -320, 1, -120)}):Play()
	task.delay(duration, function()
		if holder.Parent then
			local tween = TweenService:Create(holder, TweenInfo.new(0.2), {Position = UDim2.new(1, 20, 1, -120)})
			tween:Play()
			tween.Completed:Wait()
			holder:Destroy()
		end
	end)
end

function Rayfield:Notify(data)
	notify(data)
end

local Window = {}
local pages, tabButtons = {}, {}

function Window:CreateTab(name)
	local btn = createTabButton(name, #tabButtons + 1)
	local page = createPage(name)
	pages[name], tabButtons[name] = page, btn

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Visible = false end
		for _, b in pairs(tabButtons) do
			b.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
			b.TextColor3 = Color3.fromRGB(195, 195, 210)
		end
		page.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(55, 105, 230)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
	end)

	if not Window._firstTab then
		Window._firstTab = name
		page.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(55, 105, 230)
		btn.TextColor3 = Color3.fromRGB(255,255,255)
	end

	local Tab = {}
	function Tab:CreateSection(text)
		return createSection(page, text)
	end
	function Tab:CreateButton(data)
		return createButton(page, data.Name or "Button", data.Callback or function() end)
	end
	function Tab:CreateToggle(data)
		return createToggle(page, data.Name or "Toggle", data.CurrentValue or false, data.Callback or function() end)
	end
	function Tab:CreateLabel(text)
		local label = createLabel(page, text)
		local object = {}
		function object:Set(newText)
			label.Text = newText
		end
		return object
	end
	function Tab:CreateInput(data)
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1, 0, 0, 40)
		box.BackgroundColor3 = Color3.fromRGB(30,30,40)
		box.PlaceholderText = data.PlaceholderText or ""
		box.Text = ""
		box.ClearTextOnFocus = false
		box.Font = Enum.Font.Gotham
		box.TextSize = 13
		box.TextColor3 = Color3.fromRGB(235,235,245)
		box.PlaceholderColor3 = Color3.fromRGB(135,135,155)
		box.Parent = page
		Instance.new("UICorner", box).CornerRadius = UDim.new(0,9)
		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0,12)
		pad.PaddingRight = UDim.new(0,12)
		pad.Parent = box
		box.FocusLost:Connect(function()
			local text = box.Text
			if data.Callback then data.Callback(text) end
			if data.RemoveTextAfterFocusLost then box.Text = "" end
		end)
		return box
	end
	function Tab:CreateKeybind(data)
		local keyName = data.CurrentKeybind or "K"
		local keyCode = Enum.KeyCode[keyName] or Enum.KeyCode.K
		createButton(page, (data.Name or "Keybind") .. " [" .. keyName .. "]", function() end)
		UserInputService.InputBegan:Connect(function(input, processed)
			if not processed and input.KeyCode == keyCode and data.KeybindCallback then
				data.KeybindCallback(keyName)
			end
		end)
	end
	return Tab
end

function Window:ToggleUI()
	Main.Visible = not Main.Visible
end

function Rayfield:CreateWindow(data)
	Title.Text = data.Name or "Adonix Utilities"
	return Window
end

-- Initialize compatibility window
Window = Rayfield:CreateWindow({Name = "Adonix Utilities"})


-- ===== ADONIX FEATURES: ONLY REQUESTED FEATURES =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local NoclipConnection = nil
local DetectionActive = false
local KiraList, TakaList, LList = {}, {}, {}
local Connections = {}
local ESPEnabled = false
local ESPHighlights, ESPConnections = {}, {}
local ObjectESPEnabled = {IDs = false, YourID = false}
local ObjectESPHighlights, ObjectESPConnections = {}, {}
local KiraESPEnabled = false
local KiraESPHighlights, KiraESPConnection = {}, nil

local GameFolder = ReplicatedStorage:WaitForChild("Game", 10)
local Gamemode = GameFolder and GameFolder:WaitForChild("Gamemode", 5)
local Timer = GameFolder and GameFolder:WaitForChild("Timer", 5)
local GamePhase = GameFolder and GameFolder:WaitForChild("GamePhase", 5)

local function truncateText(text, maxLength)
    text = tostring(text or "")
    return #text <= maxLength and text or string.sub(text, 1, maxLength - 3) .. "..."
end

local function formatPlayerName(player)
    if not player then return "Unknown" end
    return truncateText(player.DisplayName, 12) .. " (" .. truncateText(player.Name, 10) .. ")"
end

local function notify(title, content, duration)
    Rayfield:Notify({Title = title, Content = content, Duration = duration or 3})
end

local function FetchCurrentId(Map, SpecifiedClient)
    if not Map or not SpecifiedClient then return nil end
    for _, v in Map:GetChildren() do
        if v.Name == "Id" then
            local sg = v:FindFirstChild("SurfaceGui")
            local frame = sg and sg:FindFirstChild("Frame")
            local pn = frame and frame:FindFirstChild("PlayerName")
            if pn and sg.Enabled and (pn.Text == SpecifiedClient.Name or pn.Text == SpecifiedClient.DisplayName) then
                return v
            end
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                    for _, sub in pairs(child:GetDescendants()) do
                        if sub:IsA("TextLabel") and (sub.Text == SpecifiedClient.Name or sub.Text == SpecifiedClient.DisplayName) then
                            return v
                        end
                    end
                end
            end
            if v:FindFirstChild("IdPrompt") then
                local closest, dist = nil, math.huge
                for _, player in pairs(Players:GetPlayers()) do
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local d = (root.Position - v.Position).Magnitude
                        if d < dist then closest, dist = player, d end
                    end
                end
                if closest == SpecifiedClient and dist < 10 then return v end
            end
        end
    end
    return nil
end

local function closestPlayerAtPos(position)
    local closest, maxRange = nil, math.huge
    for _, player in Players:GetPlayers() do
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local d = (root.Position - position).Magnitude
            if d < maxRange then closest, maxRange = player.Character, d end
        end
    end
    return closest
end

local function FodderClipManagement(enabled, delayTime)
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = not enabled end
    end
    if delayTime then task.delay(delayTime, function() FodderClipManagement(not enabled) end) end
end

local function clearConnections(list)
    for _, con in pairs(list) do
        if con and con.Disconnect then con:Disconnect() end
    end
    table.clear(list)
end

local function CheckForDnOnEachCurrentPlayer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            table.insert(Connections, plr.Character.ChildAdded:Connect(function(child)
                if child.Name == "DeathNoteBook" and not table.find(KiraList, plr) then
                    table.insert(KiraList, plr)
                end
            end))
        end
    end
end

local function CheckForIdsTaken(CMap)
    if not CMap then return end
    for _, v in CMap:GetChildren() do
        if v.Name == "Id" then
            local surfaceGui = v:FindFirstChild("SurfaceGui")
            if surfaceGui then
                table.insert(Connections, surfaceGui:GetPropertyChangedSignal("Enabled"):Connect(function()
                    local kiraChar = closestPlayerAtPos(v.Position)
                    if kiraChar and Timer and Timer.Value < 178.5 and GamePhase and GamePhase.Value == "IdScatter" then
                        local plr = Players:GetPlayerFromCharacter(kiraChar)
                        if plr and not table.find(TakaList, plr) then table.insert(TakaList, plr) end
                    end
                end))
            end
        end
    end
end

local function GetMisaNames()
    local result = {}
    local function scan(folder)
        if not folder then return end
        for _, name in pairs(folder:GetChildren()) do
            if name.Value ~= nil then result[tostring(name.Value)] = name.Name end
        end
    end
    if GameFolder and GameFolder:FindFirstChild("FolderForNames") then scan(GameFolder.FolderForNames) end
    if next(result) == nil and GameFolder then
        for _, folder in pairs(GameFolder:GetChildren()) do
            if folder:IsA("Folder") and (folder.Name:find("Name") or folder.Name:find("Misa") or folder.Name:find("Code")) then scan(folder) end
        end
    end
    if next(result) == nil then
        for _, folder in pairs(ReplicatedStorage:GetChildren()) do
            if folder:IsA("Folder") and (folder.Name:find("Name") or folder.Name:find("Misa") or folder.Name:find("Code")) then scan(folder) end
        end
    end
    return result
end

local function MatchNameToPlayer(name)
    name = tostring(name or ""):lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower() == name or plr.DisplayName:lower() == name then return plr end
    end
end

local function TryAndFetchL()
    local chances = {}
    LList = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if not table.find(KiraList, plr) and not table.find(TakaList, plr) then
            local valueObj = plr:FindFirstChild("LChance_Weight") or plr:FindFirstChild("LChance") or plr:FindFirstChild("LWeight")
            if valueObj and valueObj.Value ~= nil then table.insert(chances, {Player = plr, Value = valueObj.Value}) end
        end
    end
    table.sort(chances, function(a,b) return a.Value > b.Value end)
    if #chances > 0 then
        local highest = chances[1].Value
        for _, data in pairs(chances) do
            if data.Value == highest then table.insert(LList, data.Player) else break end
        end
    end
    return LList
end

local function updateDetectionLabels()
    local function listText(list)
        if #list == 0 then return "None" end
        local out = {}
        for _, plr in ipairs(list) do table.insert(out, formatPlayerName(plr)) end
        return table.concat(out, " | ")
    end
    KiraLabel:Set("Kira (" .. #KiraList .. "): " .. listText(KiraList))
    IDLabel:Set("ID (" .. #TakaList .. "): " .. listText(TakaList))
    LLabel:Set("L (" .. #LList .. "): " .. listText(LList))
    StatsLabel:Set("K:" .. #KiraList .. "/4 | ID:" .. #TakaList .. " | L:" .. #LList)
end

local function startDetection()
    local map = workspace:FindFirstChild("Map")
    if not map then notify("Error", "Map not found - wait for the game to start", 3); return end
    if DetectionActive then notify("Detection", "Detection is already active", 2); return end
    DetectionActive = true
    StatusLabel:Set("Status: Active")
    KiraList, TakaList, LList = {}, {}, {}
    CheckForIdsTaken(map)
    CheckForDnOnEachCurrentPlayer()
    notify("Detection Started", "Kira / ID / L detection activated", 3)
    task.spawn(function()
        while DetectionActive do
            TryAndFetchL()
            updateDetectionLabels()
            task.wait(2)
        end
    end)
end

local function clearDetection()
    DetectionActive = false
    KiraList, TakaList, LList = {}, {}, {}
    clearConnections(Connections)
    StatusLabel:Set("Status: Ready")
    updateDetectionLabels()
    notify("Cleared", "Detection data cleared", 2)
end

local function teleportToCFrame(cf, message)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then notify("Error", "You need a character", 3); return end
    FodderClipManagement(true, 1)
    root.CFrame = cf
    notify("Teleported", message, 2)
end

local function tpYourId()
    local map = workspace:FindFirstChild("Map")
    if not map then notify("Error", "Map not found", 3); return end
    local id = FetchCurrentId(map, LocalPlayer)
    if id then
        teleportToCFrame(id.CFrame * CFrame.new(0,3,0), "Teleported to your ID")
        return
    end
    for _, candidate in pairs(map:GetChildren()) do
        if candidate.Name == "Id" then
            local claimed = false
            for _, plr in pairs(Players:GetPlayers()) do
                if FetchCurrentId(map, plr) == candidate then claimed = true; break end
            end
            if not claimed then
                teleportToCFrame(candidate.CFrame * CFrame.new(0,3,0), "Teleported to an unclaimed ID")
                return
            end
        end
    end
    notify("Error", "No available IDs found", 3)
end

local function tpPlayer(name)
    local plr = MatchNameToPlayer(name)
    if not plr then notify("Error", "Player not found: " .. tostring(name), 3); return end
    local map = workspace:FindFirstChild("Map")
    local id = map and FetchCurrentId(map, plr)
    if id then
        teleportToCFrame(id.CFrame * CFrame.new(0,3,0), "Teleported to " .. plr.DisplayName .. "'s ID")
    elseif plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        teleportToCFrame(plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3), "Teleported to " .. plr.DisplayName)
    else
        notify("Error", plr.DisplayName .. " has no character", 3)
    end
end

local function setNoclip(enabled)
    if NoclipConnection then NoclipConnection:Disconnect(); NoclipConnection = nil end
    if enabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        notify("Noclip", "Enabled", 2)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
        notify("Noclip", "Disabled", 2)
    end
end

local function FillStashList()
    local list = {}
    local map = workspace:FindFirstChild("Map")
    if map then for _, v in pairs(map:GetChildren()) do if v.Name == "Crate" then table.insert(list, v) end end end
    return list
end

local function AutoSearch()
    if not (GamePhase and GamePhase.Value == "Search") then notify("Error", "Not in searching phase", 3); return end
    local crates = FillStashList()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then notify("Error", "Character not found", 3); return end
    task.spawn(function()
        for _, crate in pairs(crates) do
            if not (GamePhase and GamePhase.Value == "Search") then break end
            if crate and crate.Parent then
                root.CFrame = crate.CFrame * CFrame.new(0,1,0)
                if keypress and keyrelease then
                    keypress(0x45); task.wait(0.2); keyrelease(0x45)
                end
                task.wait(0.2)
            end
        end
        notify("Auto Search", "Finished scanning crates", 2)
    end)
    notify("Auto Search", "Searching for Death Note...", 3)
end

-- Player ESP
local function clearESP()
    ESPEnabled = false
    clearConnections(ESPConnections)
    for _, h in pairs(ESPHighlights) do if h and h.Parent then h:Destroy() end end
    table.clear(ESPHighlights)
end

local function addPlayerHighlight(player)
    if player == LocalPlayer or not player.Character then return end
    local old = player.Character:FindFirstChild("AdonixPlayerESP")
    if old then old:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "AdonixPlayerESP"
    h.FillColor = Color3.fromRGB(255,255,255)
    h.OutlineColor = Color3.fromRGB(0,0,0)
    h.Parent = player.Character
    table.insert(ESPHighlights, h)
end

local function toggleESP(enabled)
    if not enabled then clearESP(); return end
    clearESP(); ESPEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do addPlayerHighlight(plr) end
    table.insert(ESPConnections, Players.PlayerAdded:Connect(function(plr)
        table.insert(ESPConnections, plr.CharacterAdded:Connect(function() if ESPEnabled then task.wait(0.5); addPlayerHighlight(plr) end end))
    end))
    for _, plr in pairs(Players:GetPlayers()) do
        table.insert(ESPConnections, plr.CharacterAdded:Connect(function() if ESPEnabled then task.wait(0.5); addPlayerHighlight(plr) end end))
    end
end

-- IDs / Your ID ESP
local function clearObjectESP()
    clearConnections(ObjectESPConnections)
    for _, h in pairs(ObjectESPHighlights) do if h and h.Parent then h:Destroy() end end
    table.clear(ObjectESPHighlights)
end

local function highlightSingleId(id)
    if not (ObjectESPEnabled.IDs or ObjectESPEnabled.YourID) then return end
    local map = workspace:FindFirstChild("Map")
    local myId = ObjectESPEnabled.YourID and map and FetchCurrentId(map, LocalPlayer) == id
    local claimed = false
    if not myId and map then
        for _, plr in pairs(Players:GetPlayers()) do
            if FetchCurrentId(map, plr) == id then claimed = true; break end
        end
    end
    if myId or ObjectESPEnabled.IDs then
        local h = Instance.new("Highlight")
        h.Name = "AdonixIdESP"
        h.FillColor = myId and Color3.fromRGB(0,255,60) or (claimed and Color3.fromRGB(120,120,120) or Color3.fromRGB(255,220,0))
        h.OutlineColor = Color3.fromRGB(0,0,0)
        h.Parent = id
        table.insert(ObjectESPHighlights, h)
    end
end

local function setupObjectESP()
    clearObjectESP()
    if not (ObjectESPEnabled.IDs or ObjectESPEnabled.YourID) then return end
    local map = workspace:FindFirstChild("Map")
    if map then
        for _, id in pairs(map:GetChildren()) do if id.Name == "Id" then highlightSingleId(id) end end
    end
    table.insert(ObjectESPConnections, workspace.DescendantAdded:Connect(function(desc)
        if desc.Name == "Id" and desc:IsDescendantOf(workspace:FindFirstChild("Map") or workspace) then task.wait(); highlightSingleId(desc) end
    end))
end

-- Kira ESP
local function clearKiraESP()
    KiraESPEnabled = false
    if KiraESPConnection then KiraESPConnection:Disconnect(); KiraESPConnection = nil end
    for _, h in pairs(KiraESPHighlights) do if h and h.Parent then h:Destroy() end end
    table.clear(KiraESPHighlights)
end

local function refreshKiraESP()
    for _, h in pairs(KiraESPHighlights) do if h and h.Parent then h:Destroy() end end
    table.clear(KiraESPHighlights)
    if not KiraESPEnabled then return end
    for _, plr in pairs(KiraList) do
        if plr.Character then
            local h = Instance.new("Highlight")
            h.Name = "AdonixKiraESP"
            h.FillColor = Color3.fromRGB(255,0,0)
            h.OutlineColor = Color3.fromRGB(100,0,0)
            h.Parent = plr.Character
            table.insert(KiraESPHighlights, h)
        end
    end
end

local function toggleKiraESP(enabled)
    clearKiraESP()
    if enabled then
        KiraESPEnabled = true
        refreshKiraESP()
        KiraESPConnection = RunService.Heartbeat:Connect(function()
            if KiraESPEnabled then refreshKiraESP() end
        end)
    end
end

-- Long-range ID pickup
local LongRangeIDPickup = false
local function setLongRangeIDPickup(enabled)
    LongRangeIDPickup = enabled
    local map = workspace:FindFirstChild("Map")
    if not map then return end
    for _, id in pairs(map:GetChildren()) do
        if id.Name == "Id" then
            local prompt = id:FindFirstChild("IdPrompt")
            if prompt and prompt:IsA("ProximityPrompt") then
                if enabled then
                    prompt.MaxActivationDistance = 100000
                    prompt.RequiresLineOfSight = false
                    prompt.HoldDuration = 0
                else
                    prompt.MaxActivationDistance = 10
                    prompt.RequiresLineOfSight = true
                end
            end
        end
    end
end

-- ========================= UI =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("🔎 Detection")
local StatusLabel = MainTab:CreateLabel("Status: Ready")
local KiraLabel = MainTab:CreateLabel("Kira (0): None")
local IDLabel = MainTab:CreateLabel("ID (0): None")
local LLabel = MainTab:CreateLabel("L (0): None")
MainTab:CreateButton({Name = "Start Detection", Callback = startDetection})
MainTab:CreateButton({Name = "Clear Detection", Callback = clearDetection})

MainTab:CreateSection("📊 Detection Statistics")
local StatsLabel = MainTab:CreateLabel("K:0/4 | ID:0 | L:0")

MainTab:CreateSection("📍 Teleportation")
MainTab:CreateButton({Name = "TP To Your ID", Callback = tpYourId})
MainTab:CreateInput({Name = "TP To Player", PlaceholderText = "Player name", RemoveTextAfterFocusLost = false, Callback = tpPlayer})

MainTab:CreateSection("🚪 Utilities")
MainTab:CreateToggle({Name = "Noclip", CurrentValue = false, Callback = setNoclip})
MainTab:CreateButton({Name = "📓 Auto Search DN", Callback = AutoSearch})
MainTab:CreateButton({Name = "🃏 Misa Codes", Callback = function()
    if Gamemode and Gamemode.Value == "MisaGame" then
        local names = GetMisaNames()
        if next(names) then
            local out = {}
            for playerName, code in pairs(names) do table.insert(out, playerName .. ": " .. code) end
            notify("Misa Codes", table.concat(out, "\n"), 15)
        else notify("Misa Codes", "Waiting for codes to be revealed...", 5) end
    else notify("Error", "Not in Misa game mode.", 3) end
end})

MainTab:CreateSection("👁️ ESP")
MainTab:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = toggleESP})
MainTab:CreateToggle({Name = "🆔 IDs ESP", CurrentValue = false, Callback = function(v) ObjectESPEnabled.IDs = v; setupObjectESP() end})
MainTab:CreateToggle({Name = "🟢 Your ID ESP", CurrentValue = false, Callback = function(v) ObjectESPEnabled.YourID = v; setupObjectESP() end})
MainTab:CreateToggle({Name = "📡 Long Range ID Pickup", CurrentValue = false, Callback = function(v) setLongRangeIDPickup(v); notify("ID Pickup", v and "Long-range ID pickup enabled" or "Long-range ID pickup disabled", 2) end})
MainTab:CreateToggle({Name = "🔴 Kira ESP", CurrentValue = false, Callback = toggleKiraESP})

MainTab:CreateSection("⚙️ Fiddle IDs / Crates")
MainTab:CreateButton({Name = "Fiddle IDs", Callback = function()
    local map = workspace:FindFirstChild("Map")
    if not map then notify("Error", "Map not found", 3); return end
    local count = 0
    for _, id in pairs(map:GetChildren()) do
        if id.Name == "Id" and id:FindFirstChild("IdPrompt") then
            -- Keep the game's normal ID hold duration unchanged
            id.IdPrompt.MaxActivationDistance = 100000
            id.IdPrompt.RequiresLineOfSight = false
            count += 1
        end
    end
    notify("Fiddle IDs", "Modified " .. count .. " ID prompts", 2)
end})
MainTab:CreateButton({Name = "Fiddle Crates", Callback = function()
    local map = workspace:FindFirstChild("Map")
    if not map then notify("Error", "Map not found", 3); return end
    local count = 0
    for _, crate in pairs(map:GetChildren()) do
        if crate.Name == "Crate" and crate:FindFirstChild("BinPrompt") then
            crate.BinPrompt.HoldDuration = 0
            crate.BinPrompt.MaxActivationDistance = 100000
            crate.BinPrompt.RequiresLineOfSight = false
            count += 1
        end
    end
    notify("Fiddle Crates", "Modified " .. count .. " crate prompts", 2)
end})

local CommandTab = Window:CreateTab("Commands")
CommandTab:CreateSection("📝 Command System")
CommandTab:CreateLabel("esp • clearesp • chatlogs • VoteHelp • debugl")
CommandTab:CreateInput({Name = "Execute Command", PlaceholderText = "Enter command", RemoveTextAfterFocusLost = true, Callback = function(text)
    local command = tostring(text):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if command == "esp" then
        toggleESP(true); notify("Command", "Player ESP enabled", 2)
    elseif command == "clearesp" then
        toggleESP(false); notify("Command", "Player ESP disabled", 2)
    elseif command == "chatlogs" then
        notify("Command", "Chatlogs command is not included in this feature-only build.", 3)
    elseif command == "votehelp" then
        local folder = GameFolder and GameFolder:FindFirstChild("VoteoutFolder")
        local max, target = 0, nil
        if folder then
            for _, vote in pairs(folder:GetChildren()) do
                if vote.Value > max then max, target = vote.Value, MatchNameToPlayer(vote.Name) end
            end
        end
        if target then notify("Most Voted Player", target.DisplayName .. " with " .. max .. " votes", 5) else notify("VoteHelp", "Not in a voting round", 3) end
    elseif command == "debugl" then
        local lines = {"L Chance Values:"}
        for _, plr in pairs(Players:GetPlayers()) do
            local v = plr:FindFirstChild("LChance_Weight") or plr:FindFirstChild("LChance") or plr:FindFirstChild("LWeight")
            table.insert(lines, plr.Name .. ": " .. (v and tostring(v.Value) or "Not found"))
        end
        notify("L Chance Debug", table.concat(lines, "\n"), 10)
    else
        notify("Unknown Command", "Available: esp, clearesp, chatlogs, VoteHelp, debugl", 3)
    end
end})

local InfoTab = Window:CreateTab("Info")
InfoTab:CreateSection("ℹ️ Info")
InfoTab:CreateLabel("Kira Detection\nBased on when someone takes out the Death Note.")
InfoTab:CreateLabel("L Detection\nBased on player L chance values; this is the least reliable detector.")
InfoTab:CreateLabel("ID Picked\nBased on the closest player to the ID.")
InfoTab:CreateLabel("ID ESP\nHighlights IDs on the map. Long Range ID Pickup lets the prompt be activated from farther away when the game permits it.")

-- Reset temporary detection/ESP state on respawn.
LocalPlayer.CharacterAdded:Connect(function()
    DetectionActive = false
    KiraList, TakaList, LList = {}, {}, {}
    clearConnections(Connections)
    StatusLabel:Set("Status: Ready")
    updateDetectionLabels()
    if ESPEnabled then task.wait(1); toggleESP(true) end
    if KiraESPEnabled then task.wait(1); refreshKiraESP() end
end)

if GamePhase then
    GamePhase:GetPropertyChangedSignal("Value"):Connect(function()
        if GamePhase.Value == "Starting" then
            clearDetection()
        elseif GamePhase.Value == "Intermission" then
            DetectionActive = false
            KiraList, TakaList, LList = {}, {}, {}
            StatusLabel:Set("Status: Ready")
            updateDetectionLabels()
        end
    end)
end

notify("Adonix Utilities", "Loaded — only requested features are included.", 4)
