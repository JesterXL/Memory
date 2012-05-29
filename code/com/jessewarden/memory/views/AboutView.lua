require "com.jessewarden.memory.views.BackButton"
require "com.jessewarden.memory.Constants"

AboutView = {}

function AboutView:new()
	local view = display.newGroup()

	function view:createChildren()

		local backButton = BackButton:new()
		self:insert(backButton)
		self.backButton = backButton
		function backButton:touch(event)
			if event.phase == "began" then
				view:dispatchEvent({name = "onBackButtonTouched", target=view})
				return true
			end
		end
		backButton:addEventListener("touch", backButton)

		local title = display.newImage("about_screen_title.png")
		title:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(title)
		self.title = title

		tweenDelay				= 700
		tweenIncrement 			= 100
		self.buttonBlog 		= self:getImageButton("about_screen_button_blog.png", "blog", 19, 150, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement

		self.buttonCompany 		= self:getImageButton("about_screen_button_company.png", "company", 19, 280, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement

		self.buttonTwitter 		= self:getImageButton("about_screen_button_twitter.png", "twitter", 19, 410, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement

		self.buttonLinkedIn 	= self:getImageButton("about_screen_button_linkedin.png", "linkedin", 19, 540, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement

		self.buttonGooglePlus 	= self:getImageButton("about_screen_button_googleplus.png", "googleplus", 19, 670, tweenDelay)
		tweenDelay				= tweenDelay + tweenIncrement

		title.x = 208
		title.y = 10

		--backButton.x = 19
		backButton.y = 1
		backButton.x = 39
		backButton.alpha = 0
		backButton.tween = transition.to(backButton, {time=1000, delay=tweenDelay, alpha=1, x=19, transition=easing.outExpo})

	end

	function view:getImageButton(imageURL, name, targetX, targetY, tweenDelay)
		local image = display.newImage(imageURL, true)
		image:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(image)
		function image:touch(event)
			if event.phase == "began" then
				view:onImageButtonTouched(self)
				return true
			end
		end
		image:addEventListener("touch", image)
		image.name = name
		image.x = targetX
		image.alpha = 0
		image.y = targetY - 40
		image.tween = transition.to(image, {time=300, delay=tweenDelay, alpha=1, y=targetY, transition=easing.outExpo})
		return image
	end

	function view:onImageButtonTouched(button)
		if button.name == "blog" then
			system.openURL(Constants.URL_BLOG)
			return true
		elseif button.name == "company" then
			system.openURL(Constants.URL_COMPANY)
			return true
		elseif button.name == "twitter" then
			system.openURL(Constants.URL_TWITTER)
			return true
		elseif button.name == "linkedin" then
			system.openURL(Constants.URL_LINKEDIN)
			return true
		elseif button.name == "googleplus" then
			system.openURL(Constants.URL_GOOGLEPLUS)
			return true
		end
	end

	view:createChildren()

	return view
end

return AboutView