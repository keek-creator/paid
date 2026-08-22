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

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -17)
CloseBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.TextColor3 = Color3.fromRGB(230, 230, 240)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 60, 70)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
	TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(42, 42, 55)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -82, 0.5, -17)
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

-- Preserve the old script's expected window object.
local Window = Rayfield:CreateWindow({Name = "Adonix Utilities"})


-- Variables
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer
local NoclipConnection = nil
local DetectionActive = false
local KiraList = {}
local TakaList = {}
local LList = {}
local Connections = {}
local ESPEnabled = false
local ChatLogsGui = nil
local ESPHighlights = {}
local ESPConnections = {} 
local PlayerESPEnabled = false
local PlayerESPHighlights = {}
local PlayerESPConnections = {}
local KiraESPEnabled = false
local KiraESPHighlights = {}
local KiraESPConnection = nil

local ObjectESPEnabled = {
    DeathNote = false,
    IDs = false,
    YourID = false
}
local ObjectESPHighlights = {}
local ObjectESPConnections = {}

-- Game Variables
local GameFolder = ReplicatedStorage:WaitForChild("Game", 10)
local Gamemode = GameFolder and GameFolder:WaitForChild("Gamemode", 5)
local Timer = GameFolder and GameFolder:WaitForChild("Timer", 5)
local GamePhase = GameFolder and GameFolder:WaitForChild("GamePhase", 5)

-- Helper function to truncate text
local function truncateText(text, maxLength)
    if #text <= maxLength then
        return text
    else
        return string.sub(text, 1, maxLength - 3) .. "..."
    end
end

-- Helper function to format player name compactly
local function formatPlayerName(player)
    local displayName = truncateText(player.DisplayName, 12)
    local name = truncateText(player.Name, 10)
    return displayName .. " (" .. name .. ")"
end

