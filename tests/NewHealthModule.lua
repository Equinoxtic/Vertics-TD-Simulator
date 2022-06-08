-- Main Module Variable (DO NOT REMOVE)

local health = {}

-- Service(s)

local Players = game:GetService("Players")


-- Module Functions

function health.Setup(model)
	local newHealthBar = script.HealthGui:Clone()
	newHealthBar.Adornee = model:WaitForChild("Head")
	newHealthBar.Parent = Players.LocalPlayer.PlayerGui
	health.UpdateHealth()
	model.Humanoid.HealthChanged:Connect(function()
		health.UpdateHealth(newHealthBar, model)
	end)
end

function health.UpdateHealth(gui, model)
	local humanoid = model:WaitForChild("Humanoid")
	if humanoid and gui then
		local percent = humanoid.Health / humanoid.MaxHealth
		gui.CurrentHealth.Size = UDim2.new(percent, 0, 0.5, 0)
		gui.Title.Text = humanoid.Health .. "/" .. humanoid.MaxHealth
	end
end


-- Return the module (DO NOT REMOVE THIS AS WELL)

return health
