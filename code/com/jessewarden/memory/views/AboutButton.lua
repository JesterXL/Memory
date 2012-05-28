AboutButton = {}

function AboutButton:new()
	local button = display.newImage("button_about.png")
	button:setReferencePoint(display.TopLeftReferencePoint)
	--[[
	button.alpha = 0.4

	function button:cancelExistingTweens()
		if self.handle ~= nil then
			transition.cancel(self.handle)
			self.handle = nil
		end
	end

	function button:touch(event)
		self:cancelExistingTweens()
		if event.phase == "began" then
			self.handle = transition.to(self, {time=300, alpha=1})
		elseif event.phase == "ended" or event.phase == "cancelled" then
			self.handle = transition.to(self, {time=300, alpha=0.4})
		end
	end

	button:addEventListener("touch", button)
	]]--

	return button
end

return AboutButton