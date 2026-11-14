--[[
============================================================
    GALAXY SCRIPT  •  BETA  v1.1
    ------------------------------------------------
    Tabs:
        • Home          -> Starter / Credits / Changelog
        • Teleport      -> Set Home Point (shows mini tab)
        • Speed Changer -> Coming in 1.2 Beta
    Mini Tab (floating, small):
        • Teleport (unlock + teleport + relock)
        • X close, - minimize
============================================================
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- THEME (dark)
------------------------------------------------------------
local THEME = {
    BG       = Color3.fromRGB(14, 12, 20),
    PANEL    = Color3.fromRGB(24, 21, 36),
    ITEM     = Color3.fromRGB(34, 30, 52),
    ITEM_HOV = Color3.fromRGB(46, 41, 70),
    STROKE   = Color3.fromRGB(62, 52, 100),
    ACCENT   = Color3.fromRGB(160, 90, 255),
    ACCENT_D = Color3.fromRGB(100, 50, 180),
    TEXT     = Color3.fromRGB(238, 236, 250),
    SUBTEXT  = Color3.fromRGB(150, 145, 180),
    GOOD     = Color3.fromRGB(90, 220, 140),
    BAD      = Color3.fromRGB(255, 90, 110),
    ORANGE   = Color3.fromRGB(255, 150, 50),
}

local FONT      = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function create(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do inst[k] = v end
    inst.Parent = parent
    return inst
end

local function addCorner(inst, radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, inst)
end

local function addStroke(inst, color, thickness, transparency)
    return create("UIStroke", {
        Color = color or THEME.STROKE,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, inst)
end

local function tween(inst, props, time, style, dir)
    local t = TweenService:Create(inst, TweenInfo.new(
        time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

------------------------------------------------------------
-- CLEANUP
------------------------------------------------------------
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui.Name == "GalaxyScript" then gui:Destroy() end
end

------------------------------------------------------------
-- ROOT
------------------------------------------------------------
local screenGui = create("ScreenGui", {
    Name = "GalaxyScript",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

------------------------------------------------------------
-- TOGGLE BUTTON
------------------------------------------------------------
local toggle = create("TextButton", {
    Name = "Toggle",
    Size = UDim2.fromOffset(46, 46),
    Position = UDim2.new(0, 16, 0.5, -23),
    BackgroundColor3 = THEME.PANEL,
    AutoButtonColor = false,
    Text = "G",
    Font = FONT_BOLD,
    TextSize = 20,
    TextColor3 = THEME.ACCENT,
}, screenGui)
addCorner(toggle, 23)
addStroke(toggle, THEME.ACCENT, 1.5)

------------------------------------------------------------
-- MAIN WINDOW
------------------------------------------------------------
local mainFullSize = UDim2.fromOffset(460, 420)
local mainMinSize  = UDim2.new(0, 460, 0, 42)

local main = create("Frame", {
    Name = "Main",
    Size = mainFullSize,
    Position = UDim2.new(0.5, -230, 0.5, -210),
    BackgroundColor3 = THEME.BG,
    BorderSizePixel = 0,
    Visible = false,
}, screenGui)
addCorner(main, 12)
addStroke(main, THEME.STROKE, 1)

-- TITLE BAR
local titleBar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 42),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
}, main)
addCorner(titleBar, 12)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
}, titleBar)

create("TextLabel", {
    Size = UDim2.new(0, 110, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 16,
    TextColor3 = THEME.TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "Galaxy Script",
}, titleBar)

-- BETA badge (purple)
local betaBadge = create("Frame", {
    Size = UDim2.fromOffset(44, 17),
    Position = UDim2.new(0, 128, 0.5, -8.5),
    BackgroundColor3 = THEME.ACCENT,
}, titleBar)
addCorner(betaBadge, 5)
create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 10,
    TextColor3 = Color3.new(1, 1, 1),
    Text = "BETA",
}, betaBadge)

-- V1.1 badge (orange)
local vBadge = create("Frame", {
    Size = UDim2.fromOffset(36, 17),
    Position = UDim2.new(0, 178, 0.5, -8.5),
    BackgroundColor3 = THEME.ORANGE,
}, titleBar)
addCorner(vBadge, 5)
create("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 10,
    TextColor3 = Color3.new(1, 1, 1),
    Text = "V1.1",
}, vBadge)

-- Minimize "-"
local minBtn = create("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -64, 0.5, -13),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "-",
    Font = FONT_BOLD,
    TextSize = 18,
    TextColor3 = THEME.SUBTEXT,
}, titleBar)
addCorner(minBtn, 7)

