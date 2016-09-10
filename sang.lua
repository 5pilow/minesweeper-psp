function newSangSystem()
	local o = {}
	
	function o:construct()
	
		self.sprite = {
		[1] = newSprite("sprite.png",200,40,44,44),
		
		}
		
		self.taches = {}
	
		return self
	end
	
	function o:addTache(x,y,size)
	
		table.insert(self.taches, {
			x = x,
			y = y,
			size = size,
			alpha = 255
		})
	end
	
	function o:removeTache(tache)
	
		table.remove(self.taches, tache)
	end
	
	function o:update()
		for i, tache in pairs(self.taches) do
			tache.size = tache.size + 1
			tache.alpha = tache.alpha - 3
			if tache.alpha < 40 then
				self:removeTache(i)
			end
		end
		
	end
	
	function o:draw()
		for i, tache in pairs(self.taches) do
			self.sprite[1]:drawCenter(tache.x, tache.y, tache.size, tache.size, 0, tache.alpha)
		end
	
	end
	return o:construct()
end
