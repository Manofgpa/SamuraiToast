
--configura o menu do jogo

button = {}


function button_spawn(x,y,text,id)
	table.insert(button, {x = x,y = y, text = text, id = id})
end

function button_draw()
	for i,v in ipairs(button) do

		love.graphics.setFont(fonte)
		love.graphics.print(v.text,v.x,v.y)


	end
end

function button_click(x,y)
	for i,v in ipairs(button) do
		if x > v.x and x < v.x + fonte:getWidth(v.text) and y > v.y and y < v.y + fonte:getHeight() then
			if v.id == "sair" then
				love.event.quit()
			end
			if v.id == "start" then
				gamestate = "jogando"
			end
		end
	end
end