-- Close "X"
local closeBtn = create("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -34, 0.5, -13),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "X",
    Font = FONT_BOLD,
    TextSize = 14,
    TextColor3 = THEME.SUBTEXT,
}, titleBar)
addCorner(closeBtn, 7)

------------------------------------------------------------
-- TAB BAR / CONTENT / BOTTOM BAR
------------------------------------------------------------
local tabBar = create("Frame", {
    Size = UDim2.new(1, -20, 0, 32),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1,
}, main)
create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
}, tabBar)

local content = create("Frame", {
    Size = UDim2.new(1, -20, 1, -142),
    Position = UDim2.new(0, 10, 0, 88),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, main)

local bottomBar = create("Frame", {
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 1, -44),
    BackgroundTransparency = 1,
}, main)

------------------------------------------------------------
-- TAB SYSTEM (bug-fixed)
------------------------------------------------------------
local tabs = {}
local pageTweens = {}   -- track active fade tweens so we can cancel them

-- FIX: visibility is set for ALL tabs FIRST, then the fade animation is
-- attempted inside pcall. If GroupTransparency is unsupported, the animation
-- silently no-ops instead of throwing and interrupting the loop mid-way
-- (which was the cause of the "Speed Changer text stuck on Teleport tab" bug).
local function selectTab(target)
    -- Pass 1: apply button styles + visibility to EVERY tab, guaranteed.
    for _, t in ipairs(tabs) do
        if pageTweens[t] then
            pageTweens[t]:Cancel()
            pageTweens[t] = nil
        end

        local active = (t == target)
        if active then
            t.Button.BackgroundColor3 = THEME.ACCENT
            t.Button.TextColor3 = Color3.new(1, 1, 1)
        else
            t.Button.BackgroundColor3 = THEME.ITEM
            t.Button.TextColor3 = THEME.SUBTEXT
        end
        t.Page.Visible = active
    end

    -- Pass 2: optional fade-in for the active tab, safe under pcall.
    if target then
        local ok = pcall(function()
            target.Page.GroupTransparency = 1
        end)
        if ok then
            pcall(function()
                pageTweens[target] = tween(target.Page, { GroupTransparency = 0 }, 0.2)
            end)
        end
    end
end

local function createTab(name, order)
    local button = create("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(0, 140, 1, 0),
        BackgroundColor3 = THEME.ITEM,
        AutoButtonColor = false,
        Text = name,
        Font = FONT,
        TextSize = 13,
        TextColor3 = THEME.SUBTEXT,
        LayoutOrder = order,
    }, tabBar)
    addCorner(button, 8)
    addStroke(button, THEME.STROKE, 1)

    local page = create("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = THEME.ACCENT,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
    }, content)
    create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 4),
    }, page)

    local tab = { Button = button, Page = page, Name = name }
    table.insert(tabs, tab)
    button.MouseButton1Click:Connect(function() selectTab(tab) end)
    return tab
end

------------------------------------------------------------
-- TAB 1 : HOME (starter / credits)
------------------------------------------------------------
local homeTab = createTab("Home", 1)
local homePage = homeTab.Page

-- Warning box
local warningBox = create("Frame", {
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
    LayoutOrder = 1,
}, homePage)
addCorner(warningBox, 8)
addStroke(warningBox, THEME.BAD, 1.5)
create("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = FONT,
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    TextColor3 = THEME.TEXT,
    Text = "This script was made from Scripter called Mirko-Scripts. Any other are fake or virus.",
}, warningBox)

