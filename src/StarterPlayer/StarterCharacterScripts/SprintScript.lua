-- Services
local inputService = game:GetService("UserInputService")
local playerService = game:GetService("Players")

-- Objects
local plr = playerService.LocalPlayer
local char = plr.Character or plr.CharacterAdded:wait()

-- Functions
inputService.InputBegan:Connect(function (key)
	if key.KeyCode == Enum.KeyCode.LeftShift or key.KeyCode == Enum.KeyCode.RightShift then
		running = true
		if char:FindFirstChild("Humanoid") then	
			char.Humanoid.WalkSpeed = 26
		end
	end
end)

inputService.InputEnded:Connect(function (key)
	if key.KeyCode == Enum.KeyCode.LeftShift or key.KeyCode == Enum.KeyCode.RightShift then
		running = false
		if char:FindFirstChild("Humanoid") then	
			char.Humanoid.WalkSpeed = 18
		end
	end
end)
