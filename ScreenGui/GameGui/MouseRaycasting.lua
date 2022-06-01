-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Objects
local towers = ReplicatedStorage:WaitForChild("Towers")
local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")
local camera = workspace.CurrentCamera
local gui = script.Parent
local towerToSpawn = nil

-- Functions
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

gui.Spawn.Activated:Connect(function()
	AddTowerPlaceholder("Swordsman")
end)

-- Service(s) Functions
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if towerToSpawn then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			spawnTowerEvent:FireServer(towerToSpawn.Name, towerToSpawn.PrimaryPart.CFrame)
			RemovePlaceholderTower()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if towerToSpawn then
		local result = MouseRaycast({towerToSpawn})
		if result and result.Instance then
			local x = result.Position.X
			local y = result.Position.Y + towerToSpawn.Humanoid.HipHeight + towerToSpawn.PrimaryPart.Size.Y + 0.5
			local z = result.Position.Z
			local cframe = CFrame.new(x,y,z)
			towerToSpawn:SetPrimaryPartCFrame(cframe)
		end
	end
end)
