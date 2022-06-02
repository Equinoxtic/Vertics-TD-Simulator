local twnService = game:GetService("TweenService")
local soundService = game:GetService("SoundService")
local lightingServive = game:GetService("Lighting")
local thisBarrier = script.Parent
local bonkSound = thisBarrier.bonk

local function DoBarrierTween()
	local blur = lightingServive.Blur
	local tweenInfo = TweenInfo.new(
		2, 
		Enum.EasingStyle.Quart, 
		Enum.EasingDirection.InOut, 
		0, 
		false, 
		0
	)
	local goal = {
		Size = 3
	}
	local twn = twnService:Create(
		blur, 
		tweenInfo, 
		goal
	)
	blur.Size = 24
	twn:Play()
end

local function DoDeathBarrierAction(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	if plr then
		local isTeleporting = plr.Character:FindFirstChild("IsTeleporting")
		if not isTeleporting.Value then
			isTeleporting.Value = true
			bonkSound:Play()
			DoBarrierTween()
			plr.Character.HumanoidRootPart.CFrame = script.Parent.SpawnLocation.CFrame + Vector3.new(0,5,0)
			wait(3)
			isTeleporting.Value = false
		end
	end
end

thisBarrier.Touched:Connect(function(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	if plr then
		local isTeleporting = plr.Character:FindFirstChild("IsTeleporting")
		if not isTeleporting then
			return
		end
		if not isTeleporting.Value then
			DoDeathBarrierAction(hit)
		end
	end
end)
