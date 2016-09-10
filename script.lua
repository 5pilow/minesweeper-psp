dofile("plateau.lua")
dofile("souris.lua")
dofile("utils.lua")
dofile("sprite.lua")
dofile("dialogues.lua")
dofile("font.lua")
dofile("feuArtifice.lua")
dofile("sang.lua")

acens20 = newFont("acens.ttf",20)
acens30 = newFont("acens.ttf",30)

youloose = pge.texture.load("youloose.png")

boom = pge.wav.load("boom.wav")

UP = 1
RIGHT = 2
DOWN = 3
LEFT = 4

noir = pge.gfx.createcolor(0,0,0)
rouge = pge.gfx.createcolor(255,0,0)

casevide = newSprite("sprite.png",8*40, 0, 40, 40)
casegrise = newSprite("sprite.png",9*40, 0, 40, 40)
caseMine = newSprite("sprite.png",10*40, 0, 40, 40)
casedrapeau = newSprite("sprite.png",11*40, 0, 40, 40)

cases = {}
for i = 1,8 do 
	cases[i] = newSprite("sprite.png",(i-1)*40, 0, 40, 40)
end

dirs = {{0,-1},{1,0},{0,1},{-1,0}}
dirs2 = {{-1,-1},{0,-1},{1,-1},{1,0},{1,1},{0,1},{-1,1},{-1,0}}

dialogues = newDialogues()
feuArtifice = newFeuArtifice()
sangSystem = newSangSystem()

game = {}
game.frame = 0

function game:load()

	game.plateau = newPlateau()
	game.plateau:load()
	game.plateau:distributeMines()
	game.plateau:distributeNumeros()
		
	game.souris  = newSouris()
end

function game:update()

	game.frame = game.frame + 1

	pge.controls.update()

	if pge.controls.pressed(PGE_CTRL_UP) then
		game.souris:move(UP)
	end
	if pge.controls.pressed(PGE_CTRL_RIGHT) then
		game.souris:move(RIGHT)
	end
	if pge.controls.pressed(PGE_CTRL_DOWN) then
		game.souris:move(DOWN)
	end
	if pge.controls.pressed(PGE_CTRL_LEFT) then
		game.souris:move(LEFT)
	end
	if pge.controls.pressed(PGE_CTRL_CIRCLE) then
		feuArtifice:addFeuArtifice(math.random(40,430), math.random(20,252), math.random(10,25), math.random(1,4))
	end
	if pge.controls.pressed(PGE_CTRL_RTRIGGER) then
		sangSystem:addTache(math.random(0,480), math.random(0,272), math.random(10,50))
	end
	
	if pge.controls.pressed(PGE_CTRL_CROSS) then
		if etat == "game" then
			game.plateau:demine(game.souris.pos.x, game.souris.pos.y)
		elseif etat == "looser" then
			game:replay()
		end	
	end
	if pge.controls.pressed(PGE_CTRL_SQUARE) then
		game.plateau:dropDrapeau(game.souris.pos.x, game.souris.pos.y)
	end
	
	if pge.controls.pressed(PGE_CTRL_TRIANGLE) then
		caca()
	end
end

function game:draw()
	
	game.plateau:draw()
	game.souris:draw()
end

function game:loose()
etat = "looser"
	boom:play()
	game:devoileMines()
	
end

function game:win()
	game:devoileMines()
end

function game:devoileMines()
	for x = 1, game.plateau.largeur do
		for y = 1, game.plateau.hauteur do
			if game.plateau.cases[x][y].mine then
				game.plateau.cases[x][y].retournee = true
			end
		end
	end
end

function game:replay()
	
	etat = "game"
	
	for x = 1, game.plateau.largeur do
		for y = 1, game.plateau.hauteur do
			game.plateau.cases[x][y].retournee = false
			game.plateau.cases[x][y].mine = false
			game.plateau.cases[x][y].drapeau = false
			
		end
	end
	game.plateau:distributeMines()
	game.plateau:distributeNumeros()
	

end

game:load()

etats = {
["game"] = 1,
["looser"] = 2,
["winner"] = 3
}

etat = "game"

activeRessource = nil
larg, haut = 480, 272

--dialogues:setAD("menu")


while pge.running() do
	
	feuArtifice:update()
	sangSystem:update()
	
	if not dialogues.aD then
		game:update()
	else
		dialogues:update()
	end
	
	pge.gfx.startdrawing()
	pge.gfx.clearscreen()
	
	game:draw()
	if dialogues.aD then
		dialogues:draw()
	end
	if etat == "looser" then
		activeRessource = ""
		youloose:activate()
		youloose:draw(0,50)
	end
	
	feuArtifice:draw()
	sangSystem:draw()
	
	pge.gfx.enddrawing()
	pge.gfx.swapbuffers(false)
end
