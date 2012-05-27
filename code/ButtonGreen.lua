require "BaseButton"

ButtonGreen = {}

function ButtonGreen:new()
	local button = BaseButton:new("green", "button_green_sprite_sheet.png")
	return button
end


return ButtonGreen