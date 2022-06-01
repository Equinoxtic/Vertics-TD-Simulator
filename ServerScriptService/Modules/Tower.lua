-- Main Module Variable (DO NOT REMOVE)

local tower = {}


-- Services - Implement some of the game's available services here

local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


-- Objects - Add in some variables here

local spawnTowerEvent = ReplicatedStorage:WaitForChild("TowerSpawnEvent")


-- Module Functions - Implement some functions for the module

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
end

-- Service(s) functions - Code in the functions that the services use

spawnTowerEvent.OnServerEvent:Connect(tower.Spawn)

-- Return the module (DO NOT REMOVE THIS AS WELL)

return tower
