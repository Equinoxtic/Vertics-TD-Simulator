local tower = script.Parent
local mobs = workspace.Mobs

local function GetEnemyPosition()
	for i, target in ipairs(mobs:GetChildren()) do
		local distance = (target.HumanoidRootPart.Position - tower.Position).Magnitude
		print(target.Name, distance)
	end
end

mobs.ChildAdded:Connect(GetEnemyPosition)
