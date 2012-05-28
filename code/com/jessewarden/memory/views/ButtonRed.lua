require "BaseButton"

ButtonRed = {}

function ButtonRed:new()
	local button = BaseButton:new("red", "button_red_sprite_sheet.png")
	return button
end


return ButtonRed