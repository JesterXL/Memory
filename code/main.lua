
display.setStatusBar( display.HiddenStatusBar )


local stage = display.getCurrentStage()

function showProps(o)
	print("-- showProps --")
	print("o: ", o)
	for key,value in pairs(o) do
		print("key: ", key, ", value: ", value);
	end
	print("-- end showProps --")
end


local function testButtonBlue()
	require "com.jessewarden.memory.views.ButtonBlue"
	local buttonBlue = ButtonBlue:new()
	buttonBlue.x = 100
	buttonBlue.y = 100
	function buttonBlue:touch(event)
		if event.phase == "began" then
			self:play()
		end
	end
	buttonBlue:addEventListener("touch", buttonBlue)
end

local function testButtonYellow()
	require "com.jessewarden.memory.views.ButtonYellow"
	local buttonYellow = ButtonYellow:new()
	buttonYellow.x = 100
	buttonYellow.y = 100
	function buttonYellow:touch(event)
		if event.phase == "began" then
			self:play()
		end
	end
	buttonYellow:addEventListener("touch", buttonYellow)
end

local function testButtonGreen()
	require "com.jessewarden.memory.views.ButtonGreen"
	local button = ButtonGreen:new()
	button.x = 100
	button.y = 100
	function button:touch(event)
		if event.phase == "began" then
			self:play()
		end
	end
	button:addEventListener("touch", button)
end

local function testAllButtons()
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
end

local function testMemory()
	require "NoteModel"

	local model = NoteModel:new()
	function model:onNewRandomNote(event)
		print("onNewRandomNote, value: ", event.value)
	end
	Runtime:addEventListener("onNewRandomNote", model)
	function model:timer(event)
		model:createNewRandomNote()
	end
	timer.performWithDelay(1000, model, 5)

end

local function testNoteViewDisable()
	require "NoteView"

	local noteView = NoteView:new()
	local t = {}
	function t:onNoteButtonPressed(event)
		print("button pressed: ", event.value)
	end
	noteView:addEventListener("onNoteButtonPressed", t)
	noteView:setEnabled(true)

end

local function testStateMachineLibrary()
	require "com.jessewarden.core.statemachine.statemachinetests"

end

local function testModelIteration()
	require "com.jessewarden.memory.models.NoteModel"

	local model 		= NoteModel:new()
	local firstNote 	= model:createNewRandomNote()
	local secondNote 	= model:createNewRandomNote()
	local thirdNote 	= model:createNewRandomNote()

	assert(table.maxn(model:getNotes()) == 3, "Assert: Nodes are not 3 in length.")

	model:resetPlayback()

	assert(model:hasAnotherNoteToPlayback(), "Assert: Iterator's hasNext is broken.")

	assert(model:getNextNoteToPlay() == firstNote, "Assert: next() iterator is broken for first time.")
	assert(model:hasAnotherNoteToPlayback(), "Assert: Iterator's hasNext is broken after first.")
	
	assert(model:getNextNoteToPlay() == secondNote, "Assert: next() iterator is broken for second time.")
	assert(model:hasAnotherNoteToPlayback(), "Assert: Iterator's hasNext is broken after second.")

	assert(model:getNextNoteToPlay() == thirdNote, "Assert: next() iterator is broken for third time.")
	assert(model:hasAnotherNoteToPlayback() == false, "Assert: Iterator's hasNext is broken after third.")

	model:resetPlayback()

	assert(model:hasAnotherNoteToPlayback() == true, "Assert: Iterator's hasNext is broken after reset.")

end

local function testCorrectAnimation()
	require "com.jessewarden.memory.views.CorrectAnimation"
	local anime = CorrectAnimation:new()
	local stage = display.getCurrentStage()
	anime.x = (stage.contentWidth / 2) - (anime.width / 2)
	anime.y = 200
	anime:start()

	-- try to break it
	--[[
	local t = {}
	function t:timer(event)
		anime:start()
	end
	t.handler = timer.performWithDelay(600, t, 6)

	local cow = {}
	function cow:timer(event)
		anime:start()
	end
	cow.handler = timer.performWithDelay(6 * 1000, cow, 1)
	]]--
end

local function testMainController()
	require "com.jessewarden.core.GameLoop"
	require "com.jessewarden.memory.models.NoteModel"
	require "com.jessewarden.memory.controllers.NoteController"
	require "com.jessewarden.memory.views.NoteView"

	require "com.jessewarden.memory.views.CorrectAnimation"
	require "com.jessewarden.memory.Constants"

	local stage = display.getCurrentStage()

	local loop = GameLoop:new()
	local view = NoteView:new()
	view.x = (stage.contentWidth / 2) - (Constants.NOTE_VIEW_WIDTH / 2)
	view.y = stage.contentHeight - Constants.NOTE_VIEW_HEIGHT - 20

	local model = NoteModel:new()
	local controller = NoteController:new(loop, view, model)

	local correctAnimation = CorrectAnimation:new()
	correctAnimation.x = (stage.contentWidth / 2) - (correctAnimation.width / 2)
	correctAnimation.y = 20

	controller:initialize()
end

local function testWrongAnimation()
	require "com.jessewarden.memory.views.WrongAnimation"
	local test = WrongAnimation:new()
	test.x = 200
	test.y = 100
	test:start()

end

function startThisMug()
	display.setStatusBar( display.HiddenStatusBar )
	require "com.jessewarden.memory.views.MainView"

	local stage = display.getCurrentStage()

	-- [jwarden 5.28.2012] Just used to show true background size
	--[[
	local rect = display.newRect(stage.xOrigin, stage.yOrigin, stage.contentWidth, stage.contentHeight)
	rect:setFillColor(255, 0, 0, 125) 
	rect:setStrokeColor(255, 0, 0) 
	rect.strokeWidth = 4
	]]--
	mainView = MainView:new(0, 0, stage.contentWidth, stage.contentHeight)
	mainView:initialize()

end







--testButtonBlue()
--testButtonYellow()
--testButtonGreen()
--testAllButtons()
--testMemory()
--testNoteViewDisable()
--testStateMachineLibrary()
--testModelIteration()
--testCorrectAnimation()
--testMainController()
--testWrongAnimation()

startThisMug()
