local screen = {}

function timescreen(x, y)
    love.graphics.print({3, love.timer.getTime}, 10, 10)
end

function screen.draw(p)
     love.graphics.setColor(255,255,255)
    -- love.graphics.rectangle("fill", p.hpbar, 45, 5, 15)
     love.graphics.rectangle("fill", 100, 45, 5, 15)
end
return screen