local function FetchCurrentId(Map, SpecifiedClient)
    if not Map then return nil end
    for _, v in Map:GetChildren() do
        if v.Name == "Id" then
            if v:FindFirstChild("SurfaceGui") and v.SurfaceGui:FindFirstChild("Frame") and v.SurfaceGui.Frame:FindFirstChild("PlayerName") then
                local playerName = v.SurfaceGui.Frame.PlayerName.Text
                if (playerName == SpecifiedClient.Name or playerName == SpecifiedClient.DisplayName) and v.SurfaceGui.Enabled then
                    return v
                end
            end
            for _, child in pairs(v:GetChildren()) do
                if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
                    for _, subChild in pairs(child:GetDescendants()) do
                        if subChild:IsA("TextLabel") and subChild.Text then
                            local text = subChild.Text
                            if (text == SpecifiedClient.Name or text == SpecifiedClient.DisplayName) then
                                return v
                            end
                        end
                    end
                end
            end
            if v:FindFirstChild("IdPrompt") then
                local closestPlayer = nil
                local closestDistance = math.huge
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (player.Character.HumanoidRootPart.Position - v.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
                
                if closestPlayer == SpecifiedClient and closestDistance < 10 then -- Within 10 studs
                    return v
                end
            end
        end
    end
    return nil
end

local function closestPlayerAtPos(Position)
    local MaxRange = math.huge;
    local Closest = nil;
    for _, v in Players:GetPlayers() do
        local RootPart = v.Character and v.Character:FindFirstChild("HumanoidRootPart");
        if not RootPart then 
            -- Skip this player
        else
            local Magnitude = (RootPart.Position - Position).Magnitude;
            if Magnitude < MaxRange then
                Closest = v.Character;
                MaxRange = Magnitude;
            end
        end
    end
    return Closest;
end

local function FodderClipManagement(Bool, DelayTime)
    if not LocalPlayer.Character then return end
    for i, v in pairs(LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not Bool
        end
    end
    if DelayTime then
        task.delay(DelayTime, function()
            FodderClipManagement(not Bool)
        end)
    end
end

local function CheckForDnOnEachCurrentPlayer()
    for _, plr in pairs(Players:GetPlayers()) do
        if (plr.Character) then
            local co1 = plr.Character.ChildAdded:Connect(function(child)
                if child.Name == "DeathNoteBook" then
                    if not table.find(KiraList, plr) then
                        table.insert(KiraList, plr)
                    end
                end
            end)
            table.insert(Connections, co1)
        end
    end
end

local function CheckForIdsTaken(CMap)
    if not CMap then return end
    for _, v in CMap:GetChildren() do
        if v.Name == "Id" then
            local Position = v.Position;
            local SurfaceGui = v:FindFirstChild("SurfaceGui");
            if not SurfaceGui then 
                -- Skip this ID
            else
                local co2 = SurfaceGui:GetPropertyChangedSignal("Enabled"):Connect(function()
                    local Kira = closestPlayerAtPos(Position);
                    if Kira and Timer and Timer.Value < 178.5 and GamePhase and GamePhase.Value == "IdScatter" then
                        local KiraPlr = Players:GetPlayerFromCharacter(Kira)
                        if KiraPlr and not table.find(TakaList, KiraPlr) then
                            table.insert(TakaList, KiraPlr)
                        end
                    end
                end)
                table.insert(Connections, co2)
            end
        end
    end
end

local function GetMisaNames()
    local MNameAndUsernameList = {}
    
    -- Method 1: Standard FolderForNames detection
    if GameFolder and GameFolder:FindFirstChild("FolderForNames") then
        for _, name in pairs(GameFolder.FolderForNames:GetChildren()) do
            if name.Value ~= nil then
                MNameAndUsernameList[tostring(name.Value)] = name.Name
            end
        end
    end
    
    -- Method 2: Alternative folder detection
    if #MNameAndUsernameList == 0 and GameFolder then
        for _, folder in pairs(GameFolder:GetChildren()) do
            if folder:IsA("Folder") and (folder.Name:find("Name") or folder.Name:find("Misa") or folder.Name:find("Code")) then
                for _, name in pairs(folder:GetChildren()) do
                    if name.Value ~= nil then
                        MNameAndUsernameList[tostring(name.Value)] = name.Name
                    end
                end
            end
        end
    end
    
    -- Method 3: Check ReplicatedStorage directly
    if #MNameAndUsernameList == 0 then
        for _, folder in pairs(ReplicatedStorage:GetChildren()) do
            if folder:IsA("Folder") and (folder.Name:find("Name") or folder.Name:find("Misa") or folder.Name:find("Code")) then
                for _, name in pairs(folder:GetChildren()) do
                    if name.Value ~= nil then
                        MNameAndUsernameList[tostring(name.Value)] = name.Name
                    end
                end
            end
        end
    end
    
    return MNameAndUsernameList
end

local function MatchNameToPlayer(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name == name or plr.DisplayName == name then
            return plr
        end
    end
end

local function GetPersonWithMostVotesAlgorithm()
    if not GameFolder or not GameFolder:FindFirstChild("VoteoutFolder") then return nil, 0 end
    local maxvalue, mostvoteplr = 0, nil
    for _, plrvotes in pairs(GameFolder.VoteoutFolder:GetChildren()) do
        if plrvotes.Value > maxvalue then
            maxvalue = plrvotes.Value
            mostvoteplr = plrvotes.Name
        end
    end
    return MatchNameToPlayer(mostvoteplr), maxvalue
end


local function TryAndFetchL()
    local HighestLChance, Goodlist = 0, {}
    LList = {} -- Reset L list each time
    
    local playerLChances = {}
    
    for _, plr in pairs(Players:GetPlayers()) do
        -- Skip players already identified as Kira or ID pickers
        if table.find(KiraList, plr) or table.find(TakaList, plr) then
        else
            -- Try multiple possible property names for L chance
            local Lchance = nil
            
            -- Try different possible property names
            if plr:FindFirstChild("LChance_Weight") then
                Lchance = plr.LChance_Weight
            else
                for _, child in pairs(plr:GetChildren()) do
                    if child:IsA("Folder") or child:IsA("Model") then
                        if child:FindFirstChild("LChance_Weight") then
                            Lchance = child.LChance_Weight
                            break
                        elseif child:FindFirstChild("LChance") then
                            Lchance = child.LChance
                            break
                        end
                    end
                end
            end
            
            -- If we found an L chance value, store it
            if Lchance and Lchance.Value then
                table.insert(playerLChances, {
                    Player = plr,
                    Value = Lchance.Value
                })
            end
        end
    end
    
    -- Sort players by L chance value (highest first)
    table.sort(playerLChances, function(a, b)
        return a.Value > b.Value
    end)
    
    -- Get the highest L chance value
    if #playerLChances > 0 then
        HighestLChance = playerLChances[1].Value
        
        -- Add all players with the highest L chance value to the list
        for _, data in pairs(playerLChances) do
            if data.Value == HighestLChance then
                table.insert(Goodlist, data.Player)
            else
                break 
            end
        end
    end
    
    -- Update the global L list
    LList = Goodlist
    return Goodlist
end

local function KeepSearchingForL()
    while DetectionActive do
        task.wait(2)
        if DetectionActive then
            local glist = TryAndFetchL()
            -- Update L label with compact formatting
            if #glist > 0 then
                local text = ""
                for i, item in pairs(glist) do
                    if i == 1 then
                        text = formatPlayerName(item)
                    else
                        text = text .. " | " .. formatPlayerName(item)
                    end
                end
                LLabel:Set("L (" .. #glist .. "): " .. text)
            else
                LLabel:Set("L (0): None")
            end
        end
    end
end

local function AutoSearch(StashList)
    if workspace.Map ~= nil and GamePhase and GamePhase.Value == "Search" then
        for _, crate in pairs(StashList) do
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = crate.CFrame * CFrame.new(Vector3.new(0,1,0))
                keypress(0x45)
                task.wait(0.2)
                keyrelease(0x45)
                if GamePhase.Value ~= "Search" then
                    break
                end
            end
        end
    end
end

local function FillStashList()
    local StashList = {}
    if workspace.Map then
        for _, v in workspace.Map:GetChildren() do
            if v.Name == "Crate" then
                table.insert(StashList, v)
            end
        end
    end
    return StashList
end

-- NEW ESP Functions using Highlights
local function highlightCharacter(character)
    for _, child in pairs(character:GetChildren()) do
        if child:IsA("Highlight") then
            child:Destroy()
        end
    end
    
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    if humanoidRootPart then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.Parent = character
        table.insert(ESPHighlights, highlight)
    end
end

local function onCharacterAdded(character)
    if ESPEnabled then
        highlightCharacter(character)
    end
end

local function onPlayerAdded(newPlayer)
    if newPlayer ~= LocalPlayer then
        local charAddedConn = newPlayer.CharacterAdded:Connect(function(character)
            onCharacterAdded(character)
        end)
        table.insert(ESPConnections, charAddedConn)

        if newPlayer.Character then
            onCharacterAdded(newPlayer.Character)
        end
    end
end

local function clearESP()
    ESPEnabled = false
    
    for _, conn in pairs(ESPConnections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    ESPConnections = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, child in pairs(player.Character:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
        end
    end
    
    ESPHighlights = {}
end

local function toggleESP(enabled)
    if enabled then
        clearESP()
        ESPEnabled = true
        for _, player in pairs(Players:GetPlayers()) do
            onPlayerAdded(player)
        end
        
        local playerAddedConn = Players.PlayerAdded:Connect(onPlayerAdded)
        table.insert(ESPConnections, playerAddedConn)
    else
        clearESP()
    end
end

local function clearObjectESP()
    for _, conn in pairs(ObjectESPConnections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end
    ObjectESPConnections = {}

    for _, highlight in pairs(ObjectESPHighlights) do
        if highlight and highlight.Destroy then
            highlight:Destroy()
        end
    end
    ObjectESPHighlights = {}
end

local function highlightSingleId(id)
    if not (ObjectESPEnabled.IDs or ObjectESPEnabled.YourID) then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = id
    table.insert(ObjectESPHighlights, highlight)

    local map = workspace:FindFirstChild("Map")
    local isMyID = ObjectESPEnabled.YourID and map and FetchCurrentId(map, LocalPlayer) == id
    local isClaimed = false

    if not isMyID and map then
        for _, player in pairs(Players:GetPlayers()) do
            if FetchCurrentId(map, player) == id then
                isClaimed = true
                break
            end
        end
    end

    if isMyID then
        highlight.FillColor = Color3.new(0, 1, 0.2) -- Green
        highlight.OutlineColor = Color3.new(0, 0.5, 0.1)
    elseif ObjectESPEnabled.IDs then
        if isClaimed then
            highlight.FillColor = Color3.new(0.5, 0.5, 0.5) -- Grey
            highlight.OutlineColor = Color3.new(0.2, 0.2, 0.2)
        else
            highlight.FillColor = Color3.new(1, 1, 0) -- Yellow
            highlight.OutlineColor = Color3.new(0.5, 0.5, 0)
        end
    else
        highlight:Destroy()
    end
end

local function setupObjectESP()
    clearObjectESP()

    if ObjectESPEnabled.DeathNote then
        local conn = workspace.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "DeathNoteBook" then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.new(0.5, 0, 0.7)
                highlight.OutlineColor = Color3.new(0.2, 0, 0.3)
                highlight.Parent = descendant
                table.insert(ObjectESPHighlights, highlight)
            end
        end)
        table.insert(ObjectESPConnections, conn)
    end

    if ObjectESPEnabled.IDs or ObjectESPEnabled.YourID then
        -- FIX: Add a connection to detect new IDs dynamically
        local idAddedConn = workspace.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "Id" and descendant:IsDescendantOf(workspace:FindFirstChild("Map") or workspace) then
                highlightSingleId(descendant)
            end
        end)
        table.insert(ObjectESPConnections, idAddedConn)

        -- FIX: Scan for existing IDs
        local map = workspace:FindFirstChild("Map")
        if map then
            for _, id in pairs(map:GetChildren()) do
                if id.Name == "Id" then
                    highlightSingleId(id)
                end
            end
        end
    end
end

local function toggleKiraESP()
    if KiraESPEnabled then
        -- Disable Kira ESP
        KiraESPEnabled = false
        
        -- Clear existing highlights
        for _, highlight in pairs(KiraESPHighlights) do
            if highlight and highlight.Destroy then
                highlight:Destroy()
            end
        end
        KiraESPHighlights = {}
        
        -- Disconnect connection
        if KiraESPConnection then
            KiraESPConnection:Disconnect()
            KiraESPConnection = nil
        end
    else
        -- Enable Kira ESP
        KiraESPEnabled = true
        
        -- Function to highlight Kira players
        local function highlightKiraPlayers()
            -- Clear existing highlights
            for _, highlight in pairs(KiraESPHighlights) do
                if highlight and highlight.Destroy then
                    highlight:Destroy()
                end
            end
            KiraESPHighlights = {}
            
            -- Add highlights to Kira players
            for _, player in pairs(KiraList) do
                if player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.new(1, 0, 0) -- Red for Kira
                    highlight.OutlineColor = Color3.new(0.5, 0, 0)
                    highlight.Parent = player.Character
                    table.insert(KiraESPHighlights, highlight)
                end
            end
        end
        
        -- Initial highlight
        highlightKiraPlayers()
        
        -- Set up connection to update when Kira list changes
        KiraESPConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if KiraESPEnabled then
                highlightKiraPlayers()
            end
        end)
    end
end


-- Create Main Tab
local MainTab = Window:CreateTab("Main")

-- Detection Section
local DetectionSection = MainTab:CreateSection("Detection")
local StatusLabel = MainTab:CreateLabel("Status: Ready", false)
local KiraLabel = MainTab:CreateLabel("Kira (0): None", false)
local IDLabel = MainTab:CreateLabel("ID (0): None", false)
local LLabel = MainTab:CreateLabel("L (0): None", false)

-- Detection Controls
MainTab:CreateButton({
    Name = "Start Detection",
    Callback = function()
        if workspace:FindFirstChild("Map") then
            DetectionActive = true
            StatusLabel:Set("Status: Active")
            KiraLabel:Set("Kira (0): Scanning...")
            IDLabel:Set("ID (0): Scanning...")
            LLabel:Set("L (0): Scanning...")
            
            Rayfield:Notify({
                Title = "Detection Started",
                Content = "Kira detection has been activated",
                Duration = 3
            })
            
            -- Start actual detection
            CheckForIdsTaken(workspace.Map)
            CheckForDnOnEachCurrentPlayer()
            task.spawn(KeepSearchingForL)
            
            task.spawn(function()
                while DetectionActive do
                    task.wait(1)
                    if DetectionActive then
                        -- Update Kira list with compact formatting
                        if #KiraList > 0 then
                            local text = ""
                            for i, item in pairs(KiraList) do
                                if i == 1 then
                                    text = formatPlayerName(item)
                                else
                                    text = text .. " | " .. formatPlayerName(item)
                                end
                            end
                            KiraLabel:Set("Kira (" .. #KiraList .. "): " .. text)
                        else
                            KiraLabel:Set("Kira (0): None")
                        end
                        
                        -- Update ID list with compact formatting
                        if #TakaList > 0 then
                            local text = ""
                            for i, item in pairs(TakaList) do
                                if i == 1 then
                                    text = formatPlayerName(item)
                                else
                                    text = text .. " | " .. formatPlayerName(item)
                                end
                            end
                            IDLabel:Set("ID (" .. #TakaList .. "): " .. text)
                        else
                            IDLabel:Set("ID (0): None")
                        end
                    end
                end
            end)
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Map not found - wait for game to start",
                Duration = 3
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Clear All",
    Callback = function()
        DetectionActive = false
        KiraList = {}
        TakaList = {}
        LList = {}
        for _, con in pairs(Connections) do
            if con and con.Disconnect then
                con:Disconnect()
            end
        end
        Connections = {}
        
        StatusLabel:Set("Status: Ready")
        KiraLabel:Set("Kira (0): None")
        IDLabel:Set("ID (0): None")
        LLabel:Set("L (0): None")
        
        Rayfield:Notify({
            Title = "Cleared",
            Content = "All detection data has been cleared",
            Duration = 2
        })
    end
})

-- Statistics Section
local StatsSection = MainTab:CreateSection("Statistics")

local StatsLabel = MainTab:CreateLabel("K:0/4 | ID:0 | L:0", false)

-- Update statistics
task.spawn(function()
    while true do
        task.wait(2)
        StatsLabel:Set("K:" .. #KiraList .. "/4 | ID:" .. #TakaList .. " | L:" .. #LList)
    end
end)

-- Teleportation Section
local TeleportSection = MainTab:CreateSection("Teleportation")

MainTab:CreateButton({
    Name = "TP To Your ID",
    Callback = function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = "You need a character to teleport",
                Duration = 3
            })
            return
        end
        
        local map = workspace:FindFirstChild("Map")
        if not map then
            Rayfield:Notify({
                Title = "Error",
                Content = "Map not found - wait for game to start",
                Duration = 3
            })
            return
        end
        
        local CurrentUserId = FetchCurrentId(map, LocalPlayer)
        if CurrentUserId then
            FodderClipManagement(true, 2)
            LocalPlayer.Character.HumanoidRootPart.CFrame = CurrentUserId.CFrame * CFrame.new(0, 3, 0)
            
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to your ID",
                Duration = 2
            })
        else
            for _, id in pairs(map:GetChildren()) do
                if id.Name == "Id" then
                    local isClaimed = false
                    
                    for _, player in pairs(Players:GetPlayers()) do
                        if FetchCurrentId(map, player) == id then
                            isClaimed = true
                            break
                        end
                    end
                    
                    if not isClaimed then
                        FodderClipManagement(true, 2)
                        LocalPlayer.Character.HumanoidRootPart.CFrame = id.CFrame * CFrame.new(0, 3, 0)
                        Rayfield:Notify({
                            Title = "Teleported",
                            Content = "Teleported to an unclaimed ID",
                            Duration = 2
                        })
                        return
                    end
                end
            end
            
            Rayfield:Notify({
                Title = "Error",
                Content = "No available IDs found",
                Duration = 3
            })
        end
    end
})

MainTab:CreateInput({
    Name = "TP To Player",
    PlaceholderText = "Player name",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = "You need a character to teleport",
                Duration = 3
            })
            return
        end
        
        local MatchedPlayer = MatchNameToPlayer(Text)
        if MatchedPlayer then
            local map = workspace:FindFirstChild("Map")
            if map then
                local TheirId = FetchCurrentId(map, MatchedPlayer)
                if TheirId then
                    FodderClipManagement(true, 1)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = TheirId.CFrame * CFrame.new(0, 3, 0)
                    
                    Rayfield:Notify({
                        Title = "Teleported",
                        Content = "Teleported to " .. MatchedPlayer.DisplayName .. "'s ID",
                        Duration = 2
                    })
                    return
                end
            end
            
            if MatchedPlayer.Character and MatchedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                FodderClipManagement(true, 1)
                LocalPlayer.Character.HumanoidRootPart.CFrame = MatchedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Teleported to " .. MatchedPlayer.DisplayName,
                    Duration = 2
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = MatchedPlayer.DisplayName .. " has no character",
                    Duration = 3
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found: " .. Text,
                Duration = 3
            })
        end
    end
})

