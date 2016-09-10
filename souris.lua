function newSouris()

	local o = {}

	function o:construct()

		self.pos = newPosition(1,1)

		return self
	end

	function o:move(dir)

		self.pos.x = self.pos.x + dirs[dir][1]
		self.pos.y = self.pos.y + dirs[dir][2]
	end

	function o:draw()
		local x = game.plateau.startX + (self.pos.x-1)*game.plateau.dimensionCase
		local y = game.plateau.startY + (self.pos.y-1)*game.plateau.dimensionCase
		pge.gfx.drawrect(x,y,game.plateau.dimensionCase, game.plateau.dimensionCase,pge.gfx.createcolor(0,0,0,150))

	end

	return o:construct()
end
