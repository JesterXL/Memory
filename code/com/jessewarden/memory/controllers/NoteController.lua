-- Events:
--		onPlayerChoiceWrong
--		onPlayerChoiceCorrect

NoteController = {}

function NoteController:new(gameLoop, noteView, noteModel)

	local controller 								= {}
	controller.model 								= noteModel
	controller.gameLoop 							= gameLoop
	controller.view 								= noteView
	controller.elapsedTime 							= 0
	controller.TIMEOUT 								= 1 * 1000
	controller.currentUserIndex 					= 0
	controller.resetting 							= false
	controller.RESET_MILLISECONDS_INCREMENT 		= 200
	controller.resetStart 							= 0
	controller.resetIndex 							= 0



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

		--[[
		local t = {}
		t.index = 1
		function t:timer(event)
			if t.index == 1 then
				view:playNote(Constants.RED)
			elseif t.index == 2 then
				view:playNote(Constants.BLUE)
			elseif t.index == 3 then
				view:playNote(Constants.GREEN)
			elseif t.index == 4 then
				view:playNote(Constants.YELLOW)
				timer.cancel(t.handle)
			end	
			t.index = t.index + 1
		end
		t.handle = timer.performWithDelay(100, t, 0)
		]]--
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
		if self.resetting == true then
			self:onResetTick(time)
			return true
		end

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
			self:endCurrentGame()
			return true
		else
			-- user pressed correct sequence
			print("controller::onNoteButtonPressed, Correct!")
			print("current index: ", self.currentUserIndex, ", total notes: ", #notes)
			--Runtime:dispatchEvent({name = "onPlayerChoiceCorrect", target = self})

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
		Runtime:dispatchEvent({name = "onPlayerChoiceCorrect", target = self})
		local model = self.model
		model:createNewRandomNote()
		model:resetPlayback()

		self.view:setEnabled(false)

		self.elapsedTime = 0

		self.gameLoop:addLoop(self)
	end

	function controller:endCurrentGame(immediate)
		local gameLoop = self.gameLoop
		if gameLoop:has(self) then gameLoop:removeLoop(self) end
		self.view:setEnabled(false)
		self.resetting = true
		self.resetStart = 0
		self.resetIndex = 0
		if self.resetTimer ~= nil then
			timer.cancel(self.resetTimer)
		end
		if immediate ~= true then
			self.resetTimer = timer.performWithDelay(2000, self, 1)
		else
			self.gameLoop:addLoop(self)
		end	
	end

	function controller:timer()
		if self.resetTimer ~= nil then
			timer.cancel(self.resetTimer)
			self.resetTimer = nil
		end
		self.gameLoop:addLoop(self)
	end

	function controller:onResetTick(time)
		if self.resetting == false then
			return true
		end

		self.resetStart = self.resetStart + time
		if self.resetStart >= self.RESET_MILLISECONDS_INCREMENT then
			self.resetStart = 0
			self.resetIndex = self.resetIndex + 1
			local view = self.view
			if self.resetIndex == 1 then
				view:playNote(Constants.RED, false)
			elseif self.resetIndex == 2 then
				view:playNote(Constants.BLUE, false)
			elseif self.resetIndex == 3 then
				view:playNote(Constants.YELLOW, false)
			elseif self.resetIndex == 4 then
				view:playNote(Constants.GREEN, false)
			elseif self.resetIndex == 5 then
				self.resetting = false
				self.gameLoop:removeLoop(self)
				self:resetGame()
			end	
		end
	end

	return controller

end

return NoteController