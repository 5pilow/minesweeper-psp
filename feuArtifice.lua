function newFeuArtifice()
	local o = {}
	
	function o:construct()
	
		self.sprite = {
		[1] = newSprite("sprite.png",1,41,48,45),
		[2] = newSprite("sprite.png",51,41,48,45),
		[3] = newSprite("sprite.png",101,41,48,45),
		[4] = newSprite("sprite.png",151,41,48,45)
		}
		self.explosions = {}
	
		return self
	end
	
	--~ Ajouter une explosion :
	function o:addFeuArtifice(x, y, stars, couleur)
		
		table.insert(self.explosions, {
			stars = {},
			startX = x,
			startY = y,
			starNumber = stars,
			time = 0,
			couleur = couleur or 1
		})
		explosion = #self.explosions
		for i = 1, stars do
			self.explosions[explosion].stars[i] = self:addStar(explosion, x, y)
		end
		
		boom:play()
		
	end
	
	--~ Stopper l'apparition de nouvelles etoiles dans toutes les explosions :
	function o:stopPropagation()
		for i, explosion in pairs(self.explosions) do
			explosion.starNumber = 0
		end
	end
	
	--~ Ajouter une etoile dans une explosion
	function o:addStar(explosion, x, y)
		
		table.insert(self.explosions[explosion].stars, {
			pos = newPosition(x, y),
			dir = math.random(1,360),
			alpha = 255,
			angle = 0,
			vitesse = math.random(4,5),
			couleur = self.explosions[explosion].couleur
		})
		self.explosions[explosion].starNumber = self.explosions[explosion].starNumber - 1
	end
	
	--~ Enlever une etoile dans une explosion :
	function o:removeStar(explosion,star)
		table.remove(self.explosions[explosion].stars, star)
		if #self.explosions[explosion].stars == 0 then
			self:removeExplosion(explosion)
		end
	end
	
	--~ Enlever une explosion :
	function o:removeExplosion(explosion)
		table.remove(self.explosions, explosion)
	end

	function o:update()
				
		for i, explosion in pairs(self.explosions) do
		
			explosion.time = explosion.time + 1
		
			for j, star in pairs(explosion.stars) do
			
				local dirX = math.cos(star.dir)
				local dirY = math.sin(star.dir)
				
				star.pos.x = star.pos.x + dirX*star.vitesse
				star.pos.y = star.pos.y + dirY*star.vitesse
				star.vitesse = star.vitesse - star.vitesse/40
				star.alpha = star.alpha - 3
				star.angle = star.angle + 0.01
				
				if ((star.pos.x > 480+15 or star.pos.x < -30) or (star.pos.y > 272+15 or star.pos.y < -15)) or star.alpha < 40 then
					self:removeStar(i, j)
				end
			end
		end
	end

	function o:draw()
		for i, explosion in pairs(self.explosions) do
			for j, star in pairs(explosion.stars) do
				self.sprite[star.couleur]:drawCenter(star.pos.x, star.pos.y, nil, nil, star.angle, star.alpha)
			end
		end
	end

	return o:construct()
end
