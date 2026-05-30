-- 直接复制到注入器执行即可（支持手机触摸拖动）
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- 等待角色加载
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- 创建 UI
local GUI = Instance.new("ScreenGui")
GUI.Name = "TeleportUI"
GUI.ResetOnSpawn = false
GUI.Parent = Player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 180, 0, 150)
MainFrame.Position = UDim2.new(0, 20, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
MainFrame.Parent = GUI

-- ======== 拖动功能（支持触摸和鼠标） ========
local DragBar = Instance.new("Frame")
DragBar.Size = UDim2.new(0, 100, 0, 25)   -- 左侧 100px 作为拖动条，避免遮挡右侧传送按钮
DragBar.Position = UDim2.new(0, 0, 0, 0)
DragBar.BackgroundTransparency = 1        -- 透明，不影响标题显示
DragBar.Parent = MainFrame

local dragging = false

DragBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
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
