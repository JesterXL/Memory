require "com.jessewarden.memory.Constants"
require "com.jessewarden.memory.views.ButtonRed"
require "com.jessewarden.memory.views.ButtonBlue"
require "com.jessewarden.memory.views.ButtonGreen"
require "com.jessewarden.memory.views.ButtonYellow"

NoteView = {}

function NoteView:new()

	local notes = display.newGroup()

	function notes:createChildren()
		local buttonRed = ButtonRed:new()
		buttonRed.x = 100
		buttonRed.y = 100
		self:insert(buttonRed)

		local buttonBlue = ButtonBlue:new()
		buttonBlue.x = 316
		buttonBlue.y = 100
		self:insert(buttonBlue)

		local buttonGreen = ButtonGreen:new()
		buttonGreen.x = 100
		buttonGreen.y = 316
		self:insert(buttonGreen)

		local buttonYellow = ButtonYellow:new()
		buttonYellow.x = 316
		buttonYellow.y = 316
		self:insert(buttonYellow)

		buttonRed:addEventListener("touch", self)
		buttonBlue:addEventListener("touch", self)
		buttonYellow:addEventListener("touch", self)
		buttonGreen:addEventListener("touch", self)

		self.buttonRed = buttonRed
		self.buttonBlue = buttonBlue
		self.buttonYellow = buttonYellow
		self.buttonGreen = buttonGreen

		self.soundRed = audio.loadSound("sound_button_01.wav")
		self.soundBlue = audio.loadSound("sound_button_02.wav")
		self.soundGreen = audio.loadSound("sound_button_03.wav")
		self.soundYellow = audio.loadSound("sound_button_04.wav")
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
			event.target:play()
			if event.target == self.buttonRed then
				self:playSound(self.soundRed)
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.RED})
				return true
			elseif event.target == self.buttonBlue then
				self:playSound(self.soundBlue)
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.BLUE})
				return true
			elseif event.target == self.buttonGreen then
				self:playSound(self.soundGreen)
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.GREEN})
				return true
			elseif event.target == self.buttonYellow then
				self:playSound(self.soundYellow)
				self:dispatchEvent({name = "onNoteButtonPressed", target = self, value = Constants.YELLOW})
				return true
			else
				error("Unknown button touched for target: ", event.target)
			end
		end
	end

	function notes:playSound(sound)
		audio.play(sound)
	end

	function notes:setEnabled(enable)
		self.enabled = enable
	end

	function notes:playNote(type, playSound)
		--[[
		Constants.RED 		= 1
		Constants.BLUE 		= 2
		Constants.GREEN 	= 3
		Constants.YELLOW 	= 4
		]]--
		if playSound ~= false then playSound = true end

		if type == Constants.RED then
			if playSound == true then self:playSound(self.soundRed) end
			self.buttonRed:play()
		elseif type == Constants.BLUE then 
			if playSound == true then self:playSound(self.soundBlue) end
			self.buttonBlue:play()
		elseif type == Constants.GREEN then
			if playSound == true then self:playSound(self.soundGreen) end
			self.buttonGreen:play()
		elseif type == Constants.YELLOW then
			if playSound == true then self:playSound(self.soundYellow) end
			self.buttonYellow:play()
		else
			error("Unknown note type.")
			return false
		end
	end

	notes:createChildren()
	notes:setEnabled(true)

	return notes
end

return NoteView