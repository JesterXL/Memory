BackButton = {}

function BackButton:new()
	local button = display.newImage("button_back.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	return button
end

return BackButton