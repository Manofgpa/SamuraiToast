require "menu"


hero= { 
	anim_frame= 1 , 
	walk = {} , 
	pos_x=100  , 
	pos_y= 225  , 
	velocidade = 120  ,
	anim_time=0
}

local tilesetImage
local tileQuads = {}
local tileSize = 16

function LoadTiles(filename, nx, ny)
	tilesetImage = love.graphics.newImage(filename)
	local count = 1
	for i = 0, nx, 1 do
		for j = 0, ny, 1 do
			tileQuads[count] = love.graphics.newQuad(i * tileSize ,j * tileSize, tileSize, tileSize,tilesetImage:getWidth(), tilesetImage:getHeight())

			count = count + 1
		end
	end
end

local mapa={} 
function LoadMap(filename)


	local file = io.open(filename)
	local i = 1
	for line in file:lines() do
		mapa[i] = {}
		for j=1, #line, 1 do
			mapa[i][j] = line:sub(j,j)
		end
		i = i + 1
	end
	file:close()
end






enemy= {} --tabela com todos os inimigos do jogo

function enemy.spawn(tipo, x, y)
	table.insert(enemy, {pos_x=x, pos_y=y, tipo=tipo, anim_time=0, img={}, frame=1})
end




function enemyCall() --faz inimigos surgir na tela de tipos aleatorios e margens aleatorias
	tipo =  1 --[[enquanto n temos imagens para os inimigos vou deixar com so um tipo para poder rodar os testes--love.math.random(1,3)  -- cada numero equivale a um tipo, define aleatoriamente os tipos de inimigo --]]
	if (tipo == 1) then 
		tipo= "gomba" 
	else if (tipo == 2) then
		tipo = "kopa" 
	else 
		tipo= "turtle" 
	end end 

	sp = love.math.random(0,1)  -- difinem de qual margem da tela inimigos irao surgir 
	sp2 = love.math.random(0,1) 
	if (sp == 1) then 
		if (sp2 == 1 ) then 
			enemy.spawn(tipo, love.math.random(0,800), 0 )  
		else 
			enemy.spawn(tipo, love.math.random(0,800), 600 )  
		end 
	else 
		if (sp2 == 1 ) then 
			enemy.spawn(tipo, 0,  love.math.random(0,600) )  
		else 
			enemy.spawn(tipo, 800, love.math.random(0,600))  
		end 
	end 
end 
-------------------------------------------------------------------------
function love.load()

	horadoshow = love.audio.newSource("sons/horadoshow.mp3","stream")
	--[[tasaino = love.audio.newSource("tasaino.mp3","stream")
	--grito = love.audio.newSource("grito.mp3","stream")
	--comimuito = love.audio.newSource("comimuito.mp3","stream")
	--boribilder = love.audio.newSource("boribilder.mp3","stream")
	--biur = love.audio.newSource("biur.mp3","stream")
	-- ajuda = love.audio.newSource("ajuda.mp3","stream")]]
	source = love.audio.newSource("sons/nyan.mp3","stream")


	samuraimenu = love.graphics.newImage ("menu/samuraimenu.png")
	fonte = love.graphics.newFont("fontes/fonteninja.ttf",40)
-- love.window.setFullscreen(true) -- FULLSCREEN
	gamestate = "menu"
	menu = love.graphics.newImage("menu/backgroundi.png")


	LoadMap("mapa/mapa.txt") -- chama funcao Load Map que carrega mapa do jogo vindo do arquivo txt
	LoadTiles("mapa/sheet.png",13,8)



	for x = 1, 9, 1 do -- carrega instancia "walk" da tabela "hero" com imagens da caminhada do heroi

		hero.walk[x] = love.graphics.newImage("hero/Hero_Walk_0" .. x .. ".png")
	end

	timer= 0 

	enemyCall() -- cria os inimigos 

--butoes jogo

	button_spawn(390,300,"Start","start")
	button_spawn(10,550,"Quit","sair")

end
function love.mousepressed(x,y)
	if gamestate == "menu" then
		button_click(x,y)
	end