-- Utilities Section
local UtilitySection = MainTab:CreateSection("Utilities")

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            NoclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            Rayfield:Notify({
                Title = "Noclip Enabled",
                Content = "You can now walk through walls",
                Duration = 2
            })
        else
            if NoclipConnection then
                NoclipConnection:Disconnect()
                NoclipConnection = nil
            end
            Rayfield:Notify({
                Title = "Noclip Disabled",
                Content = "Collision restored",
                Duration = 2
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Auto Search DN",
    Callback = function()
        if GamePhase and GamePhase.Value == "Search" then
            AutoSearch(FillStashList())
            Rayfield:Notify({
                Title = "Auto Search",
                Content = "Searching for Death Note...",
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Not in searching phase",
                Duration = 3
            })
        end
    end
})

MainTab:CreateButton({
    Name = "Get Misa Codes",
    Callback = function()
        if Gamemode and Gamemode.Value == "MisaGame" then
            local names = GetMisaNames()
            if names and next(names) then
                local codesText = "Misa Codes Found:\n\n"
                for playerName, code in pairs(names) do
                    codesText = codesText .. playerName .. ": " .. code .. "\n"
                end
                Rayfield:Notify({
                    Title = "Misa Codes",
                    Content = codesText,
                    Duration = 30
                })
            else
                Rayfield:Notify({
                    Title = "Misa Codes",
                    Content = "Waiting for codes to be revealed...",
                    Duration = 5
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Not in Misa game mode.",
                Duration = 3
            })
        end
    end
})


