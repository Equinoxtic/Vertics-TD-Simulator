-- Main Module Variable (DO NOT REMOVE)

local tower = {}


-- Services - Implement some of the game's available services here

local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- Objects - Add in some variables here

local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")


-- Functions - Code in some functions/local functions here

local tower = script.Parent
local mobs = workspace.Mobs

local function FindNearestTarget()
	local maxDistance = 7
	local nearestTarget = nil
	for i, target in ipairs(mobs:GetChildren()) do
		local distance = (target.HumanoidRootPart.Position - tower.HumanoidRootPart.Position).Magnitude
		print(target.Name, distance)
		if distance < maxDistance then
			print(target.Name, " is the nearest target")
			nearestTarget = target
			maxDistance = distance
		end
	end
	return nearestTarget
end


-- Module Functions - Implement some functions for the module

function tower.Attack(tower)
	while true do
		local target = FindNearestTarget()
		if target then
			target.Humanoid:TakeDamage(2)
		end
		task.wait(1)
	end
end

function tower.Spawn(player, name, pos)
	local towerExists = ReplicatedStorage.Towers:FindFirstChild(name)
	if towerExists then
		local towerToSpawn = towerExists:Clone()
		towerToSpawn.HumanoidRootPart.CFrame = pos
		towerToSpawn.Parent = workspace.Towers
		towerToSpawn.HumanoidRootPart:SetNetworkOwner(nil)
	else
		warn("Requested Tower does not exist: ", name)
	end
	coroutine.wrap(tower.Attack)
end


-- Service(s) functions - Code in the functions that the services use

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

-- Return the module (DO NOT REMOVE THIS AS WELL)

return tower
