-- Main Module Variable (DO NOT REMOVE)

local tower = {}


-- Services - Implement some of the game's available services here

local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- Objects - Add in some variables here

local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")
local towerAnimateEvent = ReplicatedStorage:WaitForChild("TowerAnimateEvent")


-- Functions - Code in some functions/local functions here

local function FindNearestTarget(tower, range)
	local nearestTarget = nil
	for i, target in ipairs(workspace.Mobs:GetChildren()) do
		local distance = (target.HumanoidRootPart.Position - tower.HumanoidRootPart.Position).Magnitude
		print(target.Name, distance)
		if distance < range then
			print(target.Name, " is the nearest target")
			nearestTarget = target
			range = distance
		end
	end
	return nearestTarget
end


-- Module Functions - Implement some functions for the module

function tower.Attack(tower)
	while true do
		local config = tower.Config
		local target = FindNearestTarget(tower, config.Range.Value)
		if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
			local targetCFrame = CFrame.lookAt(tower.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
			tower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame
			towerAnimateEvent:FireAllClients(tower, "Attack")
			target.Humanoid:TakeDamage(config.Damage.Value)
			task.wait(config.Cooldown.Value)
		end
		task.wait(0.1)
	end
end

function tower.Spawn(player, name, pos)
	local towerExists = ReplicatedStorage.Towers:FindFirstChild(name)
	if towerExists then
		local towerToSpawn = towerExists:Clone()
		towerToSpawn.HumanoidRootPart.CFrame = pos
		towerToSpawn.Parent = workspace.Towers
		towerToSpawn.HumanoidRootPart:SetNetworkOwner(nil)
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.D = 0
		bodyGyro.CFrame = towerToSpawn.HumanoidRootPart.CFrame
		bodyGyro.Parent = towerToSpawn.HumanoidRootPart
		coroutine.wrap(tower.Attack)(towerToSpawn)
	else
		warn("Requested Tower does not exist: ", name)
	end
end


-- Service(s) functions - Code in the functions that the services use

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

-- Return the module (DO NOT REMOVE THIS AS WELL)

return tower