local ObjectESPSection = MainTab:CreateSection("Object ESP")

MainTab:CreateToggle({
    Name = "DeathNote ESP",
    CurrentValue = false,
    Callback = function(Value)
        ObjectESPEnabled.DeathNote = Value
        setupObjectESP()
    end
})

MainTab:CreateToggle({
    Name = "IDs ESP [SOON]",
    CurrentValue = false,
    Callback = function(Value)
        ObjectESPEnabled.IDs = Value
        setupObjectESP()
    end
})

MainTab:CreateToggle({
    Name = "Your ID ESP [SOON]",
    CurrentValue = false,
    Callback = function(Value)
        ObjectESPEnabled.YourID = Value
        setupObjectESP()
    end
})

MainTab:CreateToggle({
    Name = "Kira ESP",
    CurrentValue = false,
    Callback = function(Value)
        toggleKiraESP()
    end
})


-- Create Settings Tab
local SettingsTab = Window:CreateTab("Settings")

local UISettings = SettingsTab:CreateSection("UI Settings")
SettingsTab:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "K",
    HoldToInteract = false,
    KeybindCallback = function(Keybind)
        if Window and Window.ToggleUI then
            Window:ToggleUI()
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Notifications",
    CurrentValue = true,
    Callback = function(Value)
        Rayfield:Notify({
        Title = "Notifications",
        Content = Value and "Enabled" or "Disabled",
        Duration = 2
        })
    end
})

