require "com.jessewarden.core.GameLoop"
require "com.jessewarden.memory.models.NoteModel"
require "com.jessewarden.memory.controllers.NoteController"
require "com.jessewarden.memory.views.NoteView"

require "com.jessewarden.memory.views.CorrectAnimation"
require "com.jessewarden.memory.views.WrongAnimation"
require "com.jessewarden.memory.Constants"
require "com.jessewarden.memory.views.RestartButton"

MainView = {}

function MainView:new(startX, startY, startWidth, startHeight)

	local main = display.newGroup()

	main.x = startX
	main.y = startY

	function main:initialize()
		local loop = GameLoop:new()
		self.loop = loop

		local noteView = NoteView:new()
		self:insert(noteView)
		self.noteView = noteView
		noteView.x = (startWidth / 2) - (Constants.NOTE_VIEW_WIDTH / 2)
		noteView.y = (startHeight / 2) - (Constants.NOTE_VIEW_HEIGHT / 2)

		local noteModel = NoteModel:new()
		self.noteModel = noteModel

		local noteController = NoteController:new(loop, noteView, noteModel)
		self.noteController = noteController

		local correctAnimation = CorrectAnimation:new()
		self:insert(correctAnimation)
		self.correctAnimation = correctAnimation
		correctAnimation.x = (startWidth / 2) - (correctAnimation.width / 2)
		correctAnimation.y = (noteView.y / 2) - correctAnimation.height

		local wrongAnimation = WrongAnimation:new()
		self:insert(wrongAnimation)
		self.wrongAnimation = wrongAnimation
		wrongAnimation.x = (startWidth / 2) - (wrongAnimation.width / 2)
		wrongAnimation.y = (noteView.y / 2) - wrongAnimation.height

		local restartButton = RestartButton:new()
		self:insert(restartButton)
		self.restartButton = restartButton
		restartButton.x = noteView.x + (Constants.NOTE_VIEW_WIDTH / 2) - (restartButton.width / 2)
		restartButton.y = noteView.y + (Constants.NOTE_VIEW_HEIGHT / 2) - (restartButton.height / 2)
		function restartButton:touch(event)
			if event.phase == "began" then
				noteController:endCurrentGame(true)
				return true
			end
		end
		restartButton:addEventListener("touch", restartButton)

		noteController:initialize()
	end

	function main:onPlayerChoiceCorrect(event)
		self.wrongAnimation:abort()
		self.correctAnimation:start()
	end

	function main:onPlayerChoiceWrong(event)
		print("telling wrong to show")
		self.correctAnimation:abort()
		self.wrongAnimation:start()
	end

	Runtime:addEventListener("onPlayerChoiceWrong", main)
	Runtime:addEventListener("onPlayerChoiceCorrect", main)

	return main

end

return MainView