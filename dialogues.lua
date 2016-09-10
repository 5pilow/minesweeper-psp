DialogueMode = {

	NORMAL = 1,
	INFO = 2,
	PARAM = 3
}
ParamMode = {

	NUMBER = 1,
	BOOLEAN = 2,
	STRING = 3
}

function newDialogues()

	local o = {}

	function o:construct()
	
		self.dialogues = {}
		self.aD = nil
		self.actuel = 1
		self.validation = nil
		self.dialoguesColor = pge.gfx.createcolor(255,255,255,150)
		self.fleche = newSprite(12*40,0,15,10)
		
		self.dialoguesPrecedents = {}
		self.dialogueActuel = 1
		
		self.offSet = 0
		
		--Ajout des differents dialogues du jeu (mode, nom, titre, actions) :
		
		self:addDialogue(DialogueMode.NORMAL,"menu","Menu",{
		
			{function() dialogues:setAD("choixJeu") end,"Jouer"},
			{function() self:setAD("paramEditeur") end,"Editeur"},
			{function() pge.exit() end,"Quitter"}
		})
	
		self:addDialogue(DialogueMode.NORMAL,"validation","Confirmer", {
		
			{function() end,"Oui"},
			{function() end,"Non"}
		})

		self:addDialogue(DialogueMode.PARAM,"paramJeuLibre","Parametres Jeu Libre", {
		
			{ParamMode.NUMBER,"Cases en largeur",10,10,50},
			{ParamMode.NUMBER,"Cases en hauteur",10,10,50},
		},
		function() self:setAD(nil) end
		)
		
		self:addDialogue(DialogueMode.INFO, "info", "Information", {{function() end,"Info"}})

		return self
	end
	
	function o:getTailleRect(dialogue)

		local tX, tY = 0,0
		for i, v in pairs(dialogue) do
			
			tY = tY + 30
			
			if acens20:measure(v.texte) > tX then
				tX = acens20:measure(v.texte)
			end
		end
		if tY > 150 then
			tY = 150
		end
		
		return tX + 60, tY + 10
	end

	function o:addDialogue(mode,nom,titre,action,actionCross)

		local dialogue = {mode = mode,nom = nom,titre = titre,action = {},actionCross = actionCross}
		
		for i, v in pairs(action) do
		
			dialogue.action[i] = {texte,action,mode,valeur,limits}
			
			if mode == DialogueMode.INFO then
				
				dialogue.action[i].action = v[1]
				dialogue.action[i].texte = v[2]
			end
			if mode == DialogueMode.NORMAL then
			
				dialogue.action[i].action = v[1]
				dialogue.action[i].texte = v[2]
			end
			if mode == DialogueMode.PARAM then
			
				dialogue.action[i].mode = v[1]
				dialogue.action[i].texte = v[2]
				dialogue.action[i].valeur = v[3]
				dialogue.action[i].limits = {v[4],v[5]}
			end
		end
		
		dialogue.tailleRectX, dialogue.tailleRectY = self:getTailleRect(dialogue.action)	
		
		dialogue.total = #action
		self.dialogues[nom] = dialogue
	end
	
	function o:returnToPD()
		if self.dialoguesPrecedents[#self.dialoguesPrecedents-1] then
			self:setAD(self.dialoguesPrecedents[#self.dialoguesPrecedents-1],true)
		end
		table.remove(self.dialoguesPrecedents, #self.dialoguesPrecedents)
	end

	function o:setAD(nom,insert)
		if not insert then
			table.insert(self.dialoguesPrecedents,nom)
		end
		self.aD = nom
		self.actuel = 1
		self.offSet = 0
	end
	
	function o:SetInfoDialogueItems(text,func,titre)
	
		self.dialogues["info"].titre = titre 
		self.dialogues["info"].action[1].texte = text
		self.dialogues["info"].action[1].action = func
		self.dialogues["info"].tailleRectX = self:getTailleRect({{texte=text}})
	end

	function o:SetValidFunction(True,False,titre)
		
		if titre then
			self.dialogues["validation"].titre = titre
		end
		if True then
			self.dialogues["validation"].action[1].action = True
		end
		if False then
			self.dialogues["validation"].action[2].action = False
		end
	end

	function o:update(dt)
		
		local dialogue = self.dialogues[self.aD]
		
		if dialogue.mode ~= DialogueMode.INFO then
			if pge.controls.pressed(PGE_CTRL_DOWN) then
			
				if self.actuel < dialogue.total then
					self.actuel = self.actuel + 1
					if self.actuel > self.offSet + 5 then
						self.offSet = self.offSet + 1
					end
				elseif self.actuel == dialogue.total then
					self.actuel = 1
					self.offSet = 0
				end
			end
			if pge.controls.pressed(PGE_CTRL_UP) then
				if self.actuel > 1 then
					self.actuel = self.actuel - 1
					if self.actuel - self.offSet < 1 then
						self.offSet = self.offSet - 1
					end
				elseif self.actuel == 1 then
					self.actuel = dialogue.total
					if dialogue.total > 5 then
						self.offSet = dialogue.total - 5
					end
				end
			end
			
			if dialogue.mode == DialogueMode.PARAM then
			
				if pge.controls.pressed(PGE_CTRL_LEFT) then
					if dialogue.action[self.actuel].mode == ParamMode.NUMBER and dialogue.action[self.actuel].valeur > dialogue.action[self.actuel].limits[1] then
						dialogue.action[self.actuel].valeur = dialogue.action[self.actuel].valeur - 1
					end
				end
				if pge.controls.pressed(PGE_CTRL_RIGHT) then
					if dialogue.action[self.actuel].mode == ParamMode.NUMBER and dialogue.action[self.actuel].valeur < dialogue.action[self.actuel].limits[2] then
						dialogue.action[self.actuel].valeur = dialogue.action[self.actuel].valeur + 1
					elseif dialogue.action[self.actuel].mode == ParamMode.BOOLEAN then 


					end
				end
			end
		end
		if pge.controls.pressed(PGE_CTRL_CROSS) then
			if dialogue.mode == DialogueMode.PARAM then
				dialogue.actionCross()
			else
				dialogue.action[self.actuel]:action()
			end
		end
		if pge.controls.pressed(PGE_CTRL_CIRCLE) then
			if Switch.states.currentState == "menu" and dialogue.nom ~= "menu" then
				self:returnToPD()
			else
				if self.aD == "menu" then
					Switch.stars:addStarExplosion(240,100,100,5)
				end
				self:setAD(nil)
			end
		end
	end

	function o:draw()
		
		local dialogue = self.dialogues[self.aD]
		
		local posRectX = (larg / 2) - (dialogue.tailleRectX / 2)
		local posRectY = (haut / 2) - (dialogue.tailleRectY / 2)
		
		pge.gfx.drawrect(posRectX, posRectY, dialogue.tailleRectX, dialogue.tailleRectY, self.dialoguesColor)
		
		if self.offSet > 0 then
			self.fleche:drawCenter(240, posRectY)
		end
		if dialogue.total - self.offSet > 5 then
			self.fleche:drawCenter(240, posRectY + dialogue.tailleRectY, nil, nil, math.rad(180))
		end
		
		acens30:drawCenter(posRectY - 40, dialogue.titre)
		
		for i = 1 + self.offSet, self.offSet + 5 do
			
			if dialogue.action[i] then
				local texte = dialogue.action[i].texte
				
				if dialogue.mode == DialogueMode.PARAM then
					texte = texte.." : "..dialogue.action[i].valeur
				end
				local couleur = blanc
				if i == self.actuel then
					couleur = rouge
				end
				acens20:drawCenter(posRectY + 10 + ((i - 1 - self.offSet) * 30), texte, couleur)
			end
		end
	end
   
	return o:construct()
end
	