local GameSettings = SettingsTab:CreateSection("Game Settings")

SettingsTab:CreateButton({
    Name = "Fiddle IDs",
    Callback = function()
        local map = workspace:FindFirstChild("Map")
        if map then
            for _, id in pairs(map:GetChildren()) do
                if id.Name == "Id" and id:FindFirstChild("IdPrompt") then
                    id.IdPrompt.HoldDuration = 0
                    id.IdPrompt.MaxActivationDistance = 100000
                    id.IdPrompt.RequiresLineOfSight = false
                end
            end
            Rayfield:Notify({
                Title = "ID Prompts Modified",
                Content = "Instant pickup & increased range",
                Duration = 2
            })
        end
    end
})

SettingsTab:CreateButton({
    Name = "Fiddle Crates",
    Callback = function()
        local map = workspace:FindFirstChild("Map")
        if map then
            for _, crate in pairs(map:GetChildren()) do
                if crate.Name == "Crate" and crate:FindFirstChild("BinPrompt") then
                    crate.BinPrompt.HoldDuration = 0
                    crate.BinPrompt.HoldDuration = 0
                    crate.BinPrompt.MaxActivationDistance = 100000
                    crate.BinPrompt.RequiresLineOfSight = false
                end
            end
            Rayfield:Notify({
                Title = "Crate Prompts Modified",
                Content = "Instant opening & increased range",
                Duration = 2
            })
        end
    end
})

