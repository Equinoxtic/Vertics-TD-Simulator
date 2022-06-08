-- Main Module Variable (DO NOT REMOVE)

local health = {}

-- Service(s)

local Players = game:GetService("Players")


-- Module Functions

function health.Setup(model)
	local newHealthBar = script.HealthGui:Clone()
	newHealthBar.Adornee = model:WaitForChild("Head")
	newHealthBar.Parent = Players.LocalPlayer.PlayerGui
	if model.Name == "Base" then
		newHealthBar.MaxDistance = 100
		newHealthBar.Size = UDim2.new(0, 200, 0, 20)
	else
		newHealthBar.MaxDistance = 30
		newHealthBar.Size = UDim2.new(0, 100, 0, 20)
	end
	health.UpdateHealth(newHealthBar, model)
	model.Humanoid.HealthChanged:Connect(function()
		health.UpdateHealth(newHealthBar, model)
	end)
end

function health.UpdateHealth(gui, model)
	local humanoid = model:WaitForChild("Humanoid")
	if humanoid and gui then
		local percent = humanoid.Health / humanoid.MaxHealth
		gui.CurrentHealth.Size = UDim2.new(percent, 0, 1, 0)
		gui.Title.Text = humanoid.Health .. "/" .. humanoid.MaxHealth
	end
end


-- Return the module (DO NOT REMOVE THIS AS WELL)

return health