-- Changelog header
create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = THEME.ACCENT,
    Text = "Changelog",
    LayoutOrder = 2,
}, homePage)

-- Changelog body
create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 110),
    BackgroundTransparency = 1,
    Font = FONT,
    TextSize = 11,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextColor3 = THEME.SUBTEXT,
    Text = "v1.1 (current)\n• Dark theme redesign\n• Smaller floating mini tab\n• Home part locked/unlocked system\n• Animations & tweens\n• Speed Changer placeholder\n• Fixed tab visibility bug\n\nv1.0\n• Initial Galaxy Script release\n• Teleport Test tab",
    LayoutOrder = 3,
}, homePage)

-- Copy GitHub link button
local copyBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "Copy GitHub Link",
    Font = FONT,
    TextSize = 13,
    TextColor3 = THEME.TEXT,
    LayoutOrder = 4,
}, homePage)
addCorner(copyBtn, 8)
addStroke(copyBtn, THEME.STROKE, 1)
copyBtn.MouseEnter:Connect(function() tween(copyBtn, { BackgroundColor3 = THEME.ITEM_HOV }, 0.15) end)
copyBtn.MouseLeave:Connect(function() tween(copyBtn, { BackgroundColor3 = THEME.ITEM }, 0.15) end)

local GITHUB_LINK = "https://github.com/MirkoScripts/Galaxy-Script-Beta"

copyBtn.MouseButton1Click:Connect(function()
    local ok = pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(GITHUB_LINK)
        else
            error("clipboard unavailable")
        end
    end)
    if ok then
        copyBtn.Text = "Copied to clipboard!"
    else
        copyBtn.Text = GITHUB_LINK
        copyBtn.TextSize = 10
    end
    task.delay(3, function()
        copyBtn.Text = "Copy GitHub Link"
        copyBtn.TextSize = 13
    end)
end)

------------------------------------------------------------
-- TAB 2 : TELEPORT (Set Home Point)
------------------------------------------------------------
local teleportTab = createTab("Teleport", 2)
local tpPage = teleportTab.Page

create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Font = FONT,
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextColor3 = THEME.SUBTEXT,
    Text = "Create a locked 'home' teleport point at your position, then use the mini tab to teleport.",
    LayoutOrder = 1,
}, tpPage)

local statusLabel = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
    Font = FONT,
    TextSize = 12,
    TextColor3 = THEME.SUBTEXT,
    Text = "No home set.",
    LayoutOrder = 2,
}, tpPage)
addCorner(statusLabel, 7)
addStroke(statusLabel, THEME.STROKE, 1)

local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or THEME.SUBTEXT
end

local setHomeBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "Set Home Point",
    Font = FONT,
    TextSize = 14,
    TextColor3 = THEME.TEXT,
    LayoutOrder = 3,
}, tpPage)
addCorner(setHomeBtn, 8)
addStroke(setHomeBtn, THEME.STROKE, 1)
setHomeBtn.MouseEnter:Connect(function() tween(setHomeBtn, { BackgroundColor3 = THEME.ITEM_HOV }, 0.15) end)
setHomeBtn.MouseLeave:Connect(function() tween(setHomeBtn, { BackgroundColor3 = THEME.ITEM }, 0.15) end)

local clearHomeBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "Clear Home",
    Font = FONT,
    TextSize = 13,
    TextColor3 = THEME.SUBTEXT,
    LayoutOrder = 4,
    Visible = false,
}, tpPage)
addCorner(clearHomeBtn, 8)
addStroke(clearHomeBtn, THEME.BAD, 1)
clearHomeBtn.MouseEnter:Connect(function() tween(clearHomeBtn, { BackgroundColor3 = THEME.ITEM_HOV }, 0.15) end)
clearHomeBtn.MouseLeave:Connect(function() tween(clearHomeBtn, { BackgroundColor3 = THEME.ITEM }, 0.15) end)

------------------------------------------------------------
-- TAB 3 : SPEED CHANGER (placeholder)
------------------------------------------------------------
local speedTab = createTab("Speed Changer", 3)
create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 200),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 18,
    TextColor3 = THEME.SUBTEXT,
    Text = "Coming in 1.2 Beta",
    TextWrapped = true,
    LayoutOrder = 1,
}, speedTab.Page)

------------------------------------------------------------
-- MINI TAB (small, floating)
------------------------------------------------------------
local miniFullSize = UDim2.fromOffset(170, 78)
local miniMinSize  = UDim2.new(0, 170, 0, 26)
local MINI_HIDDEN_POS = UDim2.new(1, 10, 0.5, -39)
local MINI_SHOWN_POS  = UDim2.new(1, -190, 0.5, -39)

local miniVisible   = false
local miniMinimized = false

local miniTab = create("Frame", {
    Name = "MiniTab",
    Size = miniFullSize,
    Position = MINI_HIDDEN_POS,
    BackgroundColor3 = THEME.BG,
    BorderSizePixel = 0,
    Visible = false,
}, screenGui)
addCorner(miniTab, 8)
addStroke(miniTab, THEME.ACCENT, 1.5)

-- Mini title bar
local miniTitle = create("Frame", {
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
}, miniTab)
addCorner(miniTitle, 8)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 8),
    Position = UDim2.new(0, 0, 1, -8),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
}, miniTitle)

create("TextLabel", {
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Font = FONT_BOLD,
    TextSize = 11,
    TextColor3 = THEME.TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "Galaxy Mini",
}, miniTitle)

local miniMinBtn = create("TextButton", {
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.new(1, -48, 0.5, -10),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "-",
    Font = FONT_BOLD,
    TextSize = 14,
    TextColor3 = THEME.SUBTEXT,
}, miniTitle)
addCorner(miniMinBtn, 5)

local miniCloseBtn = create("TextButton", {
    Size = UDim2.fromOffset(20, 20),
    Position = UDim2.new(1, -24, 0.5, -10),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "X",
    Font = FONT_BOLD,
    TextSize = 11,
    TextColor3 = THEME.SUBTEXT,
}, miniTitle)
addCorner(miniCloseBtn, 5)

-- Mini body
local miniBody = create("Frame", {
    Size = UDim2.new(1, -16, 1, -34),
    Position = UDim2.new(0, 8, 0, 28),
    BackgroundTransparency = 1,
}, miniTab)

local teleportBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = THEME.ACCENT,
    AutoButtonColor = false,
    Text = "Teleport",
    Font = FONT_BOLD,
    TextSize = 13,
    TextColor3 = Color3.new(1, 1, 1),
}, miniBody)
addCorner(teleportBtn, 6)
addStroke(teleportBtn, Color3.new(1, 1, 1), 1, 0.6)
teleportBtn.MouseEnter:Connect(function() tween(teleportBtn, { BackgroundColor3 = THEME.ACCENT_D }, 0.15) end)
teleportBtn.MouseLeave:Connect(function() tween(teleportBtn, { BackgroundColor3 = THEME.ACCENT }, 0.15) end)

makeDraggable(miniTab, miniTitle)

------------------------------------------------------------
-- SHOW/HIDE MINI TAB BUTTON (bottom bar)
------------------------------------------------------------
local showMiniBtn = create("TextButton", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "",
    Visible = false,
}, bottomBar)
addCorner(showMiniBtn, 8)
addStroke(showMiniBtn, THEME.ORANGE, 1.5)

create("TextLabel", {
    Size = UDim2.new(1, -80, 1, 0),
    Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1,
    Font = FONT,
    TextSize = 13,
    TextColor3 = THEME.TEXT,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "Show/Hide Mini Tab",
}, showMiniBtn)

local betaMini = create("Frame", {
    Size = UDim2.fromOffset(42, 18),
    Position = UDim2.new(
