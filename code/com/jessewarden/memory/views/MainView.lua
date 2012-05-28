require "com.jessewarden.core.GameLoop"
require "com.jessewarden.memory.models.NoteModel"
require "com.jessewarden.memory.controllers.NoteController"
require "com.jessewarden.memory.views.NoteView"

require "com.jessewarden.memory.views.CorrectAnimation"
require "com.jessewarden.memory.Constants"


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
		noteView.y = startHeight - Constants.NOTE_VIEW_HEIGHT - 20

		local noteModel = NoteModel:new()
		self.noteModel = noteModel

		local noteController = NoteController:new(loop, noteView, noteModel)
		self.noteController = noteController

		local correctAnimation = CorrectAnimation:new()
		self:insert(correctAnimation)
		self.correctAnimation = correctAnimation
		correctAnimation.x = (startWidth / 2) - (correctAnimation.width / 2)
		correctAnimation.y = 20

		noteController:initialize()
	end

	function main:onPlayerChoiceCorrect(event)
		self.correctAnimation:start()
	end

	--Runtime:addEventListener("onPlayerChoiceWrong", mediator)
	Runtime:addEventListener("onPlayerChoiceCorrect", main)

	return main

end

return MainView