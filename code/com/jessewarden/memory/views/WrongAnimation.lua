WrongAnimation = {}

function WrongAnimation:new()

	--local anime = display.newImage("wrong.png")
	local anime = display.newGroup()
	local textImage = display.newImage("wrong.png")
	anime:insert(textImage)
	textImage:setReferencePoint(display.TopLeftReferencePoint)
	anime.handle = nil
	anime.alpha = 0

	function anime:cancelExistingAnimes()
		if anime.handle ~= nil then
			transition.cancel(anime.handle)
			anime.handle = nil
		end
		anime:cancelExistingTextAnimes()
	end

	function anime:cancelExistingTextAnimes()
		if textImage.handle ~= nil then
			transition.cancel(textImage.handle)
			textImage.handle = nil
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
		anime.handle = transition.to(anime, {time=300, alpha=0, delay=1000, onComplete=anime.onFadeOutComplete})
		textImage.handle = transition.to(textImage, {time=300, rotation=-10, transition=easing.outExpo, onComplete=anime.onRotateInComplete})
	end

	function anime.onFadeOutComplete(target)
		anime:cancelExistingAnimes()
	end

	function anime.onRotateInComplete(target)
		anime:cancelExistingTextAnimes()
		textImage.handle = transition.to(textImage, {time=500, rotation=10, transition=easing.inExpo})
	end

	return anime

end

return WrongAnimation