function newSprite(file,x,y,w,h)

	local o = {}
	
	function o:construct(file,x,y,w,h)
	
		self.x = x or 0
		self.y = y or 0
		self.w = w
		self.h = h
		self.file = pge.texture.load(file)
		
		return self
	end

	function o:draw(x,y,w,h,angle,alpha)

		w = w or self.w
		h = h or self.h
		
		angle = angle or 0
		alpha = alpha or 255
		
		if activeRessource ~= self.file then
			activeRessource = self.file
			self.file:activate()
		end

		self.file:draw(x,y,w,h, self.x,self.y ,self.w ,self.h,angle,alpha)
	end
	
	function o:drawCenter(x,y,w,h,angle,alpha)
		
		w = w or self.w
		h = h or self.h
		self:draw(x - w / 2,y - h / 2,w,h,angle,alpha)
	end
	
	return o:construct(file,x,y,w,h)
end
