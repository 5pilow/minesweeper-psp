function newFont(font,size)
	local o = {}
	
	function o:construct(font,size)
	
		self.font = pge.font.load(font, size)
		self.size = size
	
		return self
	end

	function o:draw(x, y, text, color)
		
		local color = color or noir
		
		if activeRessource ~= self.font then
			activeRessource = self.font
			self.font:activate()
		end
		
		self.font:print(x, y, color, text)
	end

	function o:drawCenter(y, text, color)
	
		local x = (480 / 2) - (self:measure(text) / 2)
		
		self:draw(x, y, text, color)
	end
	
	function o:measure(text)
		return self.font:measure(text)
	end
	
	function o:drawTable(x, y, tab, color)
	
		for i, v in pairs(tab) do
			
			self:draw(x, y + (i - 1) * self.size, v, color)
		end
	end

	return o:construct(font,size)
end
