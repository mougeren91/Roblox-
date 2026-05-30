-- 可拖动坐标记录/传送器 (支持手机与电脑)
-- 将以下代码放入注入器执行（LocalScript）

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 创建主 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CoordinateTeleporterGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- 主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 220)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- 标题栏（可拖动）
local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Text = "坐标传送器 (拖动标题栏)"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 16
titleBar.AutoButtonColor = false
titleBar.Parent = mainFrame

-- 坐标存储变量
local coords = {nil, nil, nil} -- 三个槽位的 Vector3
local selectedSlot = 1 -- 当前选中槽位

-- 创建三个坐标槽
local slotFrames = {}
local slotLabels = {}

for i = 1, 3 do
    local slotFrame = Instance.new("Frame")
    slotFrame.Name = "Slot" .. i
    slotFrame.Size = UDim2.new(1, -20, 0, 35)
    slotFrame.Position = UDim2.new(0, 10, 0, 35 + (i-1)*40)
    slotFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    slotFrame.BorderSizePixel = 2
    slotFrame.BorderColor3 = (i == 1) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
    slotFrame.Parent = mainFrame

    -- 透明的点击按钮
    local clickButton = Instance.new("TextButton")
    clickButton.Name = "ClickButton"
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = slotFrame

    -- 坐标显示标签
    local label = Instance.new("TextLabel")
    label.Name = "CoordLabel"
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "空"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = slotFrame

    -- 点击槽位时选中
    clickButton.Activated:Connect(function()
        selectedSlot = i
        for j = 1, 3 do
            slotFrames[j].BorderColor3 = (j == i) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(100, 100, 100)
        end
    end)

    table.insert(slotFrames, slotFrame)
    table.insert(slotLabels, label)
end

-- 记录按钮
local recordBtn = Instance.new("TextButton")
recordBtn.Name = "RecordBtn"
recordBtn.Size = UDim2.new(0, 80, 0, 40)
recordBtn.Position = UDim2.new(0, 10, 0, 170)
recordBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
recordBtn.BorderSizePixel = 0
recordBtn.Text = "记录坐标"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.Font = Enum.Font.SourceSansBold
recordBtn.TextSize = 14
recordBtn.Parent = mainFrame

-- 传送按钮
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportBtn"
teleportBtn.Size = UDim2.new(0, 80, 0, 40)
teleportBtn.Position = UDim2.new(1, -90, 0, 170)
teleportBtn.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
teleportBtn.BorderSizePixel = 0
teleportBtn.Text = "传送"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.SourceSansBold
teleportBtn.TextSize = 14
teleportBtn.Parent = mainFrame

-- 记录坐标功能
recordBtn.Activated:Connect(function()
    local character = player.Character
    if not character then
        slotLabels[selectedSlot].Text = "角色不存在"
        return
    end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        slotLabels[selectedSlot].Text = "无 HumanoidRootPart"
        return
    end
    local pos = hrp.Position
    coords[selectedSlot] = pos
    slotLabels[selectedSlot].Text = string.format("X: %.1f  Y: %.1f  Z: %.1f", pos.X, pos.Y, pos.Z)
end)

-- 传送功能
teleportBtn.Activated:Connect(function()
    local target = coords[selectedSlot]
    if not target then
        slotLabels[selectedSlot].Text = "该槽无坐标"
        return
    end
    local character = player.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    -- 传送（客户端直接设置 CFrame）
    hrp.CFrame = CFrame.new(target)
end)

-- 拖动窗口实现
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.Us		dragging = true
	end
end)

DragBar.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Delta   -- 手指/鼠标移动的像素增量
		MainFrame.Position = UDim2.new(
			MainFrame.Position.X.Scale,
			MainFrame.Position.X.Offset + delta.X,
			MainFrame.Position.Y.Scale,
			MainFrame.Position.Y.Offset + delta.Y
		)
	end
end)

DragBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)
-- ======== 拖动功能结束 ========

-- 标题
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 0, 20)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "坐标传送器"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 14
Title.Parent = MainFrame

-- 记录按钮
local RecordButton = Instance.new("TextButton")
RecordButton.Size = UDim2.new(0, 70, 0, 25)
RecordButton.Position = UDim2.new(0, 5, 0, 30)
RecordButton.Text = "记录坐标"
RecordButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
RecordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RecordButton.Font = Enum.Font.SourceSansBold
RecordButton.TextSize = 13
RecordButton.BorderSizePixel = 0
Instance.new("UICorner", RecordButton).CornerRadius = UDim.new(0, 5)
RecordButton.Parent = MainFrame

-- 三个坐标框
local CoordinateFrames = {}
for i = 1, 3 do
	local btn = Instance.new("TextButton")
	btn.Name = "CoordFrame"..i
	btn.Size = UDim2.new(0, 65, 0, 22)
	btn.Position = UDim2.new(0, 5, 0, 30 + 28 * i)
	btn.Text = "空"
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(200, 200, 200)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 12
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	btn.Parent = MainFrame
	CoordinateFrames[i] = btn
end

-- 传送按钮
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 70, 0, 40)
TeleportButton.Position = UDim2.new(0, 85, 0.5, -20)
TeleportButton.Text = "传送"
TeleportButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 16
TeleportButton.BorderSizePixel = 0
Instance.new("UICorner", TeleportButton).CornerRadius = UDim.new(0, 8)
TeleportButton.Parent = MainFrame

-- 数据
local Records = {}
local SelectedIndex = nil

-- 更新显示与高亮
local function UpdateDisplay()
	for i = 1, 3 do
		local btn = CoordinateFrames[i]
		local pos = Records[i]
		if pos then
			btn.Text = string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
		else
			btn.Text = "空"
		end
		if i == SelectedIndex then
			btn.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end
end

-- 记录坐标
local function RecordPosition()
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local pos = hrp.Position
	table.insert(Records, pos)
	if #Records > 3 then
		table.remove(Records, 1)
	end
	if SelectedIndex and SelectedIndex > #Records then
		SelectedIndex = nil
	end
	UpdateDisplay()
end

-- 坐标框点击
for i, btn in ipairs(CoordinateFrames) do
	btn.Activated:Connect(function()
		if Records[i] then
			SelectedIndex = i
		else
			SelectedIndex = nil
		end
		UpdateDisplay()
	end)
end

-- 传送
TeleportButton.Activated:Connect(function()
	if not SelectedIndex then return end
	local targetPos = Records[SelectedIndex]
	if not targetPos then return end

	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	hrp.CFrame = CFrame.new(targetPos)
end)

-- 记录按钮
RecordButton.Activated:Connect(function()
	RecordPosition()
end)

-- 重生后重新绑定角色引用
Player.CharacterAdded:Connect(function(newChar)
	Character = newChar
	HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

UpdateDisplay()
