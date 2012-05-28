CorrectAnimation = {}

function CorrectAnimation:new()

	local anime = display.newImage("correct.png")
	anime:setReferencePoint(display.TopLeftReferencePoint)
	anime.handle = nil
	anime.alpha = 0

	function anime:cancelExistingAnimes()
		if anime.handle ~= nil then
			transition.cancel(anime.handle)
			anime.handle = nil
		end
	end

	function anime:start()
		self:cancelExistingAnimes()

		self.alpha = 0
		anime.handle = transition.to(self, {time=300, alpha = 1, onComplete=self.onFadeInComplete})
	end

	function anime:abort()
		anime:cancelExistingAnimes()
		self.alpha = 0
	end

	function anime.onFadeInComplete(target)
		anime:cancelExistingAnimes()
		anime.handle = transition.to(anime, {time=300, alpha=0, delay=500, onComplete=anime.onFadeOutComplete})
	end

	function anime.onFadeOutComplete(target)
		anime:cancelExistingAnimes()
	end

	return anime

end

return CorrectAnimation