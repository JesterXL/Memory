require "BaseButton"

ButtonYellow = {}

function ButtonYellow:new()
	local button = BaseButton:new("yellow", "button_yellow_sprite_sheet.png")
	return button
end


return ButtonYellow