function TileIsInPlateau(x,y)

	if x < 1 or x > game.plateau.largeur or y < 1 or y > game.plateau.hauteur then
		return false
	end
	return true
end

function TileIsMine(x,y)

	if TileIsInPlateau(x,y) then
		return game.plateau.cases[x][y].mine
	end
	return false
end

function getTileNumero(x,y)

	local mines = 0
	
	if TileIsMine(x,y) then
		return nil
	end

	for i = x - 1, x + 1 do
		for j = y - 1, y + 1 do
			if TileIsMine(i,j) then
				mines = mines+ 1

			end
		end
	end
	return mines
end
