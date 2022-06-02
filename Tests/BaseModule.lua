-- Main Module Variable (DO NOT REMOVE)

local base = {}

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
	gui.Title.Text = base.CurrentHealth .. "/" .. base.MaxHealth
end


-- Return the module (DO NOT REMOVE THIS AS WELL)

return base
