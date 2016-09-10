function newCase()
	
	return {
		mine = false,
		retournee = false,
		numero = nil,
		drapeau = false
	}
end

function newPosition(x,y)
	
	return {
	
	x = x or 0,
	y = y or 0
	}

end

function getSprite(x,y)


	if game.plateau.cases[x][y].retournee == false then
		if game.plateau.cases[x][y].drapeau then
			return casedrapeau
		else
			return casegrise
		end
	else
		if game.plateau.cases[x][y].numero then
			if game.plateau.cases[x][y].numero > 0 then
				return cases[game.plateau.cases[x][y].numero]
			else
				return casevide
			end
		else
			return caseMine
		end
	end
end

function newPlateau()
	local o = {}
	
	function o:construct()
	
		self.cases = {}
		self.largeur = 18
		self.hauteur = 10
		self.mines = 40
		
		return self
	end
	
	function o:load()
		for x = 1, self.largeur do
			self.cases[x] = {}
			for y = 1, self.hauteur do
				self.cases[x][y] = newCase()
			end
		end
		
		if self.largeur > self.hauteur then
			self.dimensionCase = 480 / self.largeur
			self.startX = 0
			self.startY = 272/2 - self.hauteur*self.dimensionCase/2
		elseif self.largeur <= self.hauteur then
			self.dimensionCase = 272 / self.hauteur
			self.startX = 480/2 - self.largeur*self.dimensionCase/2
			self.startY = 0
		end
		
	end

	function o:distributeNumeros()
		for x = 1,self.largeur do
			for y = 1,self.hauteur do
				self.cases[x][y].numero = getTileNumero(x,y)
			end
		end
	end
	
	function o:distributeMines()

		local mines = {}
		
		for i = 1, self.mines do
			mines[i] = newPosition(math.random(1,self.largeur),math.random(1,self.hauteur))
		end
		for i, mine in pairs(mines) do
			self.cases[mine.x][mine.y].mine = true
		end
	end
	
	function o:returnCases(x, y)
		
		for i = 1, 8 do
			local pos = newPosition(x + dirs2[i][1], y + dirs2[i][2])
		
			if TileIsInPlateau(pos.x, pos.y) then
				if self.cases[pos.x][pos.y].retournee == false then
					self.cases[pos.x][pos.y].retournee = true
					
					if self.cases[pos.x][pos.y].numero == 0 then
						self:returnCases(pos.x, pos.y)
					end
				end
			end
		end
	end

function o:checkWin()

	for x = 1, self.largeur do
		for y = 1, self.hauteur do
			if TileIsMine(x,y) then
				if not self.cases[x][y].drapeau then
					return false
				end
			end
		end
	end
	game:win()
end


	function o:demine(x,y)

		if TileIsMine(x,y) then
			game:loose()
			
		elseif self.cases[x][y].retournee == false then
		
			self.cases[x][y].retournee = true

			if self.cases[x][y].numero == 0 then
				self:returnCases(x,y)
			end
		end
	end

	function o:dropDrapeau(x,y)
		self.cases[x][y].drapeau = true
self:checkWin()
	end

	function o:draw()
		for i = 1, self.largeur do
			for j = 1, self.hauteur do
				local sprite = getSprite(i,j)
				local x = self.startX + (i-1)*self.dimensionCase
				local y = self.startY + (j-1)*self.dimensionCase
				
				sprite:draw(x, y, self.dimensionCase, self.dimensionCase)
				
				pge.gfx.drawrect(0,y, 480, 1, noir)
			end
			pge.gfx.drawrect(self.startX + (i-1)*self.dimensionCase,0, 1, 272, noir)
			
		end
	end
	
	return o:construct()
end