end
-------------------------------------------------------------------------
function love.update(dt)


	mousex = love.mouse.getX()
	mousey = love.mouse.getY()

	if gamestate == "menu" then
		button_check()
	end

	if gamestate == "jogando" then

		timer = timer + dt 


		if love.keyboard.isDown("right") then
			hero.pos_x = hero.pos_x + (hero.velocidade * dt)
			hero.anim_time = hero.anim_time + dt -- incrementa o tempo usando dt
			if hero.anim_time > 0.1 then -- quando acumular mais de 0.1
				hero.anim_frame = hero.anim_frame + 1 -- avança para proximo frame
				if hero.anim_frame > 4 then 
					hero.anim_frame = 1
				end
				hero.anim_time = 0 -- reinicializa a contagem do tempo
			end
		end


		if love.keyboard.isDown("left") then
			hero.pos_x = hero.pos_x - (hero.velocidade * dt)
			hero.anim_time = hero.anim_time + dt -- incrementa o tempo usando dt
			if hero.anim_time > 0.1 then -- quando acumular mais de 0.1
				hero.anim_frame = hero.anim_frame + 1 -- avança para proximo frame
				if hero.anim_frame<5 or hero.anim_frame > 8 then 
					hero.anim_frame = 5
				end
				hero.anim_time = 0 -- reinicializa a contagem do tempo
			end
		end

		if love.keyboard.isDown("down") then
			hero.pos_y = hero.pos_y + (hero.velocidade * dt)
			hero.anim_time = hero.anim_time + dt -- incrementa o tempo usando dt
			if hero.anim_time > 0.1 then -- quando acumular mais de 0.1
				hero.anim_frame = hero.anim_frame + 1 -- avança para proximo frame
				if hero.anim_frame<5 or hero.anim_frame > 8 then 
					hero.anim_frame = 5
				end
				hero.anim_time = 0 -- reinicializa a contagem do tempo
			end
		end

		if love.keyboard.isDown("up") then
			hero.pos_y = hero.pos_y - (hero.velocidade * dt)
			hero.anim_time = hero.anim_time + dt -- incrementa o tempo usando dt
			if hero.anim_time > 0.1 then -- quando acumular mais de 0.1
				hero.anim_frame = hero.anim_frame + 1 -- avança para proximo frame
				if hero.anim_frame<5 or hero.anim_frame > 8 then 
					hero.anim_frame = 1
				end
				hero.anim_time = 0 -- reinicializa a contagem do tempo
			end
		end

		local dist_x= 1 
		local dist_y= 1

		for i,v in ipairs(enemy) do
			if v.tipo == "gomba" then
				v.anim_time = v.anim_time + dt 
				if v.anim_time > 0.2 then 
					v.frame = v.frame +1 
					if v.frame > 2 then 
						v.frame=1
					end 
					v.anim_time= 0 
				end 
			end 

			dist_x= hero.pos_x - v.pos_x
			dist_y= hero.pos_y - v.pos_y

			if dist_x <= 0 then
				v.pos_x = v.pos_x - (80 *dt) 
			end 

			if dist_y  <= 0  then 
				v.pos_y = v.pos_y - (80 *dt) 
			end 

			if dist_x >= 0  then     
				v.pos_x = v.pos_x + (80 *dt) 
			end

			if dist_y >= 0  then     
				v.pos_y = v.pos_y + (80 *dt) 
			end 


		end 
	end
end 

--------------------------------------------------------------------------------------------------
function love.draw()

	if gamestate == "jogando" then

		for i=1, 37, 1 do --Percorre a matriz e desenha quadrados imagens
			for j=1, 70, 1 do
				if (mapa[i][j] == "G") then 
					love.graphics.draw(tilesetImage, tileQuads[60], (j * tileSize) - tileSize, (i * tileSize) - tileSize)
				elseif (mapa[i][j] == "D") then
					love.graphics.draw(love.graphics.newImage("hero/tree.png"),(j * tileSize) - tileSize, (i * tileSize) - tileSize)
				elseif (mapa[i][j] == "C") then
					love.graphics.draw(tilesetImage, tileQuads[7], (j * tileSize) - tileSize, (i * tileSize) - tileSize)
				elseif (mapa[i][j] == "P") then
					love.graphics.draw(tilesetImage, tileQuads[8],(j * tileSize) - tileSize, (i * tileSize) - tileSize)
				elseif (mapa[i][j] == "B") then
					love.graphics.draw(tilesetImage, tileQuads[6],(j * tileSize) - tileSize, (i * tileSize) - tileSize)
				end
			end
		end





		love.graphics.setColor(255, 255, 255) 

		love.graphics.draw(hero.walk[hero.anim_frame], hero.pos_x , hero.pos_y, 0, 1/2,1/2, hero.walk[hero.anim_frame]:getWidth()/2, hero.walk[hero.anim_frame]:getHeight()/2 )




		for i,v in ipairs(enemy) do
			if v.tipo == "gomba" then 
				v.img[1] = love.graphics.newImage("enemies/gomba1.png") 
				v.img[2] = love.graphics.newImage("enemies/gomba2.png")
			end 

			love.graphics.draw( v.img[v.frame] , v.pos_x, v.pos_y)


		end
	end

	if gamestate == "menu" then
		love.graphics.draw(menu,0,0,ox,1.35)
		love.graphics.draw(samuraimenu,140,100)
		button_draw()

	end
end 

function love.keypressed(key)

	if key =="escape" then -- SAIR DO JOGO

		love.event.quit()

	end
end