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

--// Create Tabs & Pages
local tabData = {
	{Name = "Main", Order = 1},
	{Name = "Player", Order = 2},
	{Name = "Visuals", Order = 3},
	{Name = "Settings", Order = 4},
}

local pages = {}
local tabButtons = {}

for _, info in ipairs(tabData) do
	local btn = createTabButton(info.Name, info.Order)
	local page = createPage(info.Name)
	pages[info.Name] = page
	tabButtons[info.Name] = btn

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do
			p.Visible = false
		end
		for _, b in pairs(tabButtons) do
			b.BackgroundColor3 = Color3.fromRGB(34, 34, 46)
			b.TextColor3 = Color3.fromRGB(195, 195, 210)
		end
		page.Visible = true
		btn.BackgroundColor3 = Color3.fromRGB(55, 105, 230)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

-- Default tab
pages["Main"].Visible = true
tabButtons["Main"].BackgroundColor3 = Color3.fromRGB(55, 105, 230)
tabButtons["Main"].TextColor3 = Color3.fromRGB(255, 255, 255)

--// Main Page
createSection(pages.Main, "General")
createButton(pages.Main, "Print Hello", function()
	print("[CustomHub] Hello!")
end)
createButton(pages.Main, "Test Notification", function()
	print("[CustomHub] Notification triggered")
end)
createToggle(pages.Main, "Example Toggle", false, function(value)
	print("[CustomHub] Toggle:", value)
end)
createLabel(pages.Main, "Pure Instance UI • No external libraries")

--// Player Page
createSection(pages.Player, "Character")
createToggle(pages.Player, "Speed Boost", false, function(value)
	print("[CustomHub] Speed Boost:", value)
end)
createToggle(pages.Player, "Infinite Jump", false, function(value)
	print("[CustomHub] Infinite Jump:", value)
end)
createButton(pages.Player, "Reset Character", function()
	if player.Character then
		player.Character:BreakJoints()
	end
end)

--// Visuals Page
createSection(pages.Visuals, "Effects")
createToggle(pages.Visuals, "Fullbright", false, function(value)
	print("[CustomHub] Fullbright:", value)
end)
createToggle(pages.Visuals, "No Fog", false, function(value)
	print("[CustomHub] No Fog:", value)
end)
createLabel(pages.Visuals, "Add your own visual features here")

--// Settings Page
createSection(pages.Settings, "Interface")
createLabel(pages.Settings, "Drag the title bar to move the window")
createButton(pages.Settings, "Destroy UI", function()
	ScreenGui:Destroy()
end)

--// Dragging
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		-- handled below
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

print("[CustomHub] Loaded successfully • No Rayfield")
