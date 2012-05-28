-- Events:
--		onPlayerChoiceWrong
--		onPlayerChoiceCorrect

NoteController = {}

function NoteController:new(gameLoop, noteView, noteModel)

	local controller 				= {}
	controller.model 				= noteModel
	controller.gameLoop 			= gameLoop
	controller.view 				= noteView
	controller.elapsedTime 			= 0
	controller.TIMEOUT 				= 1 * 1000
	controller.currentUserIndex 	= 0


	function controller:initialize()
		local gameLoop = self.gameLoop
		gameLoop:reset()
		gameLoop:start()
		gameLoop:addLoop(self)

		local model = self.model
		model:reset()
		model:createNewRandomNote()
		model:resetPlayback()

		local view = self.view
		view:setEnabled(false)
		view:addEventListener("onNoteButtonPressed", self)

		self.elapsedTime = 0
	end

	-- [jwarden 5.27.2012] TODO: refactor duplicated code from above
	function controller:resetGame()
		local model = self.model
		model:reset()
		model:createNewRandomNote()
		model:resetPlayback()

		self.view:setEnabled(false)

		self.elapsedTime = 0

		self.gameLoop:addLoop(self)
	end

	function controller:tick(time)
		local done = false
		self.elapsedTime = self.elapsedTime + time
		if self.elapsedTime >= self.TIMEOUT then
			local model = self.model
			if model:hasAnotherNoteToPlayback() then
				local currentNote = model:getNextNoteToPlay()
				self.view:playNote(currentNote)
				self.elapsedTime = 0
				if model:hasAnotherNoteToPlayback() == false then
					done = true
				end
			else
				done = true
			end
		end

		if done == true then
			self:onPlaybackComplete()
		end
	end

	function controller:onPlaybackComplete()
		self.gameLoop:removeLoop(self)
		self.view:setEnabled(true)
		self.currentUserIndex = 1
	end

	function controller:onNoteButtonPressed(event)
		local model 			= self.model
		local notes 			= model:getNotes()
		local correctNote 		= notes[self.currentUserIndex]
		local usersTouchedNote 	= event.value
		if usersTouchedNote ~= correctNote then
			-- user touched the wrong order
			print("controller::onNoteButtonPressed, INCORRECT...")
			Runtime:dispatchEvent({name = "onPlayerChoiceWrong", target = self})
			self:resetGame()
			return true
		else
			-- user pressed correct sequence
			print("controller::onNoteButtonPressed, Correct!")
			print("current index: ", self.currentUserIndex, ", total notes: ", #notes)
			Runtime:dispatchEvent({name = "onPlayerChoiceCorrect", target = self})
			if self.currentUserIndex + 1 <= table.maxn(notes) then
				-- more to go
				self.currentUserIndex = self.currentUserIndex + 1
			else
				-- user's done with sequence, add 1 more
				self:onUserCompletedSequence()
			end
		end
	end

	function controller:onUserCompletedSequence()
		local model = self.model
		model:createNewRandomNote()
		model:resetPlayback()

		self.view:setEnabled(false)

		self.elapsedTime = 0

		self.gameLoop:addLoop(self)
	end 


	return controller

end

return NoteController