SettingsTab:CreateButton({
    Name = "Fill DN Locally",
    Callback = function()
        if GameFolder and GameFolder:FindFirstChild("FolderForIds") then
            for _, player in pairs(Players:GetPlayers()) do
                local idValue = Instance.new("ObjectValue")
                idValue.Name = player.Name
                idValue.Value = player
                idValue.Parent = GameFolder.FolderForIds
            end
            Rayfield:Notify({
                Title = "Death Note Filled",
                Content = "All players added to DN",
                Duration = 2
            })
        end
    end
})

-- Command List Section
local CommandSection = SettingsTab:CreateSection("Command List")
SettingsTab:CreateLabel("esp - Enable player ESP", false)
SettingsTab:CreateLabel("clearesp - Disable player ESP", false)
SettingsTab:CreateLabel("chatlogs - View chat logs", false)
SettingsTab:CreateLabel("VoteHelp - Show most voted player", false)
SettingsTab:CreateLabel("debugl - Debug L chance values", false)

-- Command Input
SettingsTab:CreateInput({
    Name = "Execute Command",
    PlaceholderText = "Enter command",
    RemoveTextAfterFocusLost = true,
    Callback = function(Text)
        local command = Text:lower()
        
        if command == "esp" then
            toggleESP(true)
            Rayfield:Notify({
                Title = "ESP Enabled",
                Content = "Player ESP with highlights enabled",
                Duration = 3
            })
            
        elseif command == "clearesp" then
            clearESP()
            Rayfield:Notify({
                Title = "ESP Disabled",
                Content = "All player highlights have been removed.",
                Duration = 2
            })
            
        elseif command == "chatlogs" then
            loadstring(game:HttpGet("https://pastebin.com/raw/vJnyj69R"))()
            Rayfield:Notify({
                Title = "Chatlogs Opened",
                Content = "Chat logs viewer has been opened",
                Duration = 3
            })
            
        elseif command == "VoteHelp" then
            local PlrMostVotes, Votes = GetPersonWithMostVotesAlgorithm()
            if PlrMostVotes ~= nil then
                Rayfield:Notify({
                    Title = "Most Voted Player",
                    Content = PlrMostVotes.DisplayName .. " with " .. Votes .. " votes",
                    Duration = 5
                })
            else
                Rayfield:Notify({
                    Title = "No Vote",
                    Content = "Not in voting round",
                    Duration = 3
                })
            end
            
        elseif command == "debugl" then
            -- Debug command to check L chance values
            local debugText = "L Chance Values:\n"
            for _, plr in pairs(Players:GetPlayers()) do
                local found = false
                local value = "Not found"
                
                -- Try different possible property names
                if plr:FindFirstChild("LChance_Weight") then
                    found = true
                    value = tostring(plr.LChance_Weight.Value)
                elseif plr:FindFirstChild("LChance") then
                    found = true
                    value = tostring(plr.LChance.Value)
                elseif plr:FindFirstChild("LWeight") then
                    found = true
                    value = tostring(plr.LWeight.Value)
                end
                
                debugText = debugText .. plr.Name .. ": " .. value .. "\n"
            end
            
            Rayfield:Notify({
                Title = "L Chance Debug",
                Content = debugText,
                Duration = 10
            })
            
        else
            Rayfield:Notify({
                Title = "Unknown Command",
                Content = "See command list for available commands",
                Duration = 3
            })
        end
    end
})

