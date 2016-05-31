
--configura o menu do jogo

button = {}


function button_spawn(x,y,text,id)
	table.insert(button,{ x = x, y = y, text = text, id = id})
end

function button_draw()
	for i,v in ipairs(button) do
		love.graphics.draw(menu,0,0,ox,0.75)
		love.graphics.setColor(255,255,255)
		love.graphics.print(v.text,v.x,v.y,ox,2)
	end
end

function button_click(x,y)
	for i,v in ipairs(button) do
		if x > v.x and x < v.x + fonte:getWidth(v.text) and y > v.y and y < v.y + fonte:getHeight() then
			if v.id == "sair" then
				love.event.quit()
			end
		end
	end
end