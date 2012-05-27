require "ButtonBlue"
require "ButtonYellow"
require "ButtonRed"
require "ButtonGreen"

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

local function testMainController()
	require "com.jessewarden.core.GameLoop"
	require "com.jessewarden.memory.models.NoteModel"
	require "com.jessewarden.memory.controllers.NoteController"
	require "com.jessewarden.memory.views.NoteView"

	local loop = GameLoop:new()
	local view = NoteView:new()
	local model = NoteModel:new()
	local controller = NoteController:new(loop, view, model)
	controller:initialize()
end


--testButtonBlue()
--testAllButtons()
--testMemory()
--testNoteViewDisable()
--testStateMachineLibrary()
--testModelIteration()
testMainController()