-- Create Info Tab
local InfoTab = Window:CreateTab("Info")

-- Box 1: Kira Detection
local KiraInfoSection = InfoTab:CreateSection("Kira Detection")
local KiraInfoLabel = InfoTab:CreateLabel(
    "Based on when someone took out the Death Note.\n100% Accurate.",
    false
)

-- Box 2: L Detection
local LInfoSection = InfoTab:CreateSection("L Detection")
local LInfoLabel = InfoTab:CreateLabel(
    "Based on player chances becoming L.\nLeast Accurate.",
    false
)

-- Box 3: ID Picked
local IDInfoSection = InfoTab:CreateSection("ID Picked")
local IDInfoLabel = InfoTab:CreateLabel(
    "Based on the closest player to the ID.\n100% Accurate.",
    false
)

-- Credits Section
local CreditsSection = InfoTab:CreateSection("Credits")
local CreditsLabel = InfoTab:CreateLabel(
    "Adonix Utilities v2.0.1\nCreated by ryuk",
    false
)

-- Event handlers
if GamePhase then
    GamePhase:GetPropertyChangedSignal("Value"):Connect(function()
        if GamePhase.Value == "Starting" then
            DetectionActive = false
            KiraList = {}
            TakaList = {}
            LList = {}
            for _, con in pairs(Connections) do
                if con and con.Disconnect then
                    con:Disconnect()
                end
            end
            Connections = {}
        elseif GamePhase.Value == "Intermission" then
            StatusLabel:Set("Status: Ready")
            KiraLabel:Set("Kira (0): None")
            IDLabel:Set("ID (0): None")
            LLabel:Set("L (0): None")
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    DetectionActive = false
    KiraList = {}
    TakaList = {}
    LList = {}
    for _, con in pairs(Connections) do
        if con and con.Disconnect then
            con:Disconnect()
        end
    end
    Connections = {}
    
    -- Re-enable ESP if it was enabled before character death
    if ESPEnabled then
        task.wait(1)
        toggleESP(true)
    end
end)

-- Set up player join/leave event listeners for ESP
Players.PlayerAdded:Connect(onPlayerAdded)

-- Initial notification
Rayfield:Notify({
    Title = "Adonix Utilities",
    Content = "Press k to Toggle MENU.",
    Duration = 10
})

print("[Adonix Utilities] V2\n by ryuk\n updated on november 1 ")