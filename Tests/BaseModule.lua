-- Main Module Variable (DO NOT REMOVE)

local base = {}

-- Services - Implement some of the game's available services here

local serverStorage = game:GetService("ServerStorage")


-- Objects - Add in some variables here

local bindables = serverStorage:WaitForChild("Bindables")
local updateBaseHealthEvent = bindables:WaitForChild("UpdateBaseHealth")
local gameOverEvent = bindables:WaitForChild("GameOver")


-- Module Functions - Implement some functions for the module

function base.Setup(map, health)
	base.Model = map:WaitForChild("Base")
	base.CurrentHealth = health
	base.MaxHealth = health
end

function base.UpdateHealth(damage)
	if damage then
		base.CurrentHealth -= damage
	end
	local gui = base.Model.HealthGui
	local percent = base.CurrentHealth / base.MaxHealth
	gui.CurrentHealth.Size = UDim2.new(percent, 0, 0.5, 0)
	if base.CurrentHealth <= 0 then
		gameOverEvent:Fire()
		gui.Title.Text = "Game Over!"
	else
		gui.Title.Text = base.CurrentHealth .. "/" .. base.MaxHealth
	end
end

-- Service(s) functions - Code in the functions that the services use

updateBaseHealthEvent.Event:Connect(base.UpdateHealth)


-- Return the module (DO NOT REMOVE THIS AS WELL)

return base
