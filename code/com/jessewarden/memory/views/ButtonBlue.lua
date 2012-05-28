require "BaseButton"

ButtonBlue = {}

function ButtonBlue:new()
	local button = BaseButton:new("blue", "button_blue_sprite_sheet.png")
	return button
end


return ButtonBlue