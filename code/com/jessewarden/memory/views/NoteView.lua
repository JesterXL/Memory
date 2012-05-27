require "Constants"

NoteView = {}

function NoteView:new()

	local notes = display.newGroup()

	function notes:createChildren()
		local buttonRed = ButtonRed:new()
		buttonRed.x = 100
		buttonRed.y = 100

		local buttonBlue = ButtonBlue:new()
		buttonBlue.x = 316
		buttonBlue.y = 100

		local buttonGreen = ButtonGreen:new()
		buttonGreen.x = 100
		buttonGreen.y = 316

		local buttonYellow = ButtonYellow:new()
		buttonYellow.x = 316
		buttonYellow.y = 316

		buttonRed:addEventListener("touch", self)
		buttonBlue:addEventListener("touch", self)
		buttonYellow:addEventListener("touch", self)
		buttonGreen:addEventListener("touch", self)

		self.buttonRed = buttonRed
		self.buttonBlue = buttonBlue
		self.buttonYellow = buttonYellow
		self.buttonGreen = buttonGreen
	end

	function notes:touch(event)
		if self.enabled == false then
			return true
		end

		--[[
		Constants.RED 		= 1
		Constants.BLUE 		= 2
		Constants.GREEN 	= 3
		Constants.YELLOW 	= 4
		]]--
		if event.phase == "began" then
			if event.target == self.buttonRed then
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.RED})
				return true
			elseif event.target == self.buttonBlue then
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.BLUE})
				return true
			elseif event.target == self.buttonGreen then
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.GREEN})
				return true
			elseif event.target == self.buttonYellow then
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.YELLOW})
				return true
			else
				error("Unknown button touched for target: ", event.target)
			end
		end
	end

	function notes:setEnabled(enable)
		self.enabled = enable
	end

	function notes:playNote(type)
		--[[
		Constants.RED 		= 1
		Constants.BLUE 		= 2
		Constants.GREEN 	= 3
		Constants.YELLOW 	= 4
		]]--
		if type == Constants.RED then
			self.buttonRed:play()
		elseif type == Constants.BLUE then 
			self.buttonBlue:play()
		elseif type == Constants.GREEN then
			self.buttonGreen:play()
		elseif type == Constants.YELLOW then
			self.buttonYellow:play()
		else
			error("Unknown note type.")
		end
	end

	notes:createChildren()
	notes:setEnabled(true)

	return notes
end

return NoteView