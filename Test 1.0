--[[
============================================================
    GALAXY SCRIPT  •  BETA
    ------------------------------------------------
    Tab 1 : Teleport Test
        • Set Teleport Point  -> drops a locked part at your feet
        • Unlock & Teleport   -> unlocks that part and teleports you to it
        • Clear Point         -> removes the point
============================================================
]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- THEME
------------------------------------------------------------
local THEME = {
    BG      = Color3.fromRGB(18, 16, 27),
    PANEL   = Color3.fromRGB(28, 25, 42),
    ITEM    = Color3.fromRGB(38, 34, 58),
    STROKE  = Color3.fromRGB(74, 62, 122),
    ACCENT  = Color3.fromRGB(150, 90, 255),
    TEXT    = Color3.fromRGB(238, 236, 250),
    SUBTEXT = Color3.fromRGB(150, 145, 180),
    GOOD    = Color3.fromRGB(90, 220, 140),
    BAD     = Color3.fromRGB(255, 90, 110),
}

local FONT      = Enum.Font.GothamMedium
local FONT_BOLD = Enum.Font.GothamBold

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local function create(className, props, parent)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
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
-- CLEANUP OLD INSTANCE
------------------------------------------------------------
for _, gui in ipairs(playerGui:GetChildren()) do
    if gui:IsA("ScreenGui") and gui.Name == "GalaxyScript" then
        gui:Destroy()
    end
end

------------------------------------------------------------
-- ROOT GUI
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
local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(440, 340),
    Position = UDim2.new(0.5, -220, 0.5, -170),
    BackgroundColor3 = THEME.BG,
    BorderSizePixel = 0,
    Visible = false,
}, screenGui)
addCorner(main, 12)
addStroke(main, THEME.STROKE, 1)

------------------------------------------------------------
-- TITLE BAR
------------------------------------------------------------
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

local closeBtn = create("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -34, 0.5, -13),
    BackgroundColor3 = THEME.ITEM,
    AutoButtonColor = false,
    Text = "✕",
    Font = FONT_BOLD,
    TextSize = 14,
    TextColor3 = THEME.SUBTEXT,
}, titleBar)
addCorner(closeBtn, 7)

------------------------------------------------------------
-- TAB BAR
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

------------------------------------------------------------
-- CONTENT AREA
------------------------------------------------------------
local content = create("Frame", {
    Size = UDim2.new(1, -20, 1, -96),
    Position = UDim2.new(0, 10, 0, 88),
    BackgroundTransparency = 1,
}, main)

------------------------------------------------------------
-- TAB SYSTEM
------------------------------------------------------------
local tabs = {}

local function selectTab(target)
    for _, t in ipairs(tabs) do
        local active = (t == target)
        t.Button.BackgroundColor3 = active and THEME.ACCENT or THEME.ITEM
        t.Button.TextColor3      = active and Color3.new(1, 1, 1) or THEME.SUBTEXT
        t.Page.Visible           = active
    end
end

local function createTab(name, order)
    local button = create("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.new(0, 130, 1, 0),
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

    button.MouseButton1Click:Connect(function()
        selectTab(tab)
    end)

    return tab
end

------------------------------------------------------------
-- TAB 1 : TELEPORT TEST
------------------------------------------------------------
local teleportTab = createTab("Teleport Test", 1)
local page        = teleportTab.Page

-- Description
create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 32),
    BackgroundTransparency = 1,
    Font = FONT,
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextColor3 = THEME.SUBTEXT,
    Text = "Create a locked teleport point where you are standing, then unlock it and teleport to it.",
    LayoutOrder = 1,
}, page)

-- Status
local statusLabel = create("TextLabel", {
    Size = UDim2.new(1, 0, 0, 28),
    BackgroundColor3 = THEME.PANEL,
    BorderSizePixel = 0,
    Font = FONT,
    TextSize = 12,
    TextColor3 = THEME.SUBTEXT,
    Text = "No teleport point set.",
    LayoutOrder = 2,
}, page)
addCorner(statusLabel, 7)
addStroke(statusLabel, THEME.STROKE, 1)

local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or THEME.SUBTEXT
end

-- Button factory
local function createButton(text, order)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = THEME.ITEM,
        AutoButtonColor = false,
        Text = text,
        Font = FONT,
        TextSize = 14,
        TextColor3 = THEME.TEXT,
        LayoutOrder = order,
    }, page)
    addCorner(btn, 8)
    addStroke(btn, THEME.STROKE, 1)
    return btn
end

local setBtn       = createButton("📍  Set Teleport Point", 3)
local teleportBtn  = createButton("🔓  Unlock & Teleport to Part", 4)
local clearBtn     = createButton("🗑  Clear Point", 5)

------------------------------------------------------------
-- TELEPORT LOGIC
------------------------------------------------------------
local FOLDER_NAME = "GalaxyTeleportPoints"
local pointsFolder = workspace:FindFirstChild(FOLDER_NAME)
if not pointsFolder then
    pointsFolder = create("Folder", { Name = FOLDER_NAME }, workspace)
end

local currentPoint  = nil
local pointLabel    = nil
local hasPoint      = false
local busy          = false

local function getCharacter()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return nil end
    return char, hrp, hum
end

local function updateTeleportButton()
    if hasPoint then
        teleportBtn.BackgroundColor3 = THEME.ACCENT
        teleportBtn.TextColor3 = Color3.new(1, 1, 1)
    else
        teleportBtn.BackgroundColor3 = THEME.ITEM
        teleportBtn.TextColor3 = THEME.SUBTEXT
    end
end

local function clearPoint()
    if currentPoint then
        currentPoint:Destroy()
    end
    currentPoint = nil
    pointLabel = nil
    hasPoint = false
    updateTeleportButton()
    setStatus("No teleport point set.", THEME.SUBTEXT)
end

local function setPoint()
    local char, hrp = getCharacter()
    if not char then
        setStatus("⚠ Character not found or dead.", THEME.BAD)
        return
    end

    if currentPoint then currentPoint:Destroy() end

    local groundPos = hrp.Position - Vector3.new(0, 2.7, 0)
    local yaw = math.rad(hrp.Orientation.Y)

    local part = create("Part", {
        Name = "GalaxyTeleportPoint",
        Size = Vector3.new(4, 0.4, 4),
        Anchored = true,
        CanCollide = false,
        CanTouch = false,
        CanQuery = false,
        Material = Enum.Material.Neon,
        Color = THEME.ACCENT,
        Transparency = 0.35,
        Locked = true,
        CFrame = CFrame.new(groundPos) * CFrame.Angles(0, yaw, 0),
    }, pointsFolder)

    -- Billboard label
    local billboard = create("BillboardGui", {
        Size = UDim2.fromOffset(170, 30),
        StudsOffset = Vector3.new(0, 2.4, 0),
        AlwaysOnTop = true,
    }, part)

    pointLabel = create("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Font = FONT_BOLD,
        TextSize = 13,
        TextColor3 = THEME.ACCENT,
        TextStrokeTransparency = 0.5,
        Text = "🔒 TELEPORT POINT (LOCKED)",
    }, billboard)

    currentPoint = part
    hasPoint = true
    updateTeleportButton()
    setStatus("Teleport point created and LOCKED.", THEME.GOOD)
end

local function unlockAndTeleport()
    if busy then return end

    if not hasPoint or not currentPoint or not currentPoint.Parent then
        setStatus("⚠ No teleport point. Set one first.", THEME.BAD)
        return
    end

    local char = getCharacter()
    if not char then
        setStatus("⚠ Cannot teleport: no character.", THEME.BAD)
        return
    end

    busy = true

    -- Unlock the part
    currentPoint.Locked = false
    currentPoint.Color = THEME.GOOD
    if pointLabel then
        pointLabel.Text = "🔓 TELEPORT POINT (UNLOCKED)"
        pointLabel.TextColor3 = THEME.GOOD
    end

    -- Teleport
    local target = currentPoint.CFrame + Vector3.new(0, 3.2, 0)
    char:PivotTo(target)

    setStatus("Unlocked and teleported to the part.", THEME.GOOD)

    task.delay(0.6, function()
        busy = false
    end)
end

setBtn.MouseButton1Click:Connect(setPoint)
teleportBtn.MouseButton1Click:Connect(unlockAndTeleport)
clearBtn.MouseButton1Click:Connect(clearPoint)

updateTeleportButton()

------------------------------------------------------------
-- OPEN / CLOSE
------------------------------------------------------------
local function setOpen(open)
    main.Visible = open
    if open then
        main.Size = UDim2.fromOffset(420, 320)
        TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(440, 340),
        }):Play()
    end
end

toggle.MouseButton1Click:Connect(function()
    setOpen(not main.Visible)
end)

closeBtn.MouseButton1Click:Connect(function()
    setOpen(false)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setOpen(not main.Visible)
    end
end)

------------------------------------------------------------
-- DRAGGING
------------------------------------------------------------
makeDraggable(main, titleBar)

------------------------------------------------------------
-- START
------------------------------------------------------------
selectTab(teleportTab)
setOpen(true)

print("[Galaxy Script] Beta loaded — Tab: Teleport Test")
