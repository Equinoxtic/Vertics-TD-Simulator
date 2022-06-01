local function animateMob(object)
	print("Animation loaded")
	local humanoid = object:WaitForChild("Humanoid")
	if humanoid then
		local walkAnimation = object:WaitForChild("Walk")
		if walkAnimation then
			local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
			local walkTrack = animator:LoadAnimation(walkAnimation)
			walkTrack:Play()
		end
	else
		warn("NO ANIMATION")
	end
end

workspace.Mobs.ChildAdded:Connect(animateMob)
