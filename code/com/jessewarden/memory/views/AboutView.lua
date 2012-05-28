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

		self.buttonBlog 		= self:getImageButton("about_screen_button_blog.png", "blog")
		self.buttonCompany 		= self:getImageButton("about_screen_button_company.png", "company")
		self.buttonTwitter 		= self:getImageButton("about_screen_button_twitter.png", "twitter")
		self.buttonLinkedIn 	= self:getImageButton("about_screen_button_linkedin.png", "linkedin")
		self.buttonGooglePlus 	= self:getImageButton("about_screen_button_googleplus.png", "googleplus")

		title.x = 208
		title.y = 10

		backButton.x = 19
		backButton.y = 1

		self.buttonBlog.x = 19
		self.buttonBlog.y = 150

		self.buttonCompany = 19
		self.buttonCompany = 280

		self.buttonTwitter = 19
		self.buttonTwitter = 410

		self.buttonLinkedIn = 19
		self.buttonLinkedIn = 540

		self.buttonGooglePlus.x = 19
		self.buttonGooglePlus.y = 670

	end

	function view:getImageButton(imageURL, name)
		local image = display.newImage(imageURL, true)
		image:setReferencePoint(display.TopLeftReferencePoint)
		self:insert(image)
		function image:touch(event)
			if event.phase == "began" then
				view:onImageButtonTouched(self)
				return true
			end
		end
		image.name = name
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