
require "com.jessewarden.core.GameLoop"
require "com.jessewarden.memory.models.NoteModel"
require "com.jessewarden.memory.controllers.NoteController"
require "com.jessewarden.memory.views.NoteView"

require "com.jessewarden.memory.views.CorrectAnimation"
require "com.jessewarden.memory.views.WrongAnimation"
require "com.jessewarden.memory.Constants"
require "com.jessewarden.memory.views.RestartButton"
require "com.jessewarden.memory.views.AboutButton"
require "com.jessewarden.memory.views.AboutView"

MainView = {}

function MainView:new(startX, startY, startWidth, startHeight)

	local main = display.newGroup()

	main.x = startX
	main.y = startY
	main.SCREEN_TRANSITION_SPEED = 700

	main.holder = display.newGroup()
	main:insert(main.holder)

	function main:initialize()
		local loop = GameLoop:new()
		self.loop = loop

		local noteView = NoteView:new()
		self.holder:insert(noteView)
		self.noteView = noteView
		noteView.x = (startWidth / 2) - (Constants.NOTE_VIEW_WIDTH / 2)
		noteView.y = (startHeight / 2) - (Constants.NOTE_VIEW_HEIGHT / 2)

		local noteModel = NoteModel:new()
		self.noteModel = noteModel

		local noteController = NoteController:new(loop, noteView, noteModel)
		self.noteController = noteController

		local correctAnimation = CorrectAnimation:new()
		self.holder:insert(correctAnimation)
		self.correctAnimation = correctAnimation
		correctAnimation.x = (startWidth / 2) - (correctAnimation.width / 2)
		correctAnimation.y = (noteView.y / 2) - correctAnimation.height

		local wrongAnimation = WrongAnimation:new()
		self.holder:insert(wrongAnimation)
		self.wrongAnimation = wrongAnimation
		wrongAnimation.x = (startWidth / 2) - (wrongAnimation.width / 2)
		wrongAnimation.y = (noteView.y / 2) - wrongAnimation.height

		local restartButton = RestartButton:new()
		self.holder:insert(restartButton)
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

		local aboutButton = AboutButton:new()
		self.holder:insert(aboutButton)
		self.aboutButton = aboutButton
		aboutButton.x = startWidth - (aboutButton.width)
		aboutButton.y = startHeight - aboutButton.height
		function aboutButton:touch(event)
			if event.phase == "began" then
				main:showAboutScreen()
				return true
			end
		end
		aboutButton:addEventListener("touch", aboutButton)

		local memoryLogo = display.newImage("memory_logo.png")
		memoryLogo:setReferencePoint(display.TopLeftReferencePoint)
		self.holder:insert(memoryLogo)
		self.memoryLogo = memoryLogo
		memoryLogo.x = 4
		memoryLogo.y = startHeight - (memoryLogo.height + 4)

		Runtime:addEventListener("system", self)
	end

	function main:onSystemEvent(event)
		if event.type == "applicationExit" or event.type == "applicationSuspend" then
			--os.exit()
			if self.loop ~= nil and self.loop.paused == false then
				self.loop:pause()
			end
		elseif event.type == "applicationResume" then
			if self.loop ~= nil and self.loop.paused == true then
				self.loop:start()
			end
		end
	end

	function main:onPlayerChoiceCorrect(event)
		self.wrongAnimation:abort()
		self.correctAnimation:start()
	end

	function main:onPlayerChoiceWrong(event)
		self.correctAnimation:abort()
		self.wrongAnimation:start()
	end

	function main:cancelExistingScreenTransitions()
		if self.aboutTransition ~= nil then
			transition.cancel(self.aboutTransition)
			self.aboutTransition = nil
		end

		if self.holderTransition ~= nil then
			transition.cancel(self.holderTransition)
			self.holderTransition = nil
		end
	end

	function main:showAboutScreen()
		self.loop:pause()
		self:cancelExistingScreenTransitions()

		self.holderTransition = transition.to(self.holder, {time=self.SCREEN_TRANSITION_SPEED, x=-startWidth, transition=easing.inOutExpo})


		local aboutView = AboutView:new()
		aboutView.x = startWidth + 1
		self:insert(aboutView)
		function aboutView:onBackButtonTouched(event)
			main:hideAboutScreen()
		end
		aboutView:addEventListener("onBackButtonTouched", aboutView)
		self.aboutView = aboutView
		self.aboutTransition = transition.to(aboutView, {time=self.SCREEN_TRANSITION_SPEED, x=0, transition=easing.inOutExpo})
	end

	function main:hideAboutScreen()
		self.loop:pause()
		self:cancelExistingScreenTransitions()

		self.holderTransition = transition.to(self.holder, {time=self.SCREEN_TRANSITION_SPEED, x=0, transition=easing.inOutExpo})

		if self.aboutView ~= nil then
			self.aboutTransition = transition.to(self.aboutView, {time=self.SCREEN_TRANSITION_SPEED, x=startWidth + 1, alpha=0, transition=easing.inOutExpo, onComplete=function(target) main:onAboutAnimationComplete() end})
		end
	end

	function main:onAboutAnimationComplete()
		if self.aboutTransition ~= nil then
			transition.cancel(self.aboutTransition)
			self.aboutTransition = nil
		end

		self.aboutView:removeSelf()
		self.aboutView = nil

		self.loop:start()
	end

	Runtime:addEventListener("onPlayerChoiceWrong", main)
	Runtime:addEventListener("onPlayerChoiceCorrect", main)

	return main

end

return MainView