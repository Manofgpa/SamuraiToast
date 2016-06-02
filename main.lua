require "menu"

local gamera = require "gamera"

local cam = gamera.new(0,0,2000,2000)


function love.load()
  
 
	horadoshow = love.audio.newSource("sons/horadoshow.mp3","stream")

	--[[tasaino = love.audio.newSource("tasaino.mp3","stream")

	--grito = love.audio.newSource("grito.mp3","stream")

	--comimuito = love.audio.newSource("comimuito.mp3","stream")

	--boribilder = love.audio.newSource("boribilder.mp3","stream")

	--biur = love.audio.newSource("biur.mp3","stream")

	-- ajuda = love.audio.newSource("ajuda.mp3","stream")]]

	nyan = love.audio.newSource("sons/nyan.mp3","stream")







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







--butoes jogo



  if gamestate == "menu" then
	button_spawn(390,300,"Start","start")

	button_spawn(10,550,"Quit","sair")
end


  if gamestate == "jogando" then
      button_spawn(400,22,"Pause","pause")
    end
    

  

  timer= 0 

  momento = os.time()

  passado = 0 

  intervalo = 3

  count = 0 




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


    love.graphics.print("II",300,200)

		momento = os.time() 

    if (momento - passado) > intervalo then 

      enemyCall()  

      passado = os.time() 

      count = count + 1 

    if math.mod( count, 5 ) == 0 then

       intervalo = intervalo - 0.5 

         if intervalo <=  0.5 then 

            intervalo = 0.6 

        end   

    end 

    end 

  







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

     for j,s in ipairs(shots) do  -- percorre todas instancias da tabela shots

          s.pos_x = s.pos_x + s.dir_x * ( 150* dt ) 

          s.pos_y = s.pos_y + s.dir_y * (150*dt ) 

        end 

 

       for j,s in ipairs(shots) do  -- checa colisao de inimigos com o shot 

        for i,v in ipairs(enemy) do   

         if  checkCol(s.pos_x, s.pos_y, s.img:getWidth()/2, s.img:getHeight()/2, v.pos_x, v.pos_y, 4, 4)  then -- checando shots com inimigos 

              table.remove(enemy, i)

               table.remove(shots, j)

              end

           end 

        end 

        

        for i,v in ipairs(enemy) do -- percorre tabela de inimigos checa cada um com o heroi 

         if checkCol(hero.pos_x, hero.pos_y, hero.walk[hero.anim_frame]:getWidth()/2,hero.walk[hero.anim_frame]:getHeight()/2,

                                         v.pos_x, v.pos_y,5, 5) then -- checando hero com inimigos  

              hero.life = hero.life -  (40*dt)

         end

        

    end 

    

    width, height = love.window.getDesktopDimensions( display ) 

    

    for i,v in ipairs(shots) do  -- remove shots que alcancam as extremidades da tela 

      if v.pos_x >= width  then

          table.remove(shots, i ) 

        elseif v.pos_x <= 0 then 

         table.remove(shots, i)

        

       end 

      if v.pos_y >= height then 

          table.remove(shots, i ) 

        elseif v.pos_y <= 0 then 

         table.remove(shots, i)

      end 

    end 

   

    

   

 

end 

    if (love.keyboard.wasPressed("escape")) then

      love.event.quit() --SAIR DO JOGO

    end




 

 end 




 



love.keyboard.keysPressed = { }

love.keyboard.keysReleased = { }

-- returns if specified key was pressed since the last update

function love.keyboard.wasPressed(key)

	if (love.keyboard.keysPressed[key]) then

		return true

	else

		return false

	end

end

-- returns if specified key was released since last update

function love.keyboard.wasReleased(key)

	if (love.keyboard.keysReleased[key]) then

		return true

	else

		return false

	end

end

-- concatenate this to existing love.keypressed callback, if any

function love.keypressed(key, unicode)

	love.keyboard.keysPressed[key] = true

end

-- concatenate this to existing love.keyreleased callback, if any

function love.keyreleased(key)

	love.keyboard.keysReleased[key] = true

end

-- call in end of each love.update to reset lists of pressed\released keys

function love.keyboard.updateKeys()

	love.keyboard.keysPressed = { }

	love.keyboard.keysReleased = { }

end




hero= { 

	anim_frame= 1 , 

	walk = {} , 

	pos_x=400  , 

	pos_y= 300  , 

	velocidade = 120  ,

	anim_time=0, 

  life = 250

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

  

  for i, v in ipairs(enemy) do 

      if v.tipo == "gomba" then 

        v.img[1] = love.graphics.newImage("enemies/gomba1.png") 

        v.img[2] = love.graphics.newImage("enemies/gomba2.png")

      

      elseif v.tipo == "kopa" then  

        v.img[1] = love.graphics.newImage("enemies/kopa1.png") 

        v.img[2] = love.graphics.newImage("enemies/kopa2.png")

      

      end 

    end 




end 




shots = {}  -- table with all shurikens 

function shoot(x, y , dirx, diry) -- makes shuriken appear on the screen from pont where hero faces

  table.insert ( shots, {img = love.graphics.newImage("hero/shot.png"), pos_x = x, pos_y = y , 

      dir_x = dirx,   dir_y=diry,collision = false}) 

  end 

  

  

function checkCol( x1, y1, w1,h1, x2,y2,w2,h2) 

   return x1 < x2+w2 and x2 < x1+w1 and y1 < y2+h2 and y2 < y1+h1

end 




-------------------------------------------------------------------------




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




		love.graphics.draw(hero.walk[hero.anim_frame], hero.pos_x ,  -- desenha heroi

   hero.pos_y, 0, 1/2,1/2, hero.walk[hero.anim_frame]:getWidth()/2, hero.walk[hero.anim_frame]:getHeight()/2 )

    

    for i,v in ipairs(enemy) do

     love.graphics.draw( v.img[v.frame] , v.pos_x, v.pos_y)   -- draws enemies onscreen 

    end




local dir_y= 0  -- control shuriken aiming through hero frame

local dir_x= 1 







  if (love.keyboard.wasPressed("space")) then

    if hero.anim_frame>=9 and hero.anim_frame <= 12 then -- Up 

      dir_y = -1 

      dir_x = 0 

    end 

    if hero.anim_frame>=13 and hero.anim_frame <= 16  then -- Down

      dir_y = 1 

      dir_x= 0 

    end 

    if hero.anim_frame <= 4   then -- Left 

      dir_x= 1 

      dir_y= 0 

    end

    if hero.anim_frame>=5 and hero.anim_frame <= 8   then -- Righ 

      dir_x= -1 

    end

    

   

   shoot(hero.pos_x, hero.pos_y, dir_x , dir_y ) 

  

 end 

 

     for i, v in pairs(shots) do 

     love.graphics.draw( v.img, v.pos_x, v.pos_y ) 

     -- cheCol( v.pos_y, v.pos_x, v.img:getWidth()/2, v.img:getHeight()/2) 

     love.keyboard.updateKeys()

   end 

    

 love.graphics.setColor(100,0,0)

 love.graphics.rectangle("fill", 10, 15, hero.life , 15 ) 
 love.graphics.setColor(255,255,255)
 love.graphics.setFont(fonte,50)
 --love.graphics.print("PAUSE",400,22)
end 


love.graphics.setColor(255, 255, 255) 






-- git



	if gamestate == "menu" then

		love.graphics.draw(menu,0,0,ox,1.35)

		love.graphics.draw(samuraimenu,140,100)

		button_draw()




	end

end 