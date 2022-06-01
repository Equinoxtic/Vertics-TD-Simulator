local function setAnimation(object, animName)
	local humanoid = object:WaitForChild("Humanoid")
	if humanoid then
		local animObj = object:WaitForChild(animName)
		if animObj then
			local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
			local animTrack = animator:LoadAnimation(animObj)
			return animTrack
		end
	else
		warn("NO ANIMATION")
	end
end

local function playAnimation(object, animName)
	local animTrack = setAnimation(object, animName)
	if animTrack then
		animTrack:Play()
	else
		warn("Animation track does not exist!")
		return
	end
end

workspace.Mobs.ChildAdded:Connect(function(object)
	playAnimation(object, "Walk")
end)

workspace.Towers.ChildAdded:Connect(function(object)
	playAnimation(object, "Idle")
end)
