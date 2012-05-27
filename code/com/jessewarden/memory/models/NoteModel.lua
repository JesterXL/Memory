-- Events:
--		onNewRandomNote

NoteModel = {}

function NoteModel:new()

	local model = {}
	model.playbackIndex = nil
	
	function model:reset()
		self.notes = {}
	end

	function model:createNewRandomNote()
		local num = math.random(4)
		table.insert(self.notes, num)
		return num
	end

	function model:getNotes()
		return self.notes
	end

	-- Note Playback --
	function model:resetPlayback()
		self.playbackIndex = 1
	end

	function model:hasAnotherNoteToPlayback()
		local notes = self:getNotes()
		if notes == nil then
			return false
		end
		local notesLen = table.maxn(notes)
		if self.playbackIndex <= notesLen then
			return true
		end

		return false
	end

	function model:getNextNoteToPlay()
		local noteType = self.notes[self.playbackIndex]
		self.playbackIndex = self.playbackIndex + 1
		return noteType
	end

	model:reset()

	return model

end

return NoteModel