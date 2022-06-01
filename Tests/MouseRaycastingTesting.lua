local UserInputService = game:GetService("UserInputService")

while true do
	local mousePos = UserInputService:GetMouseLocation()
	task.wait(3)
	print(mousePos)
end
