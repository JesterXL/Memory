require "sprite"

BaseButton = {}

function BaseButton:new(name, spriteSheetImage)
	local button = display.newGroup()
	local anime = nil
	if BaseButton[name .. "buttonSheet"] == nil then

		local buttonSheet = sprite.newSpriteSheet(spriteSheetImage, 216, 216)
		BaseButton[name .. "buttonSheet"] = buttonSheet
		local buttonSet = sprite.newSpriteSet(buttonSheet, 1, 10)
		sprite.add(buttonSet, name .. "Set", 1, 10, 500, 1)
		anime = sprite.newSprite(buttonSet)
		anime:prepare(name .. "Set")
		anime:setReferencePoint(display.TopLeftReferencePoint)
		button:insert(anime)
	end

	function button:play()
		anime.currentFrame = 1
		anime:prepare()
		anime:play()
	end

	-- [jwarden 5.27.2012] Just testing
	--[[
	function button:touch(event)
		if event.phase == "began" then
			self:play()
		end
	end

	button:addEventListener("touch", button)
	]]--
	return button

end

return BaseButton