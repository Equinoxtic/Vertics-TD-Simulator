local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local function MouseRaycast()
	local mousePos = UserInputService:GetMouseLocation()
	local mouseRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
	local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * 1000)
	return raycastResult
end

RunService.RenderStepped:Connect(function()
	local result = MouseRaycast()
	if result and result.Instance then
		print(result.Instance.Name)
	end
end)
