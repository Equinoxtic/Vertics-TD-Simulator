local PhysicsService = game:GetService("PhysicsService")
local ServerStorage = game:GetService("ServerStorage")
local bindables = ServerStorage:WaitForChild("Bindables")
local updateBaseHealthEvent = bindables:WaitForChild("UpdateBaseHealth")
local mob = {}

function mob.Move(mob, map)
	local enemy = mob
	local waypoints = map.Waypoints
	for i=1, #waypoints:GetDescendants() do
		enemy.Humanoid:MoveTo(waypoints[i].Position)
		enemy.Humanoid.MoveToFinished:Wait()
	end
	enemy:Destroy()
	updateBaseHealthEvent:Fire(enemy.Humanoid.Health)
end

function mob.Spawn(name, map, amount)
	local mobExists = ServerStorage.Mobs:FindFirstChild(name)
	if mobExists then
		for i=1, amount do
			task.wait(1)
			local newMob = mobExists:Clone()
			newMob.HumanoidRootPart.CFrame = map.EnemySpawnPart.CFrame
			newMob.Parent = workspace.Mobs
			newMob.HumanoidRootPart:SetNetworkOwner(nil)
			--[[ 
			No need for this code, since the player can also opt-out from collisions
			(PS: It breaks the script so don't uncomment)
			for i, object in ipairs(newMob:GetDescendants()) do
				if object:IsA("BasePart") then
					PhysicsService:SetPartCollisionGroup(newMob, "Mob")
				end
			end
			]]
			newMob.Humanoid.Died:Connect(function()
				newMob:Destroy()
			end)
			coroutine.wrap(mob.Move)(newMob, map)
		end
	else
		warn("Requested mob does not exist: ", name)
	end
end

return mob
