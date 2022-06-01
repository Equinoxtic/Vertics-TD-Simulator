local scriptService =  game:GetService("ServerScriptService")
local mob = require(scriptService.Modules.Mob)
local tower = require(scriptService.Modules.Tower)
local map = game.Workspace.Maps.Baseplate
local timerRemote = game.ReplicatedStorage:FindFirstChild("TimerRemoteEvent")

local function timerFunction(timer)
	wait(1)
	repeat
		timer -= 1
		print(timer)
		wait(1)
	until timer <= 0
	wait(timer)
end
	
for wave=1, 40 do
	print("WAVE: ", wave, " STARTING...")
	
	timerFunction(10)
	
	print("WAVE: ", wave, " STARTED")
	
	if wave == 1 or wave == 2 then
		mob.Spawn("Zombie", map, 3 * wave)
	elseif wave == 3 or wave == 4 then
		mob.Spawn("Zombie", map, 4 + wave)
	elseif wave == 5 then
		mob.Spawn("Speedy", map, 5)
	elseif wave == 6 then
		mob.Spawn("Speedy", map, 2 + wave)
		mob.Spawn("Zombie", map, 2 + wave)
	elseif wave == 7 then
		mob.Spawn("Slow", map, 5)
	elseif wave == 8 then
		mob.Spawn("Slow", map, 2 + wave)
		mob.Spawn("Zombie", map, 4 + wave)
	elseif wave == 9 then
		mob.Spawn("Slow", map, wave / 3)
		mob.Spawn("Zombie", map, wave / 3 + 3)
		mob.Spawn("Speedy", map, wave / 3 + 5)
	elseif wave == 10 then
		mob.Spawn("Zombie", map, 5)
		mob.Spawn("Slow", map, 3)
		mob.Spawn("Normal Boss", map, 1)
		mob.Spawn("Speedy", map, 2)
	end
	
	repeat
		task.wait(1)
	until #workspace.Mobs:GetChildren() == 0
	
	print("WAVE ", wave, " ENDED")
	task.wait(1)
end
