RestartButton = {}

function RestartButton:new()
	local button = display.newImage("restart.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	return button
end

return RestartButton