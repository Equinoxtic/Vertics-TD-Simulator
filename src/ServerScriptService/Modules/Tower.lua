-- Main Module Variable (DO NOT REMOVE)

local tower = {}


-- Services - Implement some of the game's available services here

local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- Objects - Add in some variables here

local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")
local towerAnimateEvent = ReplicatedStorage:WaitForChild("TowerAnimateEvent")
local remoteFunctions = ReplicatedStorage:WaitForChild("Functions")
local requestTowerFunction = remoteFunctions:WaitForChild("RequestTower")
local maxTowers = 40


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

function tower.Attack(tower, player)
	while true do
		local config = tower.Config
		local target = FindNearestTarget(tower, config.Range.Value)
		if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
			local targetCFrame = CFrame.lookAt(tower.HumanoidRootPart.Position, target.HumanoidRootPart.Position)
			tower.HumanoidRootPart.BodyGyro.CFrame = targetCFrame
			towerAnimateEvent:FireAllClients(tower, "Attack")
			target.Humanoid:TakeDamage(config.Damage.Value)
			if target.Humanoid.Health <= 0 then
				player.Cash.Value += target.Humanoid.MaxHealth
			end
			task.wait(config.Cooldown.Value)
		end
		task.wait(0.1)
	end
end

function tower.Spawn(player, name, pos)
	local allowedToSpawn = tower.CheckSpawn(player, name)
	if allowedToSpawn then
		local towerToSpawn = ReplicatedStorage.Towers[name]:Clone()
		towerToSpawn.HumanoidRootPart.CFrame = pos
		towerToSpawn.Parent = workspace.Towers
		towerToSpawn.HumanoidRootPart:SetNetworkOwner(nil)
		local bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyGyro.D = 0
		bodyGyro.CFrame = towerToSpawn.HumanoidRootPart.CFrame
		bodyGyro.Parent = towerToSpawn.HumanoidRootPart
		player.Cash.Value -= towerToSpawn.Config.Price.Value
		player.PlacedTowers.Value += 1
		coroutine.wrap(tower.Attack)(towerToSpawn)
	else
		warn("Requested Tower does not exist: ", name)
	end
end

function tower.CheckSpawn(player, name)
	local towerExists = ReplicatedStorage.Towers:FindFirstChild(name)
	if towerExists then
		if towerExists.Config.Price.Value <= player.Cash.Value then
			if player.PlacedTowers.Value < maxTowers then
				return true
			else
				warn("Player has reached max tower limit! ")
			end
		else
			warn("Player cannot afford tower!")
		end
	else
		warn("Tower does not exist: " + name)
	end
	return false
end
requestTowerFunction.OnServerInvoke = tower.CheckSpawn


-- Service(s) functions - Code in the functions that the services use

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

-- Return the module (DO NOT REMOVE THIS AS WELL)

return tower
