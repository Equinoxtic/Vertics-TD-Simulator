-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


-- Objects
local cash = Players.LocalPlayer:WaitForChild("Cash")
local remoteFunctions = ReplicatedStorage:WaitForChild("Functions")
local requestTowerFunction = remoteFunctions:WaitForChild("RequestTower")
local towers = ReplicatedStorage:WaitForChild("Towers")
local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")
local modules = ReplicatedStorage:WaitForChild("Modules")
local health = require(modules:WaitForChild("Health"))
local camera = workspace.CurrentCamera
local gui = script.Parent
local map = workspace.Maps:WaitForChild("Baseplate")
local base = map:WaitForChild("Base")
local towerToSpawn = nil
local canPlace = false
local rotation = 0
local placedTowers = 0
local maxTowers = 40

gui.TowerLabel.Text = placedTowers .. "/" .. maxTowers

-- Functions
health.Setup(base)
workspace.Mobs.ChildAdded:Connect(function(mob)
	health.Setup(mob)
end)

local function UpdateCash()
	gui.PriceLabel.Text = cash.Value
end
UpdateCash()
cash.Changed:Connect(UpdateCash)

local function MouseRaycast(blacklist)
	local mousePos = UserInputService:GetMouseLocation()
	local mouseRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.FilterDescendantsInstances = blacklist
	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000, raycastParams)
	return raycastResult
end

local function RemovePlaceholderTower()
	if towerToSpawn then
		towerToSpawn:Destroy()
		towerToSpawn = nil
		rotation = 0
	end
end

local function ColorTowerPlaceholder(color)
	for i, object in ipairs(towerToSpawn:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Color = color
		end
	end
end

local function AddTowerPlaceholder(name)
	local towerExists = towers:FindFirstChild(name)
	if towerExists then
		RemovePlaceholderTower()
		towerToSpawn = towerExists:Clone()
		towerToSpawn.Parent = workspace.Towers
		for i, object in ipairs(towerToSpawn:GetDescendants()) do
			if object:IsA("BasePart") then
				object.Material = Enum.Material.ForceField
			end
		end
	end
end


-- Service(s) Functions
for i, tower in pairs(towers:GetChildren()) do
	local btn = gui.Towers.Template:Clone()
	local cfg = tower:WaitForChild("Config")
	btn.Parent = gui.Towers
	btn.Visible = true
	btn.Text = tower.Name
	btn.Price.Text = "$" .. cfg.Price.Value
	btn.Activated:Connect(function()
		if placedTowers < maxTowers then
			local allowedToSpawn = requestTowerFunction:InvokeServer(tower.Name)
			if allowedToSpawn then
				AddTowerPlaceholder(tower.Name)
			end
		end
	end)
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if towerToSpawn then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if canPlace then
				spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
				placedTowers += 1
				gui.TowerLabel.Text = placedTowers .. "/" .. maxTowers
				RemovePlaceholderTower()
			end
		elseif input.KeyCode == Enum.KeyCode.R then
			rotation += 90
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if towerToSpawn then
		local result = MouseRaycast({towerToSpawn})
		if result and result.Instance then
			if result.Instance.Parent.Name == "TowerAreas" then
				canPlace = true
				ColorTowerPlaceholder(Color3.new(0,1,0))
			else
				canPlace = false
				ColorTowerPlaceholder(Color3.new(1,0,0))
			end
			local x = result.Position.X
			local y = result.Position.Y + towerToSpawn.Humanoid.HipHeight + towerToSpawn.PrimaryPart.Size.Y + 0.5
			local z = result.Position.Z
			local cframe = CFrame.new(x,y,z) * CFrame.Angles(0, math.rad(rotation), 0)
			towerToSpawn:SetPrimaryPartCFrame(cframe)
		end
	end